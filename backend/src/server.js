import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pg from 'pg';
import { createServer } from 'http';
import { Server } from 'socket.io';
import crypto from 'crypto';
import { RtcTokenBuilder, RtcRole } from 'agora-token';

const { Pool } = pg;
const app = express();
const http = createServer(app);
const io = new Server(http, { cors: { origin: process.env.CORS_ORIGIN?.split(',') ?? '*', credentials: true } });
const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const PORT = Number(process.env.PORT || 8080);
const JWT_SECRET = process.env.JWT_SECRET || 'dev-only-secret';

app.use(cors({ origin: process.env.CORS_ORIGIN?.split(',') ?? true, credentials: true }));
app.use(express.json({ limit: '1mb' }));
app.get('/health', (_, res) => res.json({ ok: true, service: 'toyo-api', time: new Date().toISOString() }));

function token(user) { return jwt.sign({ sub: user.id, role: user.role || 'user' }, JWT_SECRET, { expiresIn: '30d' }); }
async function auth(req,res,next){ try { const h=req.headers.authorization||''; if(!h.startsWith('Bearer ')) return res.status(401).json({error:'UNAUTHORIZED'}); req.user=jwt.verify(h.slice(7),JWT_SECRET); next(); } catch { res.status(401).json({error:'UNAUTHORIZED'}); } }
function admin(req,res,next){ if(req.user?.role!=='admin') return res.status(403).json({error:'ADMIN_ONLY'}); next(); }
async function q(text, params=[]){ return pool.query(text,params); }

app.post('/api/auth/register', async (req,res)=>{
  try {
    const {email,password,displayName,country='EG'}=req.body;
    if(!email||!password||!displayName) return res.status(400).json({error:'MISSING_FIELDS'});
    const hash=await bcrypt.hash(password,12);
    const publicId=Number(String(Date.now()).slice(-8));
    const r=await q(`insert into users(email,password_hash,role) values($1,$2,'user') returning id,email,role`,[email.toLowerCase(),hash]);
    const u=r.rows[0];
    await q(`insert into profiles(user_id,public_id,username,display_name,country) values($1,$2,$3,$4,$5)`,[u.id,publicId,email.split('@')[0].replace(/[^a-z0-9_]/gi,'').slice(0,20)||`user${publicId}`,displayName,country]);
    res.status(201).json({token:token(u),user:{id:u.id,email:u.email,role:u.role}});
  } catch(e){ res.status(400).json({error:'REGISTER_FAILED',detail:e.code==='23505'?'EMAIL_EXISTS':undefined}); }
});

app.post('/api/auth/login', async (req,res)=>{
  const {email,password}=req.body||{};
  const r=await q(`select id,email,password_hash,role,status from users where email=$1`,[(email||'').toLowerCase()]);
  if(!r.rowCount || r.rows[0].status!=='active' || !(await bcrypt.compare(password||'',r.rows[0].password_hash))) return res.status(401).json({error:'INVALID_CREDENTIALS'});
  const u=r.rows[0]; res.json({token:token(u),user:{id:u.id,email:u.email,role:u.role}});
});

app.get('/api/me',auth,async(req,res)=>{ const r=await q(`select u.id,u.email,u.role,u.status,p.* from users u left join profiles p on p.user_id=u.id where u.id=$1`,[req.user.sub]); res.json(r.rows[0]||null); });
app.post('/api/rtc/token',auth,async(req,res)=>{
  try {
    const {roomId,role='audience'}=req.body||{};
    if(!roomId) return res.status(400).json({error:'ROOM_REQUIRED'});
    if(!process.env.AGORA_APP_ID || !process.env.AGORA_APP_CERTIFICATE) return res.status(503).json({error:'RTC_NOT_CONFIGURED'});
    const room=(await q('select id,name from rooms where id=$1 and status=\'live\'',[roomId])).rows[0];
    if(!room) return res.status(404).json({error:'ROOM_NOT_FOUND'});
    const account=String(req.user.sub);
    const ttl=Math.max(300,Number(process.env.AGORA_TOKEN_TTL_SECONDS||3600));
    const expire=Math.floor(Date.now()/1000)+ttl;
    const rtcRole=role==='publisher'?RtcRole.PUBLISHER:RtcRole.SUBSCRIBER;
    const token=RtcTokenBuilder.buildTokenWithAccount(process.env.AGORA_APP_ID,process.env.AGORA_APP_CERTIFICATE,`room_${roomId}`,account,rtcRole,expire);
    res.json({appId:process.env.AGORA_APP_ID,channelName:`room_${roomId}`,uid:account,token,role:rtcRole===RtcRole.PUBLISHER?'publisher':'audience',expiresAt:expire});
  } catch(e) { res.status(500).json({error:'RTC_TOKEN_FAILED'}); }
});

