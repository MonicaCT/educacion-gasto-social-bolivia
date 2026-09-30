"""Static public-site checks. Run with Python 3, no external dependencies."""
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import urlsplit, unquote
import json, re, sys
ROOT=Path(__file__).resolve().parents[2]
class Links(HTMLParser):
    def __init__(self):super().__init__();self.urls=[]
    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key in ('src','href','poster') and value:self.urls.append(value)
errors=[];checked=0
for p in ROOT.rglob('*.html'):
    parser=Links();parser.feed(p.read_text(encoding='utf-8-sig',errors='replace'))
    for url in parser.urls:
        u=urlsplit(url)
        if u.scheme or u.netloc or not u.path:continue
        checked+=1
        if not (p.parent/unquote(u.path)).exists():errors.append(f'{p.relative_to(ROOT)}: missing {url}')
pattern=re.compile(r'(?:[A-Za-z]:[/\\](?:Users|Documents)[^\s\"<>\x27]*|file:///|gh[pousr]_[A-Za-z0-9]{25,}|github_pat_[A-Za-z0-9_]{25,}|-----BEGIN [A-Z ]*PRIVATE KEY-----)')
for p in ROOT.rglob('*'):
    if not p.is_file() or '.git' in p.parts or p==Path(__file__).resolve():continue
    if p.stat().st_size>100_000_000:errors.append(f'{p.relative_to(ROOT)} exceeds GitHub file limit')
    if p.suffix.lower() in ('.html','.js','.json','.md','.py','.r','.ps1','.yml','.csv','.txt','.do'):
        if pattern.search(p.read_text(encoding='utf-8-sig',errors='replace')):errors.append(f'{p.relative_to(ROOT)}: local path or credential pattern; inspect privately')
products=json.loads((ROOT/'assets/productos.json').read_text(encoding='utf8'))
assert len(products)==8
for p in products:
    for dest in [p['url'],f'datos/{p["data"]}/index.html',f'codigo/{p["code"]}/index-fuentes.html',f'documentacion/metodologia/{p["id"]}.html']:
        if not (ROOT/dest).is_file():errors.append('Missing product resource: '+dest)
print(json.dumps({'products':len(products),'local_links_checked':checked,'errors':errors},ensure_ascii=False,indent=2))
sys.exit(bool(errors))
