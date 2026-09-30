"""Selección reproducible. Python 3.10+ sin paquetes externos.
Uso: python seleccionar_muestra.py --base seie_matricula_ue_2024.csv --salida resultados
No asigna tratamiento ni verifica la vigencia de los registros.
"""
import argparse, csv, json, hashlib
from pathlib import Path
from collections import defaultdict, Counter

SEED='SEIE-2024-MUESTRA-20260917-V1'
def key(stage,code):
    return hashlib.sha256(f'{SEED}|{stage}|{code}'.encode()).hexdigest()

def allocate(weights,total,minimum=0,capacities=None):
    """Cuotas mínimas + restos mayores; empates por clave. Respeta capacidad."""
    ks=sorted(weights)
    caps=capacities or {k:10**9 for k in ks}
    out={k:min(minimum,caps[k]) for k in ks}
    assert sum(out.values())<=total<=sum(caps.values())
    while sum(out.values())<total:
        active=[k for k in ks if out[k]<caps[k]]
        left=total-sum(out.values()); sw=sum(weights[k] for k in active)
        ideal={k:left*weights[k]/sw for k in active}
        for k in active: out[k]+=min(int(ideal[k]),caps[k]-out[k])
        if sum(out.values())==total: break
        for k in sorted(active,key=lambda k:(-(ideal[k]%1),k)):
            if out[k]<caps[k]: out[k]+=1
            if sum(out.values())==total: break
    return out

def write_csv(path,rows):
    with path.open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=rows[0]); w.writeheader(); w.writerows(rows)

