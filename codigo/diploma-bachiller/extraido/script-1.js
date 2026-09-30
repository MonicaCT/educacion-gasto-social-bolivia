
(function(){
var $=function(id){return document.getElementById(id)};
var slides=[].slice.call(document.querySelectorAll('.slide')),i=0;
function go(n){i=Math.max(0,Math.min(slides.length-1,n));slides.forEach(function(s,k){s.classList.toggle('on',k===i)});if($('bar'))$('bar').style.width=((i+1)/slides.length*100)+'%';if($('count'))$('count').textContent=(i+1)+' de '+slides.length;if($('prev'))$('prev').disabled=i===0;if($('next'))$('next').disabled=i===slides.length-1;if(slides[i])slides[i].scrollTop=0;updateSlideIndex();if(slides[i] && slides[i].querySelector('#c10'))c10();}
if($('prev'))$('prev').onclick=function(){go(i-1)};if($('next'))$('next').onclick=function(){go(i+1)};if($('navIndex'))$('navIndex').onclick=function(){go(1)};
document.addEventListener('keydown',function(e){if(e.target.tagName==='INPUT'||e.target.tagName==='SELECT')return;if(e.key==='ArrowRight'||e.key==='PageDown')go(i+1);if(e.key==='ArrowLeft'||e.key==='PageUp')go(i-1);if((e.key==='i'||e.key==='I')&&!e.ctrlKey&&!e.metaKey&&!e.altKey){e.preventDefault();go(1);}});
var x0=null;document.addEventListener('touchstart',function(e){x0=e.touches[0].clientX},{passive:true});document.addEventListener('touchend',function(e){if(x0===null)return;var d=e.changedTouches[0].clientX-x0;x0=null;if(Math.abs(d)>70&&!e.target.closest('button,input,select'))go(d<0?i+1:i-1)},{passive:true});

function updateSlideIndex(){[].forEach.call(document.querySelectorAll('.index-slide-link'),function(el){var target=+el.getAttribute('data-go');el.classList.toggle('active',target===i);});}
function buildSlideIndex(){
var list=$('slideIndexList');if(!list)return;list.innerHTML='';
var groups={};
slides.forEach(function(slide,k){
  if(k<2)return;
  var section=slide.getAttribute('data-section')||'Contenido';
  if(!groups[section])groups[section]=[];
  groups[section].push([slide,k]);
});
Object.keys(groups).forEach(function(section){
  var block=document.createElement('div');block.className='index-section';
  var head=document.createElement('div');head.className='index-section-title';head.textContent=section;block.appendChild(head);
  groups[section].forEach(function(item){
    var slide=item[0],k=item[1];
    var heading=slide.querySelector('h1,h2');
    var title=heading?heading.textContent.trim():'Lámina '+(k+1);
    var btn=document.createElement('button');btn.type='button';btn.className='index-slide-link';btn.setAttribute('data-go',k);
    btn.innerHTML='<span class="num">'+(k+1)+'</span><span class="txt">'+title+'</span>';
    btn.title='Ir a la lámina '+(k+1)+': '+title;
    btn.onclick=function(){go(k)};
    block.appendChild(btn);
  });
  list.appendChild(block);
});
updateSlideIndex();
}
function tabs(id,names,cb){var el=$(id);if(!el)return;names.forEach(function(n,k){var b=document.createElement('button');b.className='tab';b.textContent=n;b.setAttribute('aria-pressed','false');b.onclick=function(){[].forEach.call(el.children,function(t){t.setAttribute('aria-pressed',t===b)});cb(k)};el.appendChild(b)});if(el.children.length)el.children[0].click()}
function fmt(n,d){return n.toLocaleString('es-BO',{minimumFractionDigits:d||0,maximumFractionDigits:d||0})}
var T2=[['Se reduce','Impresión, custodia, manejo de cartones, distribución física y legalizaciones repetitivas.'],['Permanece','La responsabilidad institucional de otorgar, validar, certificar y resolver casos observados.'],['Aumenta','La importancia del SIE, la identidad digital, la interoperabilidad, el control documental y la seguridad de datos.']];tabs('t2',T2.map(function(t){return t[0]}),function(k){$('b2').textContent=T2[k][1]});
var F4=[['Política educativa','Aplicar políticas, planes, programas, estrategias y normas nacionales en el ámbito departamental.'],['Planificación','Formular el Plan Departamental de Educación y articularlo con el Plan Nacional.'],['Coordinación','Coordinar con gobiernos autónomos y otras instituciones del departamento.'],['Finanzas','Planificar, organizar, ejecutar y evaluar la gestión administrativa, financiera y legal.'],['Supervisión','Supervisar entidades educativas, gestión pedagógica y procesos administrativos.'],['RR.HH.','Administrar personal docente, directivo y administrativo según normativa.'],['Información','Enviar información requerida al Ministerio y mantener registros institucionales.'],['Diplomas','Otorgar los Diplomas de Bachiller gratuitos conforme a la Ley N.º 3991.']];tabs('t4',F4.map(function(x){return x[0]}),function(k){$('b4').textContent=F4[k][1]});
var A7=[['Familias','<b>Antes:</b> podían pagar obtención, transporte y gestión.<br><b>Gratuidad física:</b> dejan de pagar la obtención, pero pueden persistir legalizaciones, copias y traslados.<br><b>Digitalización:</b> bajan legalizaciones y desplazamientos; aparece riesgo de brecha digital/identidad.'],['DDE / SEDUCA','<b>Antes:</b> proceso físico con cobro al usuario y costo operativo.<br><b>Gratuidad física:</b> emisión sin cobro al bachiller; la administración y el soporte físico permanecen.<br><b>Digitalización:</b> baja el soporte físico y aumenta validación de datos, soporte y excepciones.'],['Gobierno departamental','<b>Antes:</b> menor presión si el usuario financiaba parte del costo.<br><b>Gratuidad física:</b> asume el costo de emisión con recursos departamentales.<br><b>Digitalización:</b> puede ahorrar costos físicos, pero debe sostener transición, soporte y coordinación.'],['Gobierno central','<b>Antes:</b> regula el sistema educativo.<br><b>Gratuidad física:</b> define marco nacional y tutela institucional.<br><b>Digitalización:</b> aumenta la coordinación tecnológica, interoperabilidad y reglas de verificación.']];tabs('t7',A7.map(function(x){return x[0]}),function(k){$('b7').innerHTML=A7[k][1]});
var M8=[{s:['Unidad educativa cierra notas','Distrito/DDE valida información','DDE gestiona emisión física','Firmas, sellos y custodia','Entrega a estudiante','Legalización o certificación posterior'],d:'<b>Rol de la DDE:</b> emite, firma, custodia y legaliza.<br><b>Riesgo principal:</b> pérdida, deterioro y falsificación documental.'},{s:['Notas validadas','Identidad digital (Ciudadanía Digital)','Emisión digital','Verificación electrónica por universidades e institutos'],d:'<b>Rol de la DDE:</b> valida, controla datos y resuelve observaciones.<br><b>Riesgo principal:</b> error de datos, identidad, acceso y ciberseguridad.'}];tabs('t8',['Modelo físico','Modelo digital'],function(k){$('s8').innerHTML=M8[k].s.map(function(x){return '<li>'+x+'</li>'}).join('');$('d8').innerHTML=M8[k].d});
var T9=[['Se reduce','Impresión, cartones, archivo físico, distribución, custodia material, legalizaciones rutinarias y parte de la atención repetitiva de ventanilla.'],['Permanece','Validación de notas, control de identidad, resolución de observaciones, garantía de autenticidad, coordinación institucional y atención de casos excepcionales.'],['Se transforma','Firma/sello físico pasa a verificación electrónica; archivo físico pasa a registros digitales; ventanilla pasa a soporte híbrido; control documental pasa a auditoría de datos.'],['Aumenta','Calidad de datos, interoperabilidad, Ciudadanía Digital, seguridad, auditoría, soporte digital y gestión de excepciones.']];tabs('t9',T9.map(function(t){return t[0]}),function(k){$('b9').textContent=T9[k][1]});
var D=[['La Paz',5.705,28.3],['Santa Cruz',4.171,20.7],['Cochabamba',3.411,16.9],['Potosí',2.001,9.9],['Chuquisaca',1.293,6.4],['Oruro',1.139,5.7],['Tarija',1.117,5.5],['Beni',0.995,4.9],['Pando',0.326,1.6]];
function c10(){$('c10').innerHTML=D.map(function(r){return '<div class="row"><span>'+r[0]+'</span><div class="track"><div class="fill" data-w="'+(r[1]/5.705*100)+'"></div></div><span>Bs '+fmt(r[1],3)+' MM · '+fmt(r[2],1)+'%</span></div>'}).join('');requestAnimationFrame(function(){requestAnimationFrame(function(){[].forEach.call($('c10').querySelectorAll('.fill'),function(f){f.style.width=f.dataset.w+'%'})})})}
var INC=[
['La Paz',49.396,53.839,5.917,1.001,16.9],
['Santa Cruz',46.959,51.183,16.743,0.952,5.7],
['Cochabamba',36.562,39.850,10.353,0.741,7.2],
['Potosí',12.603,13.737,0.980,0.255,26.1],
['Chuquisaca',9.586,10.448,1.463,0.194,13.3],
['Oruro',9.471,10.323,1.389,0.192,13.8],
['Tarija',8.704,9.487,0.949,0.176,18.6],
['Beni',8.234,8.975,1.269,0.167,13.1],
['Pando',1.981,2.159,1.259,0.040,3.2]];
function incChart(mode){
 var max=mode===0?Math.max.apply(null,INC.map(function(r){return r[4]})):Math.max.apply(null,INC.map(function(r){return r[5]}));
 $('c12inc').innerHTML=INC.map(function(r){
   var val=mode===0?r[4]:r[5], lab=mode===0?'Bs '+fmt(val,3)+' M':fmt(val,1)+'%';
   return '<div class="row"><span>'+r[0]+'</span><div class="track"><div class="fill r" style="width:'+(val/max*100)+'%"></div></div><span>'+lab+'</span></div>';
 }).join('') + '<p class="tiny">'+(mode===0?'Monto anual máximo expuesto bajo el escenario central.':'Exposición estimada como porcentaje de “Otros Recursos Específicos” 2025 de cada DDE.')+'</p>';
}
tabs('t12inc',['Monto estimado (Bs)','% de recursos específicos'],function(k){incChart(k)});
var P13=[['Conservador',10,62,70,30],['Referencia',30,62,100,50],['Mayor exposición',30,180,100,50],['Techo teórico',100,180,100,100]];
function calc13(){var a=+$('p1').value,b=+$('p2').value,c=+$('p3').value,d=+$('p4').value;$('v1').textContent=a+'%';$('v2').textContent='Bs '+b;$('v3').textContent=c+'%';$('v4').textContent=d+'%';var bruto=200000*a/100*b*c/100/1e6;var propio=bruto*d/100;$('r13').textContent='Bs '+fmt(bruto,2)+' millones';$('r13b').textContent='Bs '+fmt(propio,2)+' millones'}
['p1','p2','p3','p4'].forEach(function(id){$(id).oninput=calc13});tabs('t13',P13.map(function(p){return p[0]}),function(k){$('p1').value=P13[k][1];$('p2').value=P13[k][2];$('p3').value=P13[k][3];$('p4').value=P13[k][4];calc13()});


var FIN=[
['Modelo físico vigente','<span class="note-tag actual">Norma vigente</span><br><b>Origen:</b> recursos departamentales de los Gobiernos Autónomos Departamentales.<br><br><b>Flujo:</b> GAD → transferencia interinstitucional al Ministerio de Educación → (a) edición, impresión y distribución; y (b) transferencias a las DDE para revisión, validación, verificación, sistematización y funciones propias.<br><br><b>Excepción histórica:</b> en 2009 el TGN cubrió edición, impresión y distribución.'],
['Proyecto digital 2026–2030','<span class="note-tag internal">Estimación interna</span><br><b>Costo proyectado:</b> Bs 3.174.244 en cinco años.<br><br><b>Estructura:</b> 47,3% nube ENTEL; 24,7% developer; 20,4% soporte técnico; 7,6% restante en equipos, mantenimiento, gestión, firma digital, capacitación y contingencia.<br><br><b>Fuente financiera:</b> el documento presupuestario compartido <u>no la identifica expresamente</u>. No debe atribuirse al TGN, GAD o AGETIC sin respaldo adicional.'],
['Régimen propuesto · PLS-221','<span class="note-tag proposed">Proyecto en revisión</span><br><b>Si se promulga:</b> los costos de emisión, edición, impresión, validación, seguridad, sistematización, registro y distribución gratuita serían financiados <b>íntegramente con recursos del TGN</b>, asignados anualmente al presupuesto institucional del Ministerio de Educación.<br><br>Los GAD dejarían de estar obligados a transferir recursos o sufrir débitos automáticos por estos costos.']
];
tabs('tFin',FIN.map(function(x){return x[0]}),function(k){$('bFin').innerHTML=FIN[k][1]});

var C15=[
['Institucional','La DDE no desaparece del proceso. Su función se desplaza desde custodia, firma y legalización física hacia validación de datos, resolución de observaciones, soporte territorial y control de autenticidad digital.'],
['Ingresos','Con el escenario central (30% legaliza, Bs 62 y sustitución total para usos nacionales), la exposición máxima agregada es ≈ Bs 3,72 millones. La Paz concentra el mayor monto; Potosí presenta la mayor exposición relativa frente a sus “Otros Recursos Específicos” 2025. El resultado real será menor si parte del cobro no constituye recurso propio DDE.'],
['Familias','La gratuidad eliminó el pago de obtención del diploma; la digitalización puede reducir todavía más legalizaciones, copias, filas y traslados. Para educación superior nacional, el Ministerio informó que el diploma digital no requerirá legalización en universidades o institutos.'],
['Financiamiento','En el modelo físico vigente, los recursos provienen de los gobiernos departamentales y se canalizan a través del Ministerio hacia la impresión/distribución y las DDE. El presupuesto digital compartido no identifica su fuente. El PLS-221 propone trasladar íntegramente el financiamiento al TGN, pero al 30/09/2026 continúa en revisión legislativa.'],
['Evidencia','Para el modelo físico ya existe evidencia contable oficial histórica: el Informe UAI INF CI N.º 02/2017 documenta Bs 43,36 millones transferidos por las Gobernaciones al Ministerio y Bs 32,43 millones asignados a las DDE entre 2011 y 2016. Sin embargo, no constituye por sí solo un costo anual actual; debe complementarse con estructuras de costos recientes.']];tabs('t15',C15.map(function(x){return x[0]}),function(k){$('b15').innerHTML=C15[k][1]});
[].forEach.call(document.querySelectorAll('.acc>button'),function(btn){btn.addEventListener('click',function(){var a=btn.parentNode,o=a.classList.toggle('open');btn.setAttribute('aria-expanded',o);var d=btn.nextElementSibling;if(d)d.style.display=o?'block':'none'})});

function sheetHtml(title, headers, rows, note){
  function esc(v){return String(v===undefined?'':v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
  var h='<!DOCTYPE html><html><head><meta charset="utf-8"><style>body{font-family:Arial,Helvetica,sans-serif;font-size:12px}h2{margin:0 0 10px}p{margin:0 0 8px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #9aa3ad;padding:6px 8px;text-align:left}th{background:#dbeff0}</style></head><body>';
  h+='<h2>'+esc(title)+'</h2>';
  if(note)h+='<p>'+esc(note)+'</p>';
  h+='<table><thead><tr>'+headers.map(function(x){return '<th>'+esc(x)+'</th>'}).join('')+'</tr></thead><tbody>';
  h+=rows.map(function(r){return '<tr>'+r.map(function(c){return '<td>'+esc(c)+'</td>'}).join('')+'</tr>'}).join('');
  h+='</tbody></table></body></html>';
  return h;
}
function triggerExcelDownload(filename, html){
  var blob=new Blob(['\ufeff',html],{type:'application/vnd.ms-excel'});
  var a=document.createElement('a');
  a.href=URL.createObjectURL(blob);
  a.download=filename.endsWith('.xls')?filename:filename+'.xls';
  document.body.appendChild(a);a.click();setTimeout(function(){URL.revokeObjectURL(a.href);a.remove();},1200);
}
function downloadSlideExcel(key){
  var data=getExcelPayload(key);
  if(!data)return;
  triggerExcelDownload(data.filename, sheetHtml(data.title,data.headers,data.rows,data.note));
}
function currentSimRows(){
  var p1=+$('p1').value,p2=+$('p2').value,p3=+$('p3').value,p4=+$('p4').value;
  var bruto=200000*p1/100*p2*p3/100;
  var propio=bruto*p4/100;
  return [
    ['Bachilleres base',200000],
    ['% que legaliza',p1+'%'],
    ['Tarifa por trámite (Bs)',p2],
    ['% de sustitución digital',p3+'%'],
    ['% del cobro que sería recurso propio DDE',p4+'%'],
    ['Flujo bruto potencialmente afectado (Bs)',Math.round(bruto)],
    ['Ingreso propio DDE potencialmente afectado (Bs)',Math.round(propio)]
  ];
}
function getExcelPayload(key){
  var UAI_ROWS=[
    ['Chuquisaca',3199160,2077425,1121735],
    ['La Paz',11010449,8775719,2234730],
    ['Cochabamba',8123529,7823809,299720],
    ['Oruro',2775100,1803236,971864],
    ['Potosí',3523943,2851344,672599],
    ['Tarija',2120831,2472673,-351842],
    ['Santa Cruz',9745800,5221208,4524592],
    ['Beni',2461650,1243401,1218249],
    ['Pando',398100,165759,232341],
    ['Total',43358562,32434574,10923988]
  ];
  var DIGITAL_ANUAL=[
    ['2026',694532],
    ['2027',619928],
    ['2028',619928],
    ['2029',619928],
    ['2030',619928],
    ['Total 5 años',3174244],
    ['Promedio anual',634849]
  ];
  var DIGITAL_COMPONENTES=[
    ['Developer Fullstack Profesional',784620],
    ['Técnico soporte',647520],
    ['Tokens para firma digital',27500],
    ['Equipos (adquisición inicial)',70000],
    ['Mantenimiento',50000],
    ['Nube de Entel (hosting)',1500000],
    ['Gestión y administración del proyecto',70000],
    ['Capacitación del personal',20000],
    ['Contingencia y mejoras (Año 1)',4604]
  ];
  var COMPARE_ROWS=[
    ['Financiamiento físico histórico 2011–2016 (total)',43358562],
    ['Promedio anual físico histórico',7226427],
    ['Proyecto digital 2026–2030 (total)',3174244],
    ['Promedio anual digital',634849],
    ['Año 2026 digital',694532],
    ['Brecha bruta anual de referencia',6591578],
    ['Brecha bruta a 5 años',32957891],
    ['Reducción bruta de referencia', '91,2%']
  ];
  var INC_ROWS=INC.map(function(r){
    return [r[0],r[1],r[2],r[3],r[4]*1000000,r[5]+'%'];
  });
  var IDH_ROWS=[
    ['Servicios personales',3740000,'44,7%'],
    ['Servicios no personales',2540000,'30,4%'],
    ['Materiales',1020000,'12,2%'],
    ['Activos reales',640000,'7,7%'],
    ['Otros',420000,'5,0%'],
    ['Total',8370000,'100,0%']
  ];
  var DDE_BUDGET_ROWS=D.map(function(r){return [r[0],r[1]*1000000,r[2]+'%'];});
  var MAP={
    uai2011_2016:{
      filename:'modelo_fisico_transferencias_UAI_2011_2016.xls',
      title:'Modelo físico: transferencias acumuladas 2011–2016 según Informe UAI INF CI N.º 02/2017',
      note:'Montos acumulados 2011–2016; no representan el costo de un solo año.',
      headers:['Departamento','Gobernación → Ministerio (Bs)','Ministerio → DDE (Bs)','Saldo mostrado en el informe (Bs)'],
      rows:UAI_ROWS
    },
    impresion2016:{
      filename:'costo_impresion_diploma_2016.xls',
      title:'Costo de impresión 2016: indicadores principales',
      note:'Bs 1,257 corresponde al costo unitario de impresión, no al costo total del diploma físico.',
      headers:['Indicador','Valor'],
      rows:[
        ['Diplomas impresos en 2016',187763],
        ['Pago por el servicio de impresión 2016 (Bs)',236018.09],
        ['Precio unitario de impresión (Bs)',1.257],
        ['Costo de impresión descontado en la conciliación acumulada (Bs)',1183969.77],
        ['Saldo pendiente inicial UAI (Bs)',10923988],
        ['Saldo pendiente luego del ajuste de impresión (Bs)',9740018.23]
      ]
    },
    presupuesto_digital:{
      filename:'presupuesto_diploma_digital_2026_2030.xls',
      title:'Presupuesto proyectado del Diploma Digital 2026–2030',
      note:'Documento interno del Ministerio compartido para este análisis.',
      headers:['Concepto','Monto (Bs)'],
      rows:DIGITAL_ANUAL.concat([['','','']]).concat(DIGITAL_COMPONENTES)
    },
    comparacion_fisico_digital:{
      filename:'comparacion_fisico_digital_referencia.xls',
      title:'Comparación física vs. digital: referencia disponible',
      note:'Comparación bruta de referencia entre promedio histórico físico 2011–2016 y presupuesto digital 2026–2030; no ajustada por inflación.',
      headers:['Indicador','Valor'],
      rows:COMPARE_ROWS
    },
    ahorro_fiscal:{
      filename:'ahorro_fiscal_referencia.xls',
      title:'Ahorro fiscal de referencia',
      note:'Ahorro bruto de referencia calculado como promedio anual físico histórico menos promedio anual digital. El ahorro neto requiere incorporar costos residuales DDE y excepciones.',
      headers:['Concepto','Valor'],
      rows:[
        ['Promedio anual físico histórico (Bs)',7226427],
        ['Promedio anual digital proyectado (Bs)',634849],
        ['Ahorro bruto anual de referencia (Bs)',6591578],
        ['Reducción bruta de referencia','91,2%'],
        ['Brecha bruta a 5 años (Bs)',32957891]
      ]
    },
    ingresos_dde:{
      filename:'ingresos_dde_exposicion_legalizaciones.xls',
      title:'Exposición potencial de ingresos DDE por legalizaciones',
      note:'Escenario central: distribución territorial usando beneficiarios 2024 y recursos específicos 2025; el monto expuesto no equivale automáticamente a pérdida real de recursos propios.',
      headers:['Departamento','Diplomas 2024','Diplomas estimados 2026','Otros recursos específicos 2025 (MM Bs)','Exposición máxima estimada (MM Bs)','Exposición sobre recursos específicos'],
      rows:INC_ROWS
    },
    simulador_legalizaciones:{
      filename:'simulador_legalizaciones_actual.xls',
      title:'Simulador: ingreso anual potencial afectado por legalizaciones',
      note:'Archivo generado con los valores actualmente seleccionados en la lámina.',
      headers:['Concepto','Valor'],
      rows:currentSimRows()
    },
    idh_dde:{
      filename:'idh_dde_2016_2025.xls',
      title:'Uso observado del IDH en la base DDE 2016–2025',
      note:'Devengado acumulado observado en la base DDE procesada.',
      headers:['Componente','Monto acumulado (Bs)','Participación'],
      rows:IDH_ROWS
    },
    presupuesto_dde:{
      filename:'presupuesto_institucional_dde_2025.xls',
      title:'Presupuesto institucional de las DDE: vigente 2025',
      note:'Montos del gráfico de participación por DDE.',
      headers:['Departamento','Vigente 2025 (Bs)','Participación del total'],
      rows:DDE_BUDGET_ROWS
    }
  };
  return MAP[key];
}

buildSlideIndex();
go(0);
})();
