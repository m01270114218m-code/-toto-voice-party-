window.ROYAL_SUPABASE = {
  url: window.ROYAL_SUPABASE_URL || 'https://hgsfdkopbbwbtvsrbpoi.supabase.co',
  connectedApi: (window.ROYAL_API_BASE || '') + '/api/connection/status'
};
async function royalConnectionStatus(){ try { return await fetch(window.ROYAL_SUPABASE.connectedApi).then(r=>r.json()); } catch(e){ return {ok:false,supabase:false,database:'disconnected'}; } }