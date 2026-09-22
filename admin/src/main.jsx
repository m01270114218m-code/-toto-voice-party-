
import React,{useState} from 'react';
import {createRoot} from 'react-dom/client';
import {Users,Home,Mic2,Gift,Wallet,ShieldAlert,Settings,LogOut,Search,Menu,BarChart3} from 'lucide-react';
import './style.css';

const rooms=[['مجلس العرب','مصر','1,245','LIVE'],['جلسة طرب','السعودية','892','LIVE'],['VIP Lounge','الإمارات','756','LIVE'],['غرفة الألعاب','العراق','421','LIVE']];
const users=[['أمير القلوب','1501637','VIP 5','نشط'],['سارة','884201','VIP 3','نشط'],['محمد','721932','LV 28','نشط'],['نور','332105','LV 18','موقوف مؤقتاً']];

function App(){
 const [section,setSection]=useState('dashboard');
 const nav=[
  ['dashboard','لوحة التحكم',Home],['rooms','الغرف الصوتية',Mic2],['users','المستخدمون',Users],
  ['gifts','الهدايا والإطارات',Gift],['wallet','المحفظة والعملات',Wallet],['moderation','الأمان والبلاغات',ShieldAlert],
  ['analytics','التقارير والإحصائيات',BarChart3],['vip','VIP والمستويات',Gift],['agencies','الوكالات والقبائل',Users],
  ['events','الفعاليات والألعاب',BarChart3],['content','البنرات واللحظات',Home],['settings','الإعدادات',Settings]
 ];
 return <div className="app" dir="rtl">
  <aside><div className="brand"><div className="logo">◉</div><div><b>TOYO</b><small>لوحة الإدارة</small></div></div>
   <div className="nav">{nav.map(([id,t,I])=><button className={section===id?'active':''} onClick={()=>setSection(id)}><I size={19}/>{t}</button>)}</div>
   <button className="logout"><LogOut size={18}/>تسجيل الخروج</button>
  </aside>
  <main><header><button className="menu"><Menu/></button><div><h2>{nav.find(x=>x[0]===section)?.[1]}</h2><span>إدارة TOYO بالكامل من لوحة واحدة</span></div><div className="admin">👑 مدير النظام</div></header>
   {section==='dashboard'?<Dashboard/>:<Section title={nav.find(x=>x[0]===section)?.[1]||''} type={section}/>}
  </main>
 </div>
}
function Dashboard(){return <div className="content">
 <div className="stats">{[['المستخدمون','248,521','+12.4%',Users],['الغرف المباشرة','1,842','+8.2%',Mic2],['الهدايا اليوم','18.6M','+21%',Gift],['Coins المتداولة','425M','+15.8%',Wallet]].map(([a,b,c,I])=><div className="stat"><I/><span>{a}</span><strong>{b}</strong><em>{c}</em></div>)}</div>
 <div className="grid2"><div className="card"><h3>الغرف الأكثر نشاطاً</h3>{rooms.map(r=><div className="row"><div className="thumb">🎙️</div><div className="grow"><b>{r[0]}</b><small>🇪🇬 {r[1]} • {r[2]} مستخدم</small></div><label>{r[3]}</label><button>إدارة</button></div>)}</div>
 <div className="card"><h3>آخر البلاغات</h3>{['محتوى مخالف في غرفة','رسائل مزعجة','حساب مشبوه','إساءة في الدردشة'].map((x,i)=><div className="row"><div className="warn">!</div><div className="grow"><b>{x}</b><small>منذ {i+2} دقائق • أولوية {i<2?'عالية':'متوسطة'}</small></div><button>مراجعة</button></div>)}</div></div>
 <div className="card"><h3>إجراءات سريعة</h3><div className="actions">{['إنشاء فعالية','إضافة هدية','إيقاف مستخدم','مراجعة الوكالات','إرسال إشعار جماعي','إدارة VIP'].map(x=><button>{x}</button>)}</div></div>
 </div>}
function Section({title,type}){return <div className="content"><div className="toolbar"><div className="search"><Search size={18}/><input placeholder="بحث..."/></div><button className="primary">+ إضافة</button></div><div className="card"><h3>{title}</h3>{type==='users'?users.map(u=><div className="row"><div className="avatar">👤</div><div className="grow"><b>{u[0]}</b><small>ID: {u[1]} • {u[2]}</small></div><span className={u[3].includes('موقوف')?'danger':'ok'}>{u[3]}</span><button>تفاصيل</button><button>إدارة</button></div>):['إحصائيات','الإعدادات العامة','المراجعة','السجلات','الصلاحيات'].map(x=><div className="row"><div className="grow"><b>{x}</b><small>قسم {title} — إعداد قابل للتعديل من لوحة التحكم</small></div><button>فتح</button></div>)}</div></div>}
createRoot(document.getElementById('root')).render(<App/>);
