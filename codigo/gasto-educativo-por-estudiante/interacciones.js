
(function(){
var $=function(id){return document.getElementById(id)};
var slides=[].slice.call(document.querySelectorAll('.slide')),i=0,F={};
var LV=['Preprimaria','Primaria','Secundaria'];
var LD=['<b>Preprimaria:</b> educación inicial, los años antes de entrar a primaria (en Bolivia, aprox. 4 a 5 años de edad).','<b>Primaria:</b> los primeros 6 años de escuela (aprox. 6 a 11 años).','<b>Secundaria:</b> los 6 años siguientes (aprox. 12 a 17 años). Aquí se cuentan juntas la secundaria inferior y la superior.'];
// leyenda de niveles en las láminas 7 a 14
[6,7,8,9,10,11,12,13].forEach(function(n){
 var p=slides[n].querySelector('p'),d=document.createElement('details');d.className='leg';if(n===6)d.open=true;
 d.innerHTML='<summary>¿A qué se refiere cada nivel?</summary>'+LD.map(function(x){return '<p>'+x+'</p>'}).join('')+'<p class="mut">Clasificación internacional de UNESCO (CINE). Las edades varían según el país.</p>';
 p.parentNode.insertBefore(d,p.nextSibling);
});
function go(n){
 i=Math.max(0,Math.min(slides.length-1,n));
 slides.forEach(function(s,k){s.classList.toggle('on',k===i)});
 $('bar').style.width=((i+1)/slides.length*100)+'%';
 $('count').textContent=(i+1)+' de '+slides.length;
 $('prev').disabled=i===0;$('next').disabled=i===slides.length-1;
 slides[i].scrollTop=0;
 var f=slides[i].dataset.init;if(f&&F[f])F[f]();
}
$('prev').onclick=function(){go(i-1)};$('next').onclick=function(){go(i+1)};
var IX=[['Introducción','#0E7C7B',[[2,'La pregunta del estudio','¿Cuánto invierte Bolivia y qué esfuerzo hace?']]],
['Para entender los números','#E0A100',[[3,'Qué es PPP$','Un dólar que compra lo mismo en todos lados'],[4,'Media, mediana, P25 y P75','Cómo leerlos con un ejemplo'],[5,'Con quién comparamos a Bolivia','Pares y mismo ingreso']]],
['Comparaciones','#3B7DD8',[[6,'El gasto por estudiante en el mundo','Preprimaria, primaria y secundaria'],[7,'Bolivia frente a los grupos','Mundo, ALC, pares y mismo ingreso'],[8,'Ranking de América Latina','Dónde está Bolivia entre sus vecinos']]],
['Resultados de Bolivia','#B3261E',[[9,'Qué significa 35 de 100 y 98 de 100','Bolivia en la fila de 100 países'],[10,'Prioridad frente a tamaño económico','Esfuerzo y recursos por nivel'],[11,'Gasto real frente a esperado','De dónde sale lo esperado'],[12,'Cómo se reparte entre niveles','Ejemplo con tortas y un curso'],[13,'Evolución 2006–2024','Cuánto se multiplicó el gasto']]],
['Cierre','#0E7C7B',[[14,'Conclusión','Esfuerzo excepcional y camino para seguir creciendo']]]];
var il=$('il'),idx=$('idx');
function drawIdx(el){
 el.innerHTML=IX.map(function(g){return '<div class="ixg">'+g[0]+'</div><div class="ixgrid">'+g[2].map(function(x){return '<button class="it'+(x[0]===i?' cur':'')+'" style="--gc:'+g[1]+'" data-n="'+x[0]+'"><b>'+(x[0]+1)+'</b><strong>'+x[1]+'</strong><em>'+x[2]+'</em></button>'}).join('')+'</div>'}).join('');
 [].forEach.call(el.querySelectorAll('.it'),function(b){b.onclick=function(){if(el===il)idx.classList.remove('on');go(+b.dataset.n)}});
}
F.ixs=function(){drawIdx($('ixl'))};
function openIdx(){drawIdx(il);idx.classList.add('on');var c=il.querySelector('.cur');(c||il.querySelector('.it')).focus();(c||il).scrollIntoView({block:'center'})}
function closeIdx(){idx.classList.remove('on');$('oi').focus()}
$('oi').onclick=openIdx;$('xi').onclick=closeIdx;
document.addEventListener('keydown',function(e){
 if(e.target.tagName==='INPUT')return;
 if(e.key==='Escape'&&idx.classList.contains('on')){closeIdx();return}
 if(e.key==='i'||e.key==='I'){idx.classList.contains('on')?closeIdx():openIdx();return}
 if(idx.classList.contains('on'))return;
 if(e.key==='ArrowRight'||e.key==='PageDown')go(i+1);
 if(e.key==='ArrowLeft'||e.key==='PageUp')go(i-1);
});
var x0=null;
document.addEventListener('touchstart',function(e){x0=e.touches[0].clientX},{passive:true});
document.addEventListener('touchend',function(e){
 if(x0===null)return;var d=e.changedTouches[0].clientX-x0;x0=null;
 if(Math.abs(d)>70&&!e.target.closest('button,input,#idx,details'))go(d<0?i+1:i-1);
},{passive:true});
function tabs(id,names,cb){
 var el=$(id);
 names.forEach(function(n,k){
  var b=document.createElement('button');b.className='tab';b.textContent=n;b.setAttribute('aria-pressed','false');
  b.onclick=function(){[].forEach.call(el.children,function(t){t.setAttribute('aria-pressed',t===b)});cb(k)};
  el.appendChild(b);
 });
 el.children[0].click();
}
function fmt(n,d){return n.toLocaleString('es-BO',{minimumFractionDigits:d||0,maximumFractionDigits:d||0})}
function sg(n){return (n>0?'+':'')+fmt(n,1)+'%'}
function anim(el){requestAnimationFrame(function(){requestAnimationFrame(function(){
 [].forEach.call(el.querySelectorAll('.fill'),function(f){f.style.width=f.dataset.w})})})}
function bar(l,v,max,cls,t){return '<div class="row"><span>'+l+'</span><div class="track"><div class="fill'+(cls?' '+cls:'')+'" data-w="'+(v/max*100)+'%"></div></div><b>'+t+'</b></div>'}

// 3
var T2=[['Recursos','Cuántos dólares recibe cada estudiante al año, medidos en PPP$ (ver lámina siguiente).'],
['Esfuerzo','Qué parte de la riqueza del país se destina a cada estudiante. Ejemplo: si el PIB per cápita fuera 100 y se gasta 28 por estudiante, el esfuerzo es 28%.'],
['Capacidad','Qué tan rica es la economía (PIB per cápita). Un país más rico puede gastar más dólares aun haciendo menos esfuerzo.']];
tabs('t2',T2.map(function(t){return t[0]}),function(k){$('b2').textContent=T2[k][1]});
var P3=[['Con tipo de cambio','Un almuerzo cuesta Bs 15 en La Paz y US$ 15 en una ciudad de EE. UU. Si solo cambiamos bolivianos a dólares, esos Bs 15 valen mucho menos de US$ 15. Parece que en Bolivia el almuerzo “vale poco”, pero en La Paz esos Bs 15 compran un almuerzo completo.'],
['Con PPP','PPP mide cuántas cosas compra el dinero en cada país. Con PPP, los Bs 15 de La Paz y los US$ 15 de EE. UU. se cuentan como el mismo valor, porque cada uno compra un almuerzo. Así, gastar “PPP$ 3.062” en un estudiante significa lo mismo en Bolivia, Chile o Costa Rica.']];
tabs('t3',P3.map(function(t){return t[0]}),function(k){$('b3').textContent=P3[k][1]});

// 4
var N=[2,3,4,5,6,8,10,14,40];
$('chips').innerHTML=N.map(function(n){return '<span>'+n+'</span>'}).join('');
var M4=[['Media','Sume el gasto por estudiante de los 9 países y divida entre 9: 92 ÷ 9 = 10,2 (PPP$ 10.200 por estudiante). Es el “promedio”. Un solo país muy rico (40) la sube mucho.',[]],
['Mediana','Es el gasto por estudiante del país del medio de la fila: el quinto de 9. Vale 6 (PPP$ 6.000). La mitad de los países gasta menos y la otra mitad más. No se deja arrastrar por el país de 40.',[4]],
['P25','Es el gasto por estudiante que deja atrás a 1 de cada 4 países. En esta fila es el tercero: 4 (PPP$ 4.000). Muestra el nivel de los países que gastan poco.',[2]],
['P75','Deja atrás a 3 de cada 4 países. En esta fila es el séptimo: 10 (PPP$ 10.000). Muestra el nivel de los países que gastan mucho.',[6]]];
tabs('t4',M4.map(function(t){return t[0]}),function(k){
 [].forEach.call($('chips').children,function(c,j){c.className=M4[k][2].indexOf(j)>-1?'h':''});
 $('b4').textContent=M4[k][1]+(k===0?'':' (Media: 10,2. Mediana: 6.)');
});

// 5
var GR=[['Mundo','Todos los países con dato. Sirve para ver dónde está Bolivia en el ranking mundial, aunque incluye países muy ricos.'],
['América Latina y el Caribe (ALC)','Los países de la región. Son vecinos con historia y economías más parecidas.'],
['Pares','Países con una economía de tamaño parecido al de Bolivia: su PIB per cápita PPP está entre 25% menos y 25% más que el boliviano. Es como comparar a Bolivia con sus “compañeros de curso” en riqueza. Son solo 7 países con dato.'],
['Mismo ingreso','Países que el Banco Mundial pone en el mismo grupo de ingreso que Bolivia. El grupo es más amplio que los pares (11 a 12 países con dato) y con países más pobres.']];
GR.forEach(function(x){
 var a=document.createElement('div');a.className='acc';
 a.innerHTML='<button aria-expanded="false">'+x[0]+'<span>+</span></button><div>'+x[1]+'</div>';
 a.firstChild.onclick=function(){var o=a.classList.toggle('open');a.firstChild.setAttribute('aria-expanded',o)};
 $('a5').appendChild(a);
});

// 6
var W=[[1448,4880,5906,9193,1524,84],[2263,4774,7279,11244,3062,93],[2459,5630,7810,12839,2531,91]];
tabs('t6',LV,function(k){
 var w=W[k],m=13500;
 $('c6').innerHTML=bar('P25',w[0],m,'',fmt(w[0]))+bar('Mediana',w[1],m,'',fmt(w[1]))+bar('Media',w[2],m,'',fmt(w[2]))+bar('P75',w[3],m,'',fmt(w[3]))+bar('Bolivia',w[4],m,'g',fmt(w[4]));
 $('d6').innerHTML=LD[k]+'<br>Con datos de '+w[5]+' países. Los del cuarto de arriba (P75) gastan <b>'+fmt(w[3]/w[0],1)+' veces</b> lo que los del cuarto de abajo (P25). Bolivia invierte PPP$ '+fmt(w[4])+' por estudiante: ya alcanza el <b>'+fmt(w[4]/w[1]*100)+'%</b> de lo que gasta el país del medio del mundo (PPP$ '+fmt(w[1])+').';
 anim($('c6'));
});
F.world=function(){anim($('c6'))};

// 7
var G=[[4880,2080,1237,830,1524,-68.8,-26.7,23.2,83.8],[4774,2979,1925,841,3062,-35.9,2.8,59.1,264.1],[5630,3661,2004,1339,2531,-55.1,-30.9,26.3,89.0]];
tabs('t7',LV,function(k){
 var g=G[k],m=6000;
 $('c7').innerHTML=bar('Mundo',g[0],m,'',fmt(g[0]))+bar('ALC',g[1],m,'',fmt(g[1]))+bar('Pares',g[2],m,'',fmt(g[2]))+bar('Mismo ingreso',g[3],m,'',fmt(g[3]))+bar('Bolivia',g[4],m,'g',fmt(g[4]));
 function ph(x,l){return x<0?'Frente a '+l+': Bolivia ya alcanza el <b>'+fmt(100+x)+'%</b> de su gasto por estudiante.':'Frente a '+l+': Bolivia gasta <b>'+fmt(x,1)+'% más</b> por estudiante.'}
 $('d7').innerHTML=LD[k]+'<br>'+ph(g[5],'el país del medio del mundo')+'<br>'+ph(g[6],'el país del medio de ALC')+'<br>'+ph(g[7],'el país del medio de sus pares')+'<br>'+ph(g[8],'el país del medio de su mismo ingreso');
 anim($('c7'));
});
F.grp=function(){anim($('c7'))};

// 8
var NM={CHL:'Chile',MEX:'México',CRI:'Costa Rica',DOM:'Rep. Dominicana',ARG:'Argentina',BLZ:'Belice',ECU:'Ecuador',NIC:'Nicaragua',URY:'Uruguay',TTO:'Trinidad y T.',BOL:'Bolivia',GTM:'Guatemala',SLV:'El Salvador',PER:'Perú',PRY:'Paraguay',JAM:'Jamaica',HND:'Honduras',BRA:'Brasil',BRB:'Barbados',PAN:'Panamá'};
var A={0:{CHL:[6807,20.7],MEX:[3084,12.7],CRI:[5743,20.5],DOM:[2647,10.2],ARG:[4779,15.9],BLZ:[2360,17.5],ECU:[4916,30.9],NIC:[271,3.3],URY:[4764,13.8],TTO:[410,1.2],BOL:[1524,14.0],GTM:[1669,11.9],SLV:[1237,9.6],PER:[2603,15.0],PRY:[2080,11.5],JAM:[875,7.9],HND:[1518,20.8]},
1:{BRA:[3926,19.1],CHL:[5140,15.7],MEX:[3140,12.9],NIC:[887,10.7],CRI:[5724,20.4],DOM:[5019,19.4],ECU:[1817,11.4],BLZ:[2360,17.5],BRB:[4436,22.4],TTO:[3185,9.2],URY:[4774,13.8],ARG:[4531,15.1],PAN:[4145,10.4],PRY:[2263,12.5],SLV:[1925,14.9],HND:[1511,20.7],BOL:[3062,28.0],PER:[2228,12.8],GTM:[1853,13.2],JAM:[2901,26.2]},
2:{MEX:[3301,14.0],CHL:[6274,19.1],BRA:[4233,20.6],URY:[4975,14.4],TTO:[4537,13.1],BRB:[3699,18.7],ARG:[5313,17.7],DOM:[3572,13.8],CRI:[5630,20.1],BLZ:[2307,17.1],ECU:[1057,6.6],NIC:[484,5.8],PER:[2871,16.5],PRY:[2492,13.8],HND:[1646,22.5],JAM:[3661,33.1],SLV:[2004,15.5],GTM:[819,5.8],BOL:[2531,23.2]}};
var lv8=0,mt8=0;
function r8(){
 var o=A[lv8],d=Object.keys(o).sort(function(a,b){return o[b][mt8]-o[a][mt8]}),pos=d.indexOf('BOL')+1,mx=mt8?34:7000;
 $('c8').innerHTML=d.map(function(c){return bar(NM[c],o[c][mt8],mx,c==='BOL'?'g':'',mt8?fmt(o[c][1],1)+'%':fmt(o[c][0]))}).join('');
 $('d8').innerHTML=LD[lv8]+'<br>En <b>'+LV[lv8].toLowerCase()+'</b>, Bolivia ocupa el <b>puesto '+pos+' de '+d.length+'</b> en '+(mt8?'esfuerzo (qué parte de su riqueza destina por estudiante)':'recursos (dólares PPP por estudiante)')+' y supera a '+(d.length-pos)+' países de la región.';
 anim($('c8'));
}
tabs('t8a',LV,function(k){lv8=k;r8()});
tabs('t8b',['Recursos (PPP$)','Esfuerzo (% del PIB per cápita)'],function(k){mt8=k;r8()});

// 9
var PC=[[27.4,44.0],[35.5,97.8],[27.5,76.9]];
var lv9=0,mt9=0;
function r9(){
 var n=Math.round(PC[lv9][mt9]),h='';
 for(var k=1;k<=100;k++)h+='<i class="'+(k===n?'top':(k<n?'on':''))+'"></i>';
 $('dots').innerHTML=h;
 var t=LV[lv9].toLowerCase(),msg;
 if(mt9){msg='En <b>esfuerzo</b> ('+t+'), Bolivia destina a cada estudiante una parte de su riqueza mayor que la de <b>'+n+' de cada 100 países</b>.'+(n>=90?' Solo '+(100-n)+' de cada 100 hacen más esfuerzo: Bolivia está entre los países más comprometidos del mundo con la educación.':' Es una posición sólida y con margen para seguir subiendo.')}
 else{msg='En <b>recursos</b> ('+t+'), Bolivia gasta más dólares por estudiante que <b>'+n+' de cada 100 países</b>, siendo una economía mediana. Es la base para seguir escalando posiciones.'}
 $('d9').innerHTML=LD[lv9]+'<br>'+msg;
 $('dots').setAttribute('aria-label','Bolivia supera a '+n+' de 100 países');
}
tabs('t9a',LV,function(k){lv9=k;r9()});
tabs('t9b',['Recursos','Esfuerzo'],function(k){mt9=k;r9()});
F.pct=r9;

// 10
var B=[[27.4,44.0,16.7],[35.5,97.8,62.4],[27.5,76.9,49.4]];
tabs('t10',LV,function(k){
 var r=B[k];
 $('c10').innerHTML=bar('Recursos',r[0],100,'','lugar '+fmt(r[0])+' de 100')+bar('Esfuerzo',r[1],100,'g','lugar '+fmt(r[1])+' de 100');
 $('d10').innerHTML=LD[k]+'<br>En <b>'+LV[k].toLowerCase()+'</b>, Bolivia está <b>'+fmt(r[2],1)+' lugares más arriba</b> en esfuerzo que en recursos. Es decir, destina a la educación una parte de su riqueza mayor que la de '+fmt(r[1])+' de cada 100 países, y por eso logra recursos por estudiante que superan a los de '+fmt(r[0])+' de cada 100. '+(k===1?'En primaria el esfuerzo es casi máximo.':'');
 anim($('c10'));
});
F.ber=function(){anim($('c10'))};

// 11
var O=[[1524,7.0],[3062,35.5],[2531,4.4]];
F.pred=function(){
 $('c11').innerHTML=LV.map(function(l,k){var o=O[k][0],p=o/(1+O[k][1]/100);
  return '<p style="margin:10px 0 2px"><b>'+l+':</b> Bolivia gasta <b>'+fmt(O[k][1],1)+'% más</b> de lo esperado por su riqueza</p>'+bar('Esperado',p,3500,'',fmt(p))+bar('Bolivia',o,3500,'g',fmt(o))}).join('');
 anim($('c11'));
};

// 12
F.alloc=function(){
 var R=[['Preprimaria',49.8],['Secundaria',82.7],['Primaria',100]];
 $('c12x').innerHTML=R.map(function(r){return bar(r[0],r[1],100,r[1]<100?'':'g',fmt(r[1])+' de 100')}).join('');
 r12();
};
var E=[['Preprimaria',1524],['Secundaria',2531],['Primaria',3062]];
function r12(){
 var n=+$('n12').value,mx=3062*60;$('v12').textContent=n;
 $('c12').innerHTML=E.map(function(e){return bar(e[0],e[1]*n,mx,e[0]==='Primaria'?'g':'','PPP$ '+fmt(e[1]*n))}).join('');
 $('d12').innerHTML='<b>Con lo que Bolivia gasta en 1 estudiante de primaria (PPP$ 3.062) se financia a 2 de preprimaria (PPP$ 1.524 cada uno).</b> En un curso de '+n+' estudiantes: primaria PPP$ '+fmt(3062*n)+', secundaria PPP$ '+fmt(2531*n)+' y preprimaria PPP$ '+fmt(1524*n)+' al año. Preprimaria es la gran oportunidad para seguir creciendo. Nota: la diferencia entre niveles no significa por sí sola que falte dinero; también influyen los costos de cada nivel, cuántos niños atiende y cómo se organiza.';
 anim($('c12'));
}
$('n12').oninput=r12;

// 13
var Y=['2006','2009','2012','2015','2018','2021','2024'];
var S=[[538,811,909,1402,1429,1289,1524],[1601,2211,2080,2706,3053,3050,3062],[718,992,1187,2074,2448,2353,2531]];
var med=[4880,4774,5630];
tabs('t13',LV,function(k){
 var s=S[k];
 $('k13').innerHTML='<div class="kpi"><b>×'+fmt(s[6]/s[0],1)+'</b>veces más gasto por estudiante entre 2006 y 2024</div><div class="kpi"><b>'+fmt(s[6]/med[k]*100)+'%</b>de la mediana mundial ya alcanzado</div>';
 $('c13').innerHTML=Y.map(function(y,j){return bar(y,s[j],6000,j===6?'g':'',fmt(s[j]))}).join('')+bar('Mediana mundial',med[k],6000,'',fmt(med[k]));
 $('d13').innerHTML=LD[k]+'<br>En '+LV[k].toLowerCase()+', Bolivia pasó de PPP$ '+fmt(s[0])+' a PPP$ '+fmt(s[6])+' por estudiante. La tendencia es ascendente y la mediana mundial (PPP$ '+fmt(med[k])+') es la referencia hacia la que puede seguir acercándose.';
 anim($('c13'));
});
F.evo=function(){anim($('c13'))};

// 14
var X=[['Un esfuerzo excepcional','En primaria destina 28% del PIB per cápita por estudiante, más que los otros 19 países de ALC comparados y más que 98 de cada 100 países del mundo.'],
['Gasta más de lo que su riqueza haría esperar','+35,5% en primaria, +7,0% en preprimaria y +4,4% en secundaria frente a lo esperado según el ingreso del país.'],
['Supera a sus pares y a países de su mismo ingreso','Frente a sus pares gasta 23% más en preprimaria, 59% más en primaria y 26% más en secundaria. Frente al grupo de su mismo ingreso, 84%, 264% y 89% más.'],
['Un gasto que creció con fuerza','Desde 2006 se multiplicó por 2,8 en preprimaria, 1,9 en primaria y 3,5 en secundaria.'],
['Camino para seguir creciendo','Bolivia ya alcanza el 64% de la mediana mundial en primaria, 45% en secundaria y 31% en preprimaria. Preprimaria es la mayor oportunidad para acercarse al resto del mundo, manteniendo el esfuerzo actual.'],
['Qué NO dice este estudio','No prueba que más gasto mejore el aprendizaje, ni mide eficiencia, ni dice cuál es el gasto ideal. Los datos no cubren igual a todos los países y años.']];
X.forEach(function(x,k){
 var a=document.createElement('div');a.className='acc'+(k===0||k===4?' open':'');
 a.innerHTML='<button aria-expanded="'+(k===0||k===4)+'">'+x[0]+'<span>+</span></button><div>'+x[1]+'</div>';
 a.firstChild.onclick=function(){var o=a.classList.toggle('open');a.firstChild.setAttribute('aria-expanded',o)};
 $('a14').appendChild(a);
});
go(0);
})();