app.get('/api/rooms',async(req,res)=>{ const r=await q(`select r.*,p.display_name as owner_name from rooms r left join profiles p on p.user_id=r.owner_id where r.status='live' order by r.viewer_count desc, r.created_at desc limit 100`); res.json(r.rows); });
app.post('/api/rooms',auth,async(req,res)=>{ const {name,description='',category='general',country='EG',maxSeats=8}=req.body||{}; if(!name) return res.status(400).json({error:'NAME_REQUIRED'}); const r=await q(`insert into rooms(owner_id,name,description,category,country,max_seats,status) values($1,$2,$3,$4,$5,$6,'live') returning *`,[req.user.sub,name,description,category,country,Math.min(Math.max(Number(maxSeats)||8,1),15)]); res.status(201).json(r.rows[0]); });
app.post('/api/rooms/:id/join',auth,async(req,res)=>{ const r=await q(`insert into room_members(room_id,user_id) values($1,$2) on conflict do nothing returning *`,[req.params.id,req.user.sub]); await q(`update rooms set viewer_count=viewer_count+1 where id=$1`,[req.params.id]); res.json({joined:true,member:r.rows[0]||null}); });
app.post('/api/rooms/:id/leave',auth,async(req,res)=>{ await q(`delete from room_members where room_id=$1 and user_id=$2`,[req.params.id,req.user.sub]); await q(`update rooms set viewer_count=greatest(viewer_count-1,0) where id=$1`,[req.params.id]); res.json({left:true}); });
app.get('/api/rooms/:id/messages',auth,async(req,res)=>{ const r=await q(`select m.*,p.display_name,p.avatar_url from room_messages m join profiles p on p.user_id=m.user_id where m.room_id=$1 order by m.created_at desc limit 100`,[req.params.id]); res.json(r.rows.reverse()); });
app.post('/api/rooms/:id/messages',auth,async(req,res)=>{ const text=String(req.body?.text||'').trim(); if(!text||text.length>500) return res.status(400).json({error:'INVALID_MESSAGE'}); const r=await q(`insert into room_messages(room_id,user_id,text) values($1,$2,$3) returning *`,[req.params.id,req.user.sub,text]); const msg=r.rows[0]; io.to(`room:${req.params.id}`).emit('room:message',msg); res.status(201).json(msg); });
app.get('/api/wallet',auth,async(req,res)=>{ const r=await q(`select currency,coalesce(sum(amount),0)::bigint balance from wallet_ledger where user_id=$1 group by currency`,[req.user.sub]); res.json(r.rows); });
app.post('/api/gifts/send',auth,async(req,res)=>{
  const {roomId,receiverId,giftId,quantity=1,idempotencyKey=crypto.randomUUID()}=req.body||{};
  const c=await pool.connect(); try { await c.query('begin'); const g=(await c.query(`select * from gifts where id=$1 and active=true`,[giftId])).rows[0]; if(!g) throw new Error('GIFT_NOT_FOUND'); const total=BigInt(g.price)*BigInt(quantity); const bal=(await c.query(`select coalesce(sum(amount),0)::bigint balance from wallet_ledger where user_id=$1 and currency='coins'`,[req.user.sub])).rows[0].balance; if(BigInt(bal)<total) throw new Error('INSUFFICIENT_COINS'); await c.query(`insert into wallet_ledger(user_id,currency,amount,type,reference_id,metadata) values($1,'coins',$2,'gift_spend',$3,$4),($1,'diamonds',$5,'gift_receive',$3,$6)`,[req.user.sub,(-total).toString(),idempotencyKey,JSON.stringify({roomId,receiverId,giftId,quantity}),total.toString(),JSON.stringify({roomId,senderId:req.user.sub,giftId,quantity})]); const t=await c.query(`insert into gift_transactions(sender_id,receiver_id,room_id,gift_id,quantity,unit_price,total_price,idempotency_key) values($1,$2,$3,$4,$5,$6,$7,$8) returning *`,[req.user.sub,receiverId||null,roomId,giftId,quantity,g.price,total.toString(),idempotencyKey]); await c.query('commit'); io.to(`room:${roomId}`).emit('room:gift',t.rows[0]); res.status(201).json(t.rows[0]); } catch(e){ await c.query('rollback'); res.status(400).json({error:e.message}); } finally { c.release(); }
});

app.get('/api/admin/stats',auth,admin,async(_,res)=>{ const [u,r,g,c]=await Promise.all([q(`select count(*)::int n from users`),q(`select count(*)::int n from rooms where status='live'`),q(`select count(*)::int n from gift_transactions where created_at>now()-interval '1 day'`),q(`select coalesce(sum(amount),0)::bigint n from wallet_ledger where currency='coins'`)]); res.json({users:u.rows[0].n,liveRooms:r.rows[0].n,giftsToday:g.rows[0].n,coins:c.rows[0].n}); });
app.get('/api/admin/users',auth,admin,async(req,res)=>{ const r=await q(`select u.id,u.email,u.role,u.status,p.public_id,p.display_name,p.level,p.vip_level from users u left join profiles p on p.user_id=u.id order by u.created_at desc limit 200`); res.json(r.rows); });
app.patch('/api/admin/users/:id/status',auth,admin,async(req,res)=>{ const status=['active','suspended','banned'].includes(req.body?.status)?req.body.status:null; if(!status) return res.status(400).json({error:'INVALID_STATUS'}); await q(`update users set status=$1 where id=$2`,[status,req.params.id]); await q(`insert into audit_logs(actor_id,action,target_type,target_id,payload) values($1,'user_status','user',$2,$3)`,[req.user.sub,req.params.id,JSON.stringify({status})]); res.json({ok:true}); });
app.get('/api/admin/reports',auth,admin,async(_,res)=>{ const r=await q(`select * from reports order by created_at desc limit 200`); res.json(r.rows); });

io.use((socket,next)=>{ try { const t=socket.handshake.auth?.token; socket.user=jwt.verify(t,JWT_SECRET); next(); } catch { next(new Error('UNAUTHORIZED')); } });
io.on('connection',socket=>{ socket.on('room:join',roomId=>socket.join(`room:${roomId}`)); socket.on('room:leave',roomId=>socket.leave(`room:${roomId}`)); });

http.listen(PORT,()=>console.log(`TOYO API listening on :${PORT}`));
