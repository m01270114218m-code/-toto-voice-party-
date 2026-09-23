const http=require('http'),fs=require('fs'),path=require('path'),crypto=require('crypto');
let Server;try{({Server}=require('socket.io'))}catch{Server=class{on(){return this}emit(){}}}
const {supabaseRequest,authRequest,getUser}=require('./supabase-rest');
const root=path.join(__dirname,'public'),dataDir=path.join(__dirname,'data'),PORT=Number(process.env.PORT||3000),APP_URL=process.env.PUBLIC_APP_URL||('http://localhost:'+PORT),ADMIN_USER=process.env.ADMIN_USER||'admin',ADMIN_PASSWORD=process.env.ADMIN_PASSWORD||'CHANGE_THIS_STRONG_PASSWORD';
const files={config:'config.json',content:'content.json',rooms:'rooms.json',gifts:'gifts.json',categories:'categories.json',events:'events.json',users:'users.json',notifications:'notifications.json',follows:'follows.json',reports:'reports.json',messages:'messages.json',walletLedger:'wallet-ledger.json',roomActions:'room-actions.json'};
const state={rooms:new Map(),rate:new Map()};
function read(n){try{return JSON.parse(fs.readFileSync(path.join(dataDir,n),'utf8'))}catch{return []}}
function write(n,v){fs.writeFileSync(path.join(dataDir,n),JSON.stringify(v,null,2),'utf8')}
function json(res,status,obj){res.writeHead(status,{'Content-Type':'application/json; charset=utf-8','Cache-Control':'no-store','Access-Control-Allow-Origin':process.env.CORS_ORIGIN||'*','Access-Control-Allow-Headers':'Content-Type, Authorization','Access-Control-Allow-Methods':'GET,POST,OPTIONS'});res.end(JSON.stringify(obj))}
function body(req){return new Promise((resolve,reject)=>{let s='';req.on('data',c=>{s+=c;if(s.length>2e6)reject(Error('body_too_large'))});req.on('end',()=>{try{resolve(s?JSON.parse(s):{})}catch(e){reject(e)}})})}
function token(payload){return Buffer.from(JSON.stringify(payload)).toString('base64url')+'.'+crypto.createHash('sha256').update(JSON.stringify(payload)+(process.env.AUTH_SECRET||'dev-secret')).digest('hex')}
function admin(req){
 const supplied=(req.headers.authorization||'').replace('Bearer ','');
 const expected=token({sub:'admin',role:'admin',v:1});
 return !!supplied && crypto.timingSafeEqual(Buffer.from(supplied),Buffer.from(expected));
}
function localUser(req){
 const t=(req.headers.authorization||'').replace('Bearer ','');if(!t)return null;
 try{
  const parts=t.split('.');if(parts.length!==2)return null;
  const p=JSON.parse(Buffer.from(parts[0],'base64url'));
  if(p.exp&&p.exp<Date.now())return null;
  const expected=crypto.createHash('sha256').update(JSON.stringify(p)+(process.env.AUTH_SECRET||'dev-secret')).digest('hex');
  if(!crypto.timingSafeEqual(Buffer.from(parts[1]),Buffer.from(expected)))return null;
  return p;
 }catch{return null}
}
function limited(key,max,window){const now=Date.now(),a=state.rate.get(key)||[];const b=a.filter(x=>x>now-window);if(b.length>=max)return false;b.push(now);state.rate.set(key,b);return true}
const mime={'.html':'text/html; charset=utf-8','.js':'application/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.json':'application/json; charset=utf-8','.webmanifest':'application/manifest+json','.svg':'image/svg+xml','.png':'image/png','.jpg':'image/jpeg','.jpeg':'image/jpeg','.webp':'image/webp'};
const server=http.createServer(async(req,res)=>{
 if(req.method==='OPTIONS')return json(res,204,{});
 try{
  const u=new URL(req.url,APP_URL),key=u.pathname.replace(/^\/api\//,'');
  if(u.pathname==='/api/health')return json(res,200,{ok:true,service:'royal-voice',version:'4.2.0-full-clean',time:new Date().toISOString()});
  if(u.pathname==='/api/connection/status')return json(res,200,{ok:true,supabase:!!process.env.SUPABASE_URL,database:!!process.env.SUPABASE_URL});
  if(u.pathname.startsWith('/api/')){
   if(req.method==='GET'&&files[key])return json(res,200,read(files[key]));
   if(req.method==='POST'&&files[key]){if(!admin(req))return json(res,403,{ok:false,error:'admin_required'});const x=await body(req);write(files[key],x);io.emit('cms:update');return json(res,200,{ok:true,data:x})}
   if(key==='auth/admin/login'&&req.method==='POST'){const x=await body(req);if(x.username!==ADMIN_USER||x.password!==ADMIN_PASSWORD)return json(res,401,{ok:false,error:'invalid_admin_credentials'});return json(res,200,{ok:true,token:token({sub:'admin',role:'admin',v:1})})}
   if(key==='admin/session'&&req.method==='GET')return json(res,admin(req)?200:401,{ok:admin(req)});
   if(key==='connected/auth/register'&&req.method==='POST'){try{return json(res,200,await authRequest('signup',await body(req)))}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='connected/auth/login'&&req.method==='POST'){try{const x=await body(req),d=await authRequest('token?grant_type=password',x);return json(res,200,{ok:true,session:d})}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='connected/me'&&req.method==='GET'){const t=(req.headers.authorization||'').replace('Bearer ','');if(!t)return json(res,401,{ok:false});const au=await getUser(t);if(!au)return json(res,401,{ok:false});try{const rows=await supabaseRequest('profiles',{token:t,query:'select=*&id=eq.'+encodeURIComponent(au.id)+'&limit=1'});return json(res,200,{ok:true,authUser:au,profile:rows[0]||null})}catch(e){return json(res,503,{ok:false,error:'database_unavailable'})}}
   if(key==='connected/rooms'&&req.method==='GET'){try{const rows=await supabaseRequest('rooms',{query:'select=*&status=eq.live&order=created_at.desc'});return json(res,200,rows)}catch(e){return json(res,503,{ok:false,error:'database_unavailable'})}}
   if(key==='connected/gifts'&&req.method==='GET'){try{const rows=await supabaseRequest('gifts',{query:'select=*&active=eq.true&order=created_at.desc'});return json(res,200,rows)}catch(e){return json(res,503,{ok:false,error:'database_unavailable'})}}
   if(key==='connected/rooms/create'&&req.method==='POST'){const t=(req.headers.authorization||'').replace('Bearer ','');const au=await getUser(t);if(!au)return json(res,401,{ok:false});const x=await body(req);try{const rows=await supabaseRequest('rooms',{method:'POST',token:t,body:{owner_id:au.id,name:x.name,description:x.description||'',category:x.category||'general',country:x.country||'EG',status:'live'},query:'select=*'});return json(res,201,{ok:true,room:rows[0]})}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='connected/seat/assign'&&req.method==='POST'){const t=(req.headers.authorization||'').replace('Bearer ','');if(!await getUser(t))return json(res,401,{ok:false});const x=await body(req);try{await supabaseRequest('rpc/assign_seat',{method:'POST',token:t,body:{p_room:x.roomId,p_seat:Number(x.seat)}});return json(res,200,{ok:true})}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='connected/gift/send'&&req.method==='POST'){const t=(req.headers.authorization||'').replace('Bearer ','');if(!await getUser(t))return json(res,401,{ok:false});const x=await body(req);try{const tx=await supabaseRequest('rpc/send_gift',{method:'POST',token:t,body:{p_receiver:x.receiverId,p_gift:x.giftId,p_quantity:Number(x.quantity||1),p_room:x.roomId||null}});return json(res,200,{ok:true,transactionId:tx})}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='connected/manual-topups'&&req.method==='GET'){const t=(req.headers.authorization||'').replace('Bearer ','');try{const methods=await supabaseRequest('manual_payment_methods',{token:t,query:'select=*&is_active=eq.true&order=sort_order.asc'});const topups=await supabaseRequest('wallet_topups',{token:t,query:'select=*&order=created_at.desc&limit=100'});return json(res,200,{ok:true,methods,topups})}catch(e){return json(res,503,{ok:false,error:'database_unavailable'})}}
   if(key==='connected/manual-topups/review'&&req.method==='POST'){const t=(req.headers.authorization||'').replace('Bearer ','');const au=await getUser(t);if(!au)return json(res,401,{ok:false});const x=await body(req);try{const r=await supabaseRequest('rpc/review_manual_topup',{method:'POST',token:t,body:{p_topup_id:x.topup_id,p_status:x.status,p_note:x.note||null}});return json(res,200,{ok:true,result:r})}catch(e){return json(res,400,{ok:false,error:e.message})}}
   if(key==='room/create'&&req.method==='POST'){const p=localUser(req)||{sub:'U1001'};const x=await body(req),rooms=read('rooms.json');const r={id:'R'+Date.now(),name:x.name||'غرفة جديدة',description:x.description||'',owner:(read('users.json').find(z=>z.id===p.sub)||{}).name||'Host',ownerId:p.sub,online:1,live:true,level:1,gifts:0,hue:Math.floor(180+Math.random()*150),country:x.country||'مصر',category:x.category||'general',announcement:'أهلاً بالجميع ✨',isPrivate:false,maxListeners:500,createdAt:new Date().toISOString()};rooms.unshift(r);write('rooms.json',rooms);io.emit('cms:update');return json(res,201,{ok:true,room:r})}
   if(key==='gift/transfer'&&req.method==='POST'){return json(res,410,{ok:false,error:'legacy_demo_removed',message:'Use authenticated connected/gift/send'})}
   if(key==='admin/reports'&&req.method==='GET'){if(!admin(req))return json(res,403,{ok:false});return json(res,200,read('reports.json'))}
   if(key==='admin/moderation'&&req.method==='POST'){if(!admin(req))return json(res,403,{ok:false});const x=await body(req),a=read('room-actions.json');a.push({...x,id:crypto.randomUUID(),createdAt:new Date().toISOString()});write('room-actions.json',a);io.emit('cms:update');return json(res,200,{ok:true})}
   return json(res,404,{ok:false,error:'not_found'});
  }
  let p=u.pathname==='/'?'/index.html':u.pathname;
  if(u.pathname==='/admin'||u.pathname==='/admin/')p='/../admin/index.html';
  const f=path.resolve(root,p);const adminRoot=path.join(__dirname,'admin');
  const allowed=f.startsWith(root)||f.startsWith(adminRoot);
  if(!allowed||!fs.existsSync(f)||fs.statSync(f).isDirectory())return json(res,404,{ok:false,error:'not_found'});
  res.writeHead(200,{'Content-Type':mime[path.extname(f)]||'application/octet-stream','Cache-Control':'no-cache'});res.end(fs.readFileSync(f));
 }catch(e){console.error(e);json(res,500,{ok:false,error:e.message})}
});
const io=new Server(server,{cors:{origin:process.env.CORS_ORIGIN||true,credentials:true}});
function leave(s,r){const m=state.rooms.get(r);if(m?.delete(s.id))io.to(r).emit('room:presence',[...m.values()]);if(m?.size===0)state.rooms.delete(r)}
io.on('connection',s=>{
 s.on('room:join',p=>{const r=String(p?.roomId||'');if(!r)return;if(!state.rooms.has(r))state.rooms.set(r,new Map());state.rooms.get(r).set(s.id,{...(p.user||{}),socketId:s.id});s.join(r);io.to(r).emit('room:presence',[...state.rooms.get(r).values()])});
 s.on('room:leave',r=>leave(s,String(r)));
 s.on('room:message',p=>{if(!p?.roomId||!p?.message?.text||!limited('m:'+s.id,8,10000))return;const m={...p.message,id:crypto.randomUUID(),createdAt:Date.now()};io.to(String(p.roomId)).emit('room:message',m);const a=read('messages.json');a.push({roomId:String(p.roomId),...m});write('messages.json',a.slice(-10000))});
 s.on('room:seat',p=>p?.roomId&&io.to(String(p.roomId)).emit('room:seat',p));
 s.on('room:gift',p=>p?.roomId&&io.to(String(p.roomId)).emit('room:gift',p));
 s.on('disconnect',()=>{for(const [r] of state.rooms)leave(s,r)});
});
server.listen(PORT,()=>console.log('ROYAL VOICE 4.2 full-clean running at '+APP_URL));