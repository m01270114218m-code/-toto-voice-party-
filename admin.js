const API = window.__ADMIN_API || "https://hgsfdkopbbwbtvsrbpoi.supabase.co/functions/v1/admin-control";
let token = sessionStorage.getItem("pharaoh_admin_token") || "";
let state = {users:[],rooms:[],agencies:[],gifts:[],topups:[],reports:[],bans:[],vipLevels:[],settings:{},counts:{}};
let currentPage = "dashboard";

const $ = (s,root=document) => root.querySelector(s);
const $$ = (s,root=document) => [...root.querySelectorAll(s)];
const esc = v => String(v ?? "").replace(/[&<>"']/g, c => ({ "&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;" }[c]));
const attr = v => esc(v);
const api = async (action, extra={}) => {
  const headers = {"Content-Type":"application/json","apikey":window.__ADMIN_KEY || ""};
  if (token) headers.Authorization = "Bearer " + token;
  const res = await fetch(API,{method:"POST",headers,body:JSON.stringify({action,...extra})});
  const text = await res.text();
  let data;
  try { data = JSON.parse(text); } catch { data = {error:text || "استجابة غير صالحة من الخادم"}; }
  if (!res.ok) throw new Error(data.error || ("HTTP " + res.status));
  return data;
};

function toast(message,type="ok"){
  const el = document.createElement("div");
  el.className = "toast " + type;
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(()=>el.remove(),2600);
}
function setContent(html){ const el=$("#content"); if(el) el.innerHTML=html; }
function openModal(html){
  $("#modalContent").innerHTML=html;
  $("#modal").classList.remove("hidden");
}
function closeModal(){ $("#modal").classList.add("hidden"); $("#modalContent").innerHTML=""; }
window.closeModal = closeModal;

function field(label,key,value="",type="text",extraClass=""){
  return '<label class="'+extraClass+'">'+esc(label)+'<input id="f_'+esc(key)+'" type="'+esc(type)+'" value="'+attr(value)+'"></label>';
}
function textarea(label,key,value="",extraClass=""){
  return '<label class="'+extraClass+'">'+esc(label)+'<textarea id="f_'+esc(key)+'">'+esc(value)+'</textarea></label>';
}
function selectField(label,key,options,value="",extraClass=""){
  return '<label class="'+extraClass+'">'+esc(label)+'<select id="f_'+esc(key)+'">'+options.map(o=>'<option value="'+attr(o.value)+'" '+(String(o.value)===String(value)?"selected":"")+'>'+esc(o.label)+'</option>').join("")+'</select></label>';
}
function emptyRow(cols,message="لا توجد بيانات حالياً"){
  return '<tr><td colspan="'+cols+'" class="empty"><div class="empty-icon">◈</div><strong>'+esc(message)+'</strong><small>يمكنك إنشاء أول عنصر من زر الإضافة بالأعلى.</small></td></tr>';
}

async function loadDashboard(){
  setContent('<div class="section"><h3>جاري تحميل مركز التحكم...</h3><div class="skeleton"></div></div>');
  try{
    const data = await api("dashboard");
    state = Object.assign({users:[],rooms:[],agencies:[],gifts:[],topups:[],reports:[],bans:[],vipLevels:[],settings:{},counts:{}},data||{});
    for(const k of ["users","rooms","agencies","gifts","topups","reports","bans","vipLevels"]) if(!Array.isArray(state[k])) state[k]=[];
    state.counts=state.counts||{};
    if($("#usersBadge")) $("#usersBadge").textContent=state.counts.users??0;
    if($("#roomsBadge")) $("#roomsBadge").textContent=state.counts.rooms??0;
    if($("#topupsBadge")) $("#topupsBadge").textContent=state.counts.pendingTopups??0;
    if($("#reportsBadge")) $("#reportsBadge").textContent=state.counts.openReports??0;
    if($("#connection")) $("#connection").innerHTML='<i></i> متصل بقاعدة البيانات';
    renderPage(currentPage);
    return data;
  }catch(e){
    console.error("admin dashboard",e);
    if($("#connection")) $("#connection").innerHTML='<i class="bad"></i> خطأ في الاتصال';
    setContent('<div class="section error-panel"><h3 class="bad">تعذر تحميل بيانات لوحة التحكم</h3><p>'+esc(e.message||e)+'</p><div class="actions"><button class="btn primary" data-action="reload">إعادة المحاولة</button></div></div>');
    throw e;
  }
}
window.loadDashboard=loadDashboard;

function renderPage(page){
  currentPage=page||"dashboard";
  const titles={dashboard:"الرئيسية",users:"إدارة المستخدمين",rooms:"إدارة الغرف",agencies:"الوكالات",gifts:"الهدايا",vip:"إدارة VIP",topups:"الشحن والدفعات",reports:"البلاغات",bans:"الحظر",settings:"إعدادات التطبيق"};
  if($("#pageTitle")) $("#pageTitle").textContent=titles[currentPage]||currentPage;
  const views={dashboard,users,rooms,agencies,gifts,vip,topups,reports,bans,settings};
  try { (views[currentPage]||dashboard)(); } catch(e) {
    console.error(e);
    setContent('<div class="section error-panel"><h3 class="bad">حدث خطأ في هذا القسم</h3><p>'+esc(e.message||e)+'</p></div>');
  }
}
window.renderPage=renderPage;

function dashboard(){
  const cards=[
    ["users","المستخدمون"],["rooms","الغرف الحية"],["agencies","الوكالات"],["gifts","الهدايا"],
    ["pendingTopups","طلبات شحن معلقة"],["openReports","بلاغات مفتوحة"],["activeBans","حظر نشط"],["vipLevels","مستويات VIP"]
  ];
  const users=state.users.slice(0,6);
  const gifts=state.gifts.slice(0,6);
  setContent(
    '<div class="cards">'+cards.map(([k,l])=>'<div class="card"><small>'+l+'</small><div class="metric">'+(state.counts[k]??0)+'</div><span class="muted">بيانات حقيقية</span></div>').join("")+'</div>'+
    '<div class="grid2">'+
      '<div class="section"><div class="section-head"><h3>آخر المستخدمين</h3><button class="mini" data-page="users">عرض الكل</button></div><div class="table-wrap"><table><thead><tr><th>ID</th><th>الاسم</th><th>المستوى</th><th>Coins</th><th>الحالة</th></tr></thead><tbody>'+
      (users.length?users.map(u=>'<tr><td>'+esc(u.public_id)+'</td><td>'+esc(u.display_name||u.username||"بدون اسم")+'</td><td>'+esc(u.level)+'</td><td>'+esc(u.coins)+'</td><td>'+(u.is_banned?'<span class="pill bad">محظور</span>':'<span class="pill ok">نشط</span>')+'</td></tr>').join(""):emptyRow(5))+
      '</tbody></table></div></div>'+
      '<div class="section"><div class="section-head"><h3>الهدايا</h3><button class="mini" data-page="gifts">إدارة</button></div><div class="table-wrap"><table><thead><tr><th></th><th>الاسم</th><th>Coins</th><th>Diamonds</th><th>الحالة</th></tr></thead><tbody>'+
      (gifts.length?gifts.map(g=>'<tr><td>'+esc(g.emoji||"🎁")+'</td><td>'+esc(g.name_ar||g.name)+'</td><td>'+esc(g.coins??g.coin_price)+'</td><td>'+esc(g.diamonds??g.diamond_value)+'</td><td>'+(g.data?.is_active===false?'<span class="pill bad">معطلة</span>':'<span class="pill ok">فعالة</span>')+'</td></tr>').join(""):emptyRow(5))+
      '</tbody></table></div></div>'+
    '</div>'+
    '<div class="section"><div class="section-head"><div><h3>مركز العمليات</h3><p class="muted">كل الأزرار التالية تنفذ على قاعدة البيانات الفعلية.</p></div></div><div class="actions">'+
      '<button class="btn primary" data-action="create-user">+ مستخدم</button><button class="btn primary" data-action="create-room">+ غرفة</button><button class="btn primary" data-action="create-agency">+ وكالة</button><button class="btn primary" data-action="create-gift">+ هدية</button><button class="btn primary" data-action="create-vip">+ VIP</button><button class="btn ghost" data-page="settings">إعدادات التطبيق</button>'+
    '</div></div>'
  );
}

function users(){
  setContent('<div class="toolbar"><button class="btn primary" data-action="create-user">+ إنشاء مستخدم</button><input id="userSearch" placeholder="بحث بالاسم أو ID أو الهاتف..."><button class="btn ghost" data-action="reload">↻ تحديث</button></div>'+
    '<div class="section"><div class="section-head"><h3>المستخدمون ('+state.users.length+')</h3></div><div class="table-wrap"><table><thead><tr><th>ID</th><th>المستخدم</th><th>المستوى</th><th>VIP</th><th>Coins</th><th>Diamonds</th><th>الحالة</th><th>إجراءات</th></tr></thead><tbody id="usersBody"></tbody></table></div></div>');
  drawUsers(state.users);
}
function drawUsers(list){
  const body=$("#usersBody"); if(!body)return;
  body.innerHTML=list.length?list.map(u=>'<tr><td>'+esc(u.public_id)+'</td><td><b>'+esc(u.display_name||"—")+'</b><br><small class="muted">@'+esc(u.username||"—")+'</small></td><td>'+esc(u.level??0)+'</td><td>VIP '+esc(u.vip_level??0)+'</td><td>'+esc(u.coins??0)+'</td><td>'+esc(u.diamonds??0)+'</td><td>'+(u.is_banned?'<span class="pill bad">محظور</span>':'<span class="pill ok">نشط</span>')+'</td><td><button class="mini" data-action="edit-user" data-id="'+attr(u.id)+'">تعديل</button><button class="mini '+(u.is_banned?"success":"danger")+'" data-action="toggle-ban" data-id="'+attr(u.id)+'">'+(u.is_banned?"فك الحظر":"حظر")+'</button></td></tr>').join(""):emptyRow(8);
}
function openCreateUser(){
  openModal('<h3>إنشاء مستخدم حقيقي</h3><div class="form-grid">'+field("الاسم","cu_name","مستخدم جديد")+field("اسم المستخدم","cu_username","user"+Date.now())+field("البريد الإلكتروني","cu_email","user"+Date.now()+"@pharaoh.local")+field("كلمة المرور","cu_password","Pharaoh@123456")+field("Coins","cu_coins",0,"number")+field("Diamonds","cu_dia",0,"number")+'</div><div class="actions"><button class="btn primary" data-action="save-create-user">إنشاء المستخدم</button></div>');
}
async function createUser(){
  const j=await api("create_user",{email:$("#f_cu_email").value.trim(),password:$("#f_cu_password").value,profile:{display_name:$("#f_cu_name").value,username:$("#f_cu_username").value,coins:Number($("#f_cu_coins").value||0),diamonds:Number($("#f_cu_dia").value||0)}});
  closeModal(); toast("تم إنشاء المستخدم فعلياً"); await loadDashboard(); if(j.temporaryPassword) alert("كلمة المرور: "+j.temporaryPassword);
}
function openEditUser(id){
  const u=state.users.find(x=>x.id===id); if(!u)return;
  openModal('<h3>تعديل المستخدم #'+esc(u.public_id)+'</h3><div class="form-grid">'+field("الاسم","u_name",u.display_name)+field("اسم المستخدم","u_username",u.username)+field("الهاتف","u_phone",u.phone)+field("الدولة","u_country",u.country_code)+field("المستوى","u_level",u.level,"number")+field("VIP","u_vip",u.vip_level,"number")+field("Coins","u_coins",u.coins,"number")+field("Diamonds","u_dia",u.diamonds,"number")+textarea("النبذة","u_bio",u.bio,"full")+'</div><div class="actions"><button class="btn primary" data-action="save-user" data-id="'+attr(id)+'">حفظ التغييرات</button></div>');
}
async function saveUser(id){
  const patch={display_name:$("#f_u_name").value,username:$("#f_u_username").value,phone:$("#f_u_phone").value,country_code:$("#f_u_country").value,level:Number($("#f_u_level").value||0),vip_level:Number($("#f_u_vip").value||0),coins:Number($("#f_u_coins").value||0),diamonds:Number($("#f_u_dia").value||0),bio:$("#f_u_bio").value};
  await api("update_user",{id,patch}); closeModal(); toast("تم حفظ المستخدم"); await loadDashboard();
}
async function toggleBan(id){
  const u=state.users.find(x=>x.id===id); if(!u)return;
  if(u.is_banned){ await api("unban_user",{user_id:u.id,public_id:u.public_id}); toast("تم فك حظر المستخدم"); }
  else {
    const reason=prompt("سبب الحظر","مخالفة قواعد الاستخدام"); if(reason===null)return;
    const hours=prompt("مدة الحظر بالساعات، اتركها فارغة للحظر الدائم",""); if(hours===null)return;
    await api("ban_user",{user_id:u.id,public_id:u.public_id,reason,hours}); toast("تم حظر المستخدم");
  }
  await loadDashboard();
}

function rooms(){
  setContent('<div class="toolbar"><button class="btn primary" data-action="create-room">+ إنشاء غرفة</button><input id="roomSearch" placeholder="بحث في الغرف..."><button class="btn ghost" data-action="reload">↻ تحديث</button></div>'+
    '<div class="section"><div class="section-head"><h3>الغرف ('+state.rooms.length+')</h3></div><div class="table-wrap"><table><thead><tr><th>ID</th><th>الغرفة</th><th>المضيف</th><th>التصنيف</th><th>المشاهدون</th><th>الحالة</th><th>إجراءات</th></tr></thead><tbody id="roomsBody"></tbody></table></div></div>');
  drawRooms(state.rooms);
}
function drawRooms(list){
  const body=$("#roomsBody");if(!body)return;
  body.innerHTML=list.length?list.map(r=>'<tr><td>'+esc(r.display_id||r.id)+'</td><td><b>'+esc(r.title||r.name)+'</b><br><small class="muted">'+esc(r.description)+'</small></td><td>'+esc(r.host_name||"—")+'</td><td>'+esc(r.category||"—")+'</td><td>'+esc(r.listeners_count??r.viewer_count??0)+'</td><td>'+(r.is_closed?'<span class="pill bad">مغلقة</span>':r.is_locked?'<span class="pill">مقفلة</span>':'<span class="pill ok">مفتوحة</span>')+'</td><td><button class="mini" data-action="edit-room" data-id="'+attr(r.id)+'">تعديل</button><button class="mini danger" data-action="delete-room" data-id="'+attr(r.id)+'">حذف</button></td></tr>').join(""):emptyRow(7);
}
function openCreateRoom(){
  const opts=state.users.map(u=>({value:u.id,label:(u.display_name||u.username||"مستخدم")+" #"+u.public_id}));
  openModal('<h3>إنشاء غرفة حقيقية</h3><div class="form-grid">'+field("اسم الغرفة","r_name","غرفة جديدة")+field("التصنيف","r_cat","general")+field("المقاعد","r_seats",8,"number")+textarea("الوصف","r_desc","")+(opts.length?selectField("المالك","r_owner",opts,opts[0].value):'<div class="section"><p class="bad">لا يوجد مستخدم مالك حالياً.</p></div>')+'</div><div class="actions"><button class="btn primary" data-action="save-create-room" '+(opts.length?"":"disabled")+'>إنشاء الغرفة</button></div>');
}
async function createRoom(){
  await api("create_room",{room:{name:$("#f_r_name").value,category:$("#f_r_cat").value,description:$("#f_r_desc").value,seat_count:Number($("#f_r_seats").value||8),owner_id:$("#f_r_owner")?.value||null}});
  closeModal();toast("تم إنشاء الغرفة فعلياً");await loadDashboard();
}
function openEditRoom(id){
  const r=state.rooms.find(x=>x.id===id);if(!r)return;
  openModal('<h3>تعديل الغرفة</h3><div class="form-grid">'+field("العنوان","er_title",r.title||r.name)+field("التصنيف","er_cat",r.category)+field("المقاعد","er_seats",r.seat_count||8,"number")+textarea("الوصف","er_desc",r.description)+field("رابط الغلاف","er_cover",r.room_cover||"","text","full")+'</div><div class="actions"><button class="btn primary" data-action="save-room" data-id="'+attr(id)+'">حفظ</button><button class="btn ghost" data-action="toggle-room" data-id="'+attr(id)+'" data-closed="'+(!r.is_closed)+'">'+(r.is_closed?"فتح الغرفة":"إغلاق الغرفة")+'</button><button class="btn ghost" data-action="lock-room" data-id="'+attr(id)+'" data-locked="'+(!r.is_locked)+'">'+(r.is_locked?"فتح القفل":"قفل الغرفة")+'</button></div>');
}
async function saveRoom(id){
  await api("update_room",{id,patch:{title:$("#f_er_title").value,category:$("#f_er_cat").value,seat_count:Number($("#f_er_seats").value||8),description:$("#f_er_desc").value,room_cover:$("#f_er_cover").value}});
  closeModal();toast("تم حفظ الغرفة");await loadDashboard();
}
async function toggleRoom(id,closed){await api("update_room",{id,patch:{is_closed:closed==="true"||closed===true}});closeModal();toast("تم تحديث حالة الغرفة");await loadDashboard();}
async function lockRoom(id,locked){await api("update_room",{id,patch:{is_locked:locked==="true"||locked===true}});closeModal();toast("تم تحديث قفل الغرفة");await loadDashboard();}
async function deleteRoom(id){if(!confirm("حذف الغرفة نهائياً؟"))return;await api("delete_room",{id});toast("تم حذف الغرفة");await loadDashboard();}

function agencies(){
  setContent('<div class="toolbar"><button class="btn primary" data-action="create-agency">+ إنشاء وكالة</button><button class="btn ghost" data-action="reload">↻ تحديث</button></div>'+
    '<div class="section"><div class="section-head"><h3>الوكالات ('+state.agencies.length+')</h3></div><div class="table-wrap"><table><thead><tr><th>ID</th><th>الاسم</th><th>المالك</th><th>الوصف</th><th>تاريخ الإنشاء</th><th>إجراءات</th></tr></thead><tbody>'+
    (state.agencies.length?state.agencies.map(a=>'<tr><td>'+esc(a.id)+'</td><td><b>'+esc(a.name)+'</b></td><td>'+esc(a.owner_name||a.owner_id||"—")+'</td><td>'+esc(a.description||"—")+'</td><td>'+esc(a.created_at?new Date(a.created_at).toLocaleString("ar-EG"):"—")+'</td><td><button class="mini" data-action="edit-agency" data-id="'+attr(a.id)+'">تعديل</button><button class="mini danger" data-action="delete-agency" data-id="'+attr(a.id)+'">حذف</button></td></tr>').join(""):emptyRow(6))+
    '</tbody></table></div></div>');
}
function openCreateAgency(){
  const opts=state.users.map(u=>({value:u.id,label:(u.display_name||u.username||"مستخدم")+" #"+u.public_id}));
  openModal('<h3>إنشاء وكالة حقيقية</h3><div class="form-grid">'+field("اسم الوكالة","a_name","وكالة جديدة")+textarea("الوصف","a_desc","")+(opts.length?selectField("المالك","a_owner",opts,opts[0].value):'<p class="bad">يجب وجود مستخدم أولاً.</p>')+'</div><div class="actions"><button class="btn primary" data-action="save-create-agency" '+(opts.length?"":"disabled")+'>إنشاء الوكالة</button></div>');
}
async function createAgency(){await api("create_agency",{agency:{name:$("#f_a_name").value,description:$("#f_a_desc").value,owner_id:$("#f_a_owner")?.value||null}});closeModal();toast("تم إنشاء الوكالة");await loadDashboard();}
function openEditAgency(id){
  const a=state.agencies.find(x=>x.id===id);if(!a)return;
  openModal('<h3>تعديل الوكالة</h3><div class="form-grid">'+field("الاسم","ea_name",a.name)+textarea("الوصف","ea_desc",a.description||"")+'</div><div class="actions"><button class="btn primary" data-action="save-agency" data-id="'+attr(id)+'">حفظ</button></div>');
}
async function saveAgency(id){await api("update_agency",{id,patch:{name:$("#f_ea_name").value,description:$("#f_ea_desc").value}});closeModal();toast("تم حفظ الوكالة");await loadDashboard();}
async function deleteAgency(id){if(!confirm("حذف الوكالة نهائياً؟"))return;await api("delete_agency",{id});toast("تم حذف الوكالة");await loadDashboard();}

function gifts(){
  setContent('<div class="toolbar"><button class="btn primary" data-action="create-gift">+ إضافة هدية</button><button class="btn ghost" data-action="reload">↻ تحديث</button></div>'+
    '<div class="section"><div class="section-head"><h3>الهدايا ('+state.gifts.length+')</h3></div><div class="table-wrap"><table><thead><tr><th>الأيقونة</th><th>الاسم</th><th>Coins</th><th>Diamonds</th><th>الحالة</th><th>إجراءات</th></tr></thead><tbody>'+
    (state.gifts.length?state.gifts.map(g=>'<tr><td>'+esc(g.emoji||"🎁")+'</td><td><b>'+esc(g.name_ar||g.name)+'</b></td><td>'+esc(g.coins??g.coin_price??0)+'</td><td>'+esc(g.diamonds??g.diamond_value??0)+'</td><td>'+(g.data?.is_active===false?'<span class="pill bad">معطلة</span>':'<span class="pill ok">فعالة</span>')+'</td><td><button class="mini" data-action="edit-gift" data-id="'+attr(g.id)+'">تعديل</button><button class="mini danger" data-action="delete-gift" data-id="'+attr(g.id)+'">حذف</button></td></tr>').join(""):emptyRow(6))+
    '</tbody></table></div></div>');
}
function openCreateGift(){openEditGift(null);}
function openEditGift(id){
  const g=id?state.gifts.find(x=>x.id===id):{name_ar:"هدية جديدة",coins:100,diamonds:0,custom_image:""};
  if(!g)return;
  openModal('<h3>'+(id?"تعديل هدية":"إضافة هدية")+'</h3><div class="form-grid">'+field("الاسم","g_name",g.name_ar||g.name)+field("Coins","g_coins",g.coins??g.coin_price??100,"number")+field("Diamonds","g_dia",g.diamonds??g.diamond_value??0,"number")+field("رابط الصورة","g_img",g.custom_image||g.image_url||"","text","full")+field("رابط الأنيميشن","g_anim",g.animation_url||"","text","full")+'</div><div class="actions"><button class="btn primary" data-action="save-gift" data-id="'+attr(id||"new")+'">حفظ</button></div>');
}
async function saveGift(id){
  const patch={name_ar:$("#f_g_name").value,coins:Number($("#f_g_coins").value||0),diamonds:Number($("#f_g_dia").value||0),custom_image:$("#f_g_img").value,animation_url:$("#f_g_anim").value};
  if(id==="new") await api("create_gift",{gift:{name:patch.name_ar,emoji:"🎁",image_url:patch.custom_image||null,animation_url:patch.animation_url||null,coins:patch.coins,diamonds:patch.diamonds,sort_order:0}});
  else await api("update_gift",{id,patch});
  closeModal();toast("تم حفظ الهدية");await loadDashboard();
}
async function deleteGift(id){if(!confirm("حذف الهدية نهائياً؟"))return;await api("delete_gift",{id});toast("تم حذف الهدية");await loadDashboard();}

function vip(){
  setContent('<div class="toolbar"><button class="btn primary" data-action="create-vip">+ مستوى VIP</button><button class="btn ghost" data-action="reload">↻ تحديث</button></div>'+
    '<div class="section"><div class="section-head"><h3>مستويات VIP ('+state.vipLevels.length+')</h3></div><div class="table-wrap"><table><thead><tr><th>المستوى</th><th>الاسم</th><th>السعر</th><th>الحالة</th><th>إجراءات</th></tr></thead><tbody>'+
    (state.vipLevels.length?state.vipLevels.map(v=>'<tr><td>'+esc(v.level)+'</td><td>'+esc(v.name_ar)+'</td><td>'+esc(v.price_coins)+' Coins</td><td>'+(v.is_active?'<span class="pill ok">فعال</span>':'<span class="pill bad">معطل</span>')+'</td><td><button class="mini" data-action="edit-vip" data-id="'+attr(v.id)+'">تعديل</button><button class="mini danger" data-action="delete-vip" data-id="'+attr(v.id)+'">حذف</button></td></tr>').join(""):emptyRow(5))+
    '</tbody></table></div></div>');
}
function openCreateVip(){
  const next=state.vipLevels.length?Math.max(...state.vipLevels.map(v=>Number(v.level)||0))+1:1;
  openEditVip(null,next);
}
function openEditVip(id,level){
  const v=id?state.vipLevels.find(x=>String(x.id)===String(id)):{level:level||1,name_ar:"VIP جديد",price_coins:1000,benefits:{},is_active:true};
  if(!v)return;
  openModal('<h3>'+(id?"تعديل مستوى VIP":"إضافة مستوى VIP")+'</h3><div class="form-grid">'+field("المستوى","v_level",v.level,"number")+field("الاسم","v_name",v.name_ar)+field("السعر Coins","v_price",v.price_coins,"number")+textarea("المزايا JSON","v_benefits",JSON.stringify(v.benefits||{}),"full")+'</div><div class="actions"><button class="btn primary" data-action="save-vip" data-id="'+attr(id||"new")+'">حفظ</button></div>');
}
async function saveVip(id){
  let benefits={};try{benefits=JSON.parse($("#f_v_benefits").value||"{}");}catch{toast("المزايا يجب أن تكون JSON صحيح","bad");return;}
  await api("save_vip",{vip:{id:id==="new"?null:Number(id),level:Number($("#f_v_level").value),name_ar:$("#f_v_name").value,price_coins:Number($("#f_v_price").value||0),benefits,is_active:true}});
  closeModal();toast("تم حفظ مستوى VIP");await loadDashboard();
}
async function deleteVip(id){if(!confirm("حذف مستوى VIP؟"))return;await api("delete_vip",{id:Number(id)});toast("تم حذف مستوى VIP");await loadDashboard();}

function topups(){
  setContent('<div class="section"><div class="section-head"><h3>طلبات الشحن ('+state.topups.length+')</h3><button class="mini" data-action="reload">↻ تحديث</button></div><div class="table-wrap"><table><thead><tr><th>المستخدم</th><th>Coins</th><th>المبلغ</th><th>الطريقة</th><th>الحالة</th><th>التاريخ</th><th>إجراء</th></tr></thead><tbody>'+
  (state.topups.length?state.topups.map(t=>'<tr><td>'+esc(t.profiles?.display_name||t.user_id)+'</td><td>'+esc(t.coins)+'</td><td>'+esc(((Number(t.amount_minor)||0)/100).toFixed(2))+' '+esc(t.currency)+'</td><td>'+esc(t.provider)+'</td><td>'+esc(t.status)+'</td><td>'+esc(t.created_at?new Date(t.created_at).toLocaleString("ar-EG"):"—")+'</td><td>'+(t.status==="pending"?'<button class="mini success" data-action="review-topup" data-id="'+attr(t.id)+'" data-status="paid">قبول</button><button class="mini danger" data-action="review-topup" data-id="'+attr(t.id)+'" data-status="rejected">رفض</button>':"—")+'</td></tr>').join(""):emptyRow(7,"لا توجد طلبات شحن معلقة"))+
  '</tbody></table></div></div>');
}
async function reviewTopup(id,status){const note=prompt("ملاحظة للمراجعة","");if(note===null)return;await api("review_topup",{id,status,note});toast("تم تحديث طلب الشحن");await loadDashboard();}

function reports(){
  setContent('<div class="section"><div class="section-head"><h3>البلاغات ('+state.reports.length+')</h3><button class="mini" data-action="reload">↻ تحديث</button></div><div class="table-wrap"><table><thead><tr><th>ID</th><th>المبلغ عنه</th><th>الغرفة</th><th>السبب</th><th>الحالة</th><th>إجراء</th></tr></thead><tbody>'+
  (state.reports.length?state.reports.map(r=>'<tr><td>'+esc(r.id)+'</td><td>'+esc(r.target_user_id)+'</td><td>'+esc(r.room_id||"—")+'</td><td>'+esc(r.reason||"—")+'</td><td>'+esc(r.status)+'</td><td>'+(r.status==="open"?'<button class="mini success" data-action="resolve-report" data-id="'+attr(r.id)+'" data-status="resolved">حل</button><button class="mini" data-action="resolve-report" data-id="'+attr(r.id)+'" data-status="rejected">رفض</button>':"—")+'</td></tr>').join(""):emptyRow(6,"لا توجد بلاغات مفتوحة"))+
  '</tbody></table></div></div>');
}
async function resolveReport(id,status){await api("resolve_report",{id,status});toast("تم تحديث البلاغ");await loadDashboard();}

function bans(){
  setContent('<div class="section"><div class="section-head"><h3>سجل الحظر ('+state.bans.length+')</h3><button class="mini" data-action="reload">↻ تحديث</button></div><div class="table-wrap"><table><thead><tr><th>Public ID</th><th>النوع</th><th>السبب</th><th>ينتهي</th><th>الحالة</th><th>إجراء</th></tr></thead><tbody>'+
  (state.bans.length?state.bans.map(b=>'<tr><td>'+esc(b.public_id)+'</td><td>'+esc(b.ban_type)+'</td><td>'+esc(b.reason)+'</td><td>'+esc(b.expires_at?new Date(b.expires_at).toLocaleString("ar-EG"):"دائم")+'</td><td>'+(b.active?'<span class="pill bad">نشط</span>':'<span class="pill">منتهي</span>')+'</td><td>'+(b.active?'<button class="mini success" data-action="quick-unban" data-public-id="'+attr(b.public_id)+'">فك الحظر</button>':"—")+'</td></tr>').join(""):emptyRow(6,"لا يوجد حظر نشط"))+
  '</tbody></table></div></div>');
}
async function quickUnban(pid){await api("unban_user",{public_id:Number(pid)});toast("تم فك الحظر");await loadDashboard();}

function settings(){
  const s=state.settings||{};
  setContent('<div class="grid2"><div class="section"><h3>إعدادات التشغيل</h3>'+selectField("وضع الصيانة","set_maint",[{value:"false",label:"متوقف"},{value:"true",label:"مفعل"}],String(!!s.maintenance_mode))+textarea("الإعلان العام","set_ann",s.global_announcement||"")+'<div class="actions"><button class="btn primary" data-action="save-settings">حفظ الإعدادات</button></div></div>'+
  '<div class="section"><h3>حالة لوحة التحكم</h3><p class="ok">● متصل بـ Supabase</p><p class="muted">التغييرات تحفظ مباشرة في admin_control_settings وتظهر للتطبيق عبر public_state.</p><div class="actions"><button class="btn ghost" data-action="reload">إعادة تحميل البيانات</button></div></div></div>');
}
async function saveSettings(){await api("save_settings",{patch:{maintenance_mode:$("#f_set_maint").value==="true",global_announcement:$("#f_set_ann").value}});toast("تم حفظ الإعدادات");await loadDashboard();}

function navTo(page){
  const b=$('#nav button[data-page="'+page+'"]');
  if(b)b.click(); else renderPage(page);
}

$("#nav")?.addEventListener("click",e=>{
  const b=e.target.closest("button[data-page]");if(!b)return;
  e.preventDefault();
  $$("#nav button[data-page]").forEach(x=>x.classList.remove("active"));
  b.classList.add("active");
  renderPage(b.dataset.page);
});
$("#content")?.addEventListener("click",async e=>{
  const pageBtn=e.target.closest("[data-page]");
  if(pageBtn && !pageBtn.matches("#nav button")){navTo(pageBtn.dataset.page);return;}
  const b=e.target.closest("[data-action]");if(!b)return;
  const a=b.dataset.action;
  try{
    if(a==="reload"){await loadDashboard();toast("تم تحديث البيانات");}
    else if(a==="create-user")openCreateUser();
    else if(a==="save-create-user")await createUser();
    else if(a==="edit-user")openEditUser(b.dataset.id);
    else if(a==="save-user")await saveUser(b.dataset.id);
    else if(a==="toggle-ban")await toggleBan(b.dataset.id);
    else if(a==="create-room")openCreateRoom();
    else if(a==="save-create-room")await createRoom();
    else if(a==="edit-room")openEditRoom(b.dataset.id);
    else if(a==="save-room")await saveRoom(b.dataset.id);
    else if(a==="toggle-room")await toggleRoom(b.dataset.id,b.dataset.closed);
    else if(a==="lock-room")await lockRoom(b.dataset.id,b.dataset.locked);
    else if(a==="delete-room")await deleteRoom(b.dataset.id);
    else if(a==="create-agency")openCreateAgency();
    else if(a==="save-create-agency")await createAgency();
    else if(a==="edit-agency")openEditAgency(b.dataset.id);
    else if(a==="save-agency")await saveAgency(b.dataset.id);
    else if(a==="delete-agency")await deleteAgency(b.dataset.id);
    else if(a==="create-gift")openCreateGift();
    else if(a==="edit-gift")openEditGift(b.dataset.id);
    else if(a==="save-gift")await saveGift(b.dataset.id);
    else if(a==="delete-gift")await deleteGift(b.dataset.id);
    else if(a==="create-vip")openCreateVip();
    else if(a==="edit-vip")openEditVip(b.dataset.id);
    else if(a==="save-vip")await saveVip(b.dataset.id);
    else if(a==="delete-vip")await deleteVip(b.dataset.id);
    else if(a==="review-topup")await reviewTopup(b.dataset.id,b.dataset.status);
    else if(a==="resolve-report")await resolveReport(b.dataset.id,b.dataset.status);
    else if(a==="quick-unban")await quickUnban(b.dataset.publicId);
    else if(a==="save-settings")await saveSettings();
  }catch(err){console.error(err);toast(err.message||"فشل تنفيذ العملية","bad");}
});

$("#closeModal")?.addEventListener("click",closeModal);
$("#modal")?.addEventListener("click",e=>{if(e.target.id==="modal")closeModal();});
$("#refresh")?.addEventListener("click",async()=>{try{await loadDashboard();toast("تم تحديث البيانات");}catch(e){if(String(e.message).includes("الجلسة"))location.reload();}});
$("#logout")?.addEventListener("click",async()=>{try{await api("logout");}catch{}sessionStorage.removeItem("pharaoh_admin_token");location.reload();});

$("#userSearch")?.addEventListener("input",e=>{
  const q=e.target.value.toLowerCase();
  drawUsers(state.users.filter(u=>[u.public_id,u.display_name,u.username,u.phone].join(" ").toLowerCase().includes(q)));
});
document.addEventListener("input",e=>{
  if(e.target.id==="userSearch"){
    const q=e.target.value.toLowerCase();
    drawUsers(state.users.filter(u=>[u.public_id,u.display_name,u.username,u.phone].join(" ").toLowerCase().includes(q)));
  }
});

window.addEventListener("error",e=>console.error("Admin JS error",e.error||e.message));

if(token){
  $("#login")?.classList.add("hidden");
  $("#app")?.classList.remove("hidden");
  loadDashboard().catch(e=>{
    sessionStorage.removeItem("pharaoh_admin_token");
    $("#app")?.classList.add("hidden");
    $("#login")?.classList.remove("hidden");
    if($("#loginMsg"))$("#loginMsg").textContent="تعذر تحميل لوحة التحكم: "+(e.message||"خطأ غير معروف");
  });
}
