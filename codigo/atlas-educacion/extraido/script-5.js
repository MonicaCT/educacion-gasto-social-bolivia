
(function(){
 const LANG_ES=true;
 const txt={more:'Ver detalle',less:'Ocultar detalle',calc:'Ver cómo se calcula y cómo leerlo',reading:'Ver interpretación, ejemplo y notas',note:'Ver nota explicativa',definition:'Ver definición completa'};
 function details(summary, nodes){const d=document.createElement('details');d.className='detail-toggle';const s=document.createElement('summary');s.textContent=summary;const b=document.createElement('div');b.className='detail-body';nodes.forEach(n=>b.appendChild(n));d.append(s,b);return d;}
 function compactPlain(){document.querySelectorAll('#contents .plain-explain').forEach(box=>{if(box.dataset.compactV32)return;box.dataset.compactV32='1';const rows=[...box.querySelectorAll(':scope > .ex-row')];if(rows.length<2)return;const rest=rows.slice(1);box.classList.add('compacted');box.appendChild(details(txt.calc,rest));});}
 function compactGuides(){document.querySelectorAll('#contents .reading-guide').forEach(g=>{if(g.dataset.compactV32)return;g.dataset.compactV32='1';const kids=[...g.childNodes];if(!kids.length)return;g.classList.add('compacted-guide');g.appendChild(details(txt.reading,kids));});}
 function compactLong(selector,label,min=300){document.querySelectorAll(selector).forEach(el=>{if(el.dataset.compactV32)return;if((el.textContent||'').trim().length<min)return;el.dataset.compactV32='1';const kids=[...el.childNodes];el.classList.add(selector.includes('definition-box')?'compacted-definition':'compacted-note');el.appendChild(details(label,kids));});}
 function normalizeSourceLanguage(){return;}
  function run(){compactPlain();compactGuides();compactLong('#contents .definition-box',txt.definition,260);compactLong('#contents .note',txt.note,330);compactLong('.filter-help',txt.note,290);normalizeSourceLanguage();}
 function start(){run();new MutationObserver(()=>requestAnimationFrame(run)).observe(document.querySelector('.main')||document.body,{childList:true,subtree:true});}
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start);else start();
})();