def main(base,dest):
    dest.mkdir(parents=True,exist_ok=True)
    raw=list(csv.DictReader(base.open(encoding='utf-8-sig')))
    assert len(raw)==len({r['codigo_ue'] for r in raw})
    eligible=[]; excluded=[]; mixed=defaultdict(list)
    for r in raw:
        r={**r,'matricula_total':int(r['matricula_total']),'nivel_codigo':int(r['nivel_codigo'])}
        if r['matricula_total']<=0 or r['nivel_codigo']==1:
            excluded.append({**r,'motivo_exclusion':'Matrícula total cero' if r['matricula_total']<=0 else 'Solo inicial'})
            continue
        r['celda_origen']='|'.join([r['codigo_departamento'],r['area_codigo'],r['dependencia_codigo']])
        r['mixta_primaria_secundaria']='Sí' if r['nivel_codigo'] in (6,7) else 'No'
        if r['nivel_codigo'] in (6,7): mixed[r['celda_origen']].append(r)
        else:
            r['nivel_evaluacion']='Primaria' if r['nivel_codigo'] in (2,3) else 'Secundaria'
            r['prob_asignacion_nivel']=1.0
        eligible.append(r)
    for cell,rs in sorted(mixed.items()):
        rs.sort(key=lambda r:key('nivel',r['codigo_ue']))
        n=len(rs)//2
        assert n>0 and n<len(rs), 'Se requiere revisar celdas mixtas con un solo caso'
        for i,r in enumerate(rs):
            r['nivel_evaluacion']='Primaria' if i<n else 'Secundaria'
            r['prob_asignacion_nivel']=(n if i<n else len(rs)-n)/len(rs)
    frames=defaultdict(list)
    for r in eligible:
        r['estrato']=r['nivel_evaluacion']+'|'+r['celda_origen']
        frames[r['estrato']].append(r)
    allocations={}; reserve_alloc={}; quota=[]
    for level in ['Primaria','Secundaria']:
        ns=Counter(r['codigo_departamento'] for r in eligible if r['nivel_evaluacion']==level)
        # Dos pares mínimos por departamento y 12 pares adicionales.
        pairs=allocate(ns,30,minimum=2)
        reserves=allocate(ns,12,minimum=1)
        for dep in sorted(ns):
            cells={h:len(rs) for h,rs in frames.items() if rs[0]['nivel_evaluacion']==level and rs[0]['codigo_departamento']==dep}
            n=2*pairs[dep]
            a=allocate(cells,n,minimum=1,capacities=cells)
            cap={h:cells[h]-a[h] for h in cells}
            b=allocate(cells,reserves[dep],minimum=0,capacities=cap)
            allocations.update(a);reserve_alloc.update(b)
            quota.append(dict(nivel=level,codigo_departamento=dep,departamento=next(r['departamento'] for r in eligible if r['codigo_departamento']==dep),marco=ns[dep],muestra=n,reservas=reserves[dep]))
    for h,rs in sorted(frames.items()):
        rs.sort(key=lambda r:key('seleccion',r['codigo_ue']))
        n=allocations[h]; z=reserve_alloc[h]; N=len(rs)
        for i,r in enumerate(rs,1):
            r.update(tamano_estrato=N,cuota_principal=n,cuota_reserva=z,orden_aleatorio=i,
                lista='Principal' if i<=n else 'Reserva' if i<=n+z else 'No seleccionada',
                prioridad_suplencia=i-n if i>n else '',
                prob_seleccion_condicional=n/N,
                prob_inclusion_nivel=r['prob_asignacion_nivel']*n/N,
                peso_diseno_nivel=1/(r['prob_asignacion_nivel']*n/N),
                tratamiento_control='Pendiente',vigencia='Pendiente de verificación')
    eligible.sort(key=lambda r:(r['nivel_evaluacion'],r['codigo_departamento'],r['estrato'],r['orden_aleatorio']))
    principal=[r for r in eligible if r['lista']=='Principal']
    reserve=[r for r in eligible if r['lista']=='Reserva']
    local_counts=Counter(r['codigo_local_educativo'] for r in eligible)
    selected_counts=Counter(r['codigo_local_educativo'] for r in principal+reserve)
    for r in eligible:
        r['ue_mismo_local_en_marco']=local_counts[r['codigo_local_educativo']]
        r['ue_mismo_local_en_listas']=selected_counts[r['codigo_local_educativo']]
        r['alerta_local']='Revisar local compartido' if local_counts[r['codigo_local_educativo']]>1 else 'Sin coincidencia de código en marco'
    assert len(principal)==120 and len(reserve)==24
    assert len({r['codigo_ue'] for r in principal+reserve})==144
    assert Counter(r['nivel_evaluacion'] for r in principal)=={'Primaria':60,'Secundaria':60}
    assert Counter(r['nivel_evaluacion'] for r in reserve)=={'Primaria':12,'Secundaria':12}
    assert all(q['muestra']>=4 and q['muestra']%2==0 for q in quota)
    assert all(r['nivel_codigo'] in ((2,3,6,7) if r['nivel_evaluacion']=='Primaria' else (4,5,6,7)) for r in eligible)
    # Horvitz-Thompson: la muestra ponderada debe recuperar el universo de cada nivel.
    # No exige igualdad exacta en una realización, especialmente por mezcla de escuelas puras y mixtas.
    comparison=[]
    for level in ['Primaria','Secundaria']:
        fr=[r for r in eligible if r['nivel_evaluacion']==level]
        ss=[r for r in principal if r['nivel_evaluacion']==level]
        for variable in ['departamento','area','dependencia','mixta_primaria_secundaria']:
            for v in sorted({r[variable] for r in fr}):
                a=sum(r[variable]==v for r in fr);b=sum(r[variable]==v for r in ss)
                comparison.append(dict(nivel=level,variable=variable,categoria=v,marco=a,muestra=b,proporcion_marco=a/len(fr),proporcion_muestra=b/len(ss)))
    checks=dict(semilla=SEED,sha256_base=hashlib.sha256(base.read_bytes()).hexdigest(),
        fuente_registros=len(raw),elegibles_provisionales=len(eligible),excluidos=len(excluded),
        motivos_exclusion=dict(Counter(r['motivo_exclusion'] for r in excluded)),
        muestra=120,reservas=24,codigos_distintos=144,
        composicion_muestra={v:dict(Counter(r[v] for r in principal)) for v in ['nivel_evaluacion','area','dependencia','mixta_primaria_secundaria']},
        principales_local_compartido=sum(r['ue_mismo_local_en_marco']>1 for r in principal),
        locales_repetidos_entre_listas={k:v for k,v in selected_counts.items() if v>1},
        distritos_faltantes_principales=sum(not r['distrito_educativo'] for r in principal),
        asignaciones_tratamiento=0)
    for name,rs in [('muestra_propuesta.csv',principal),('reservas.csv',reserve),('universo_elegible.csv',eligible),('exclusiones.csv',excluded),('distribucion.csv',quota),('comparacion.csv',comparison)]: write_csv(dest/name,rs)
    data=dict(principal=principal,reservas=reserve,universo=eligible,exclusiones=excluded,distribucion=quota,comparacion=comparison,validacion=checks)
    (dest/'datos_muestra.json').write_text(json.dumps(data,ensure_ascii=False),encoding='utf-8')
    (dest/'validacion_muestra.json').write_text(json.dumps(checks,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(checks,ensure_ascii=False,indent=2));print(json.dumps(quota,ensure_ascii=False))

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--base',type=Path,default=Path('seie_matricula_ue_2024.csv'));p.add_argument('--salida',type=Path,default=Path('resultados'));a=p.parse_args();main(a.base,a.salida)
