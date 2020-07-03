
```python

import json
def out_jsonfile(json_object, json_file):
    "打印对象到文件"
    jsontext=json.dumps(json_object, indent=4)
    with open(json_file, "w") as f:
        f.write(jsontext)
        f.close()
    return

def out_jsontext2file(jsontext, json_file):
    "打印文本到文件"
    with open(json_file, "w") as f:
        f.write(jsontext)
        f.close()
    return

true='true'
false='false'
null='null'

import requests
s=requests.session()
start_url='http://192.168.9.125:8080/ranger-admin/login.jsp'
headers = {
    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate',
	'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36'
}
r=s.get(url=start_url)


data={'j_username':'admin', 'j_password':'admin'}
start_url='http://192.168.9.125:8080/ranger-admin/j_spring_security_check'
r=s.post(url=start_url, data=data)

c=requests.cookies.RequestsCookieJar()
c.set('clientTimeOffset','-480')
s.cookies.update(c)


start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/csrfconf'
r=s.get(url=start_url,headers=headers)
r.status_code
r.text

headers = {
    'Accept':'application/json, text/javascript, */*; q=0.01',
    'Accept-Encoding': 'gzip, deflate',
	'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36'
}
start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/definitions'
r=s.get(url=start_url,headers=headers)

headers = {
    'Accept':'application/json, text/javascript, */*; q=0.01',
    'Accept-Encoding': 'gzip, deflate',
	'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36'
}
start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/policies/service/28'
r=s.get(url=start_url,headers=headers)


----------------------------------------------------------------------------------
curl -ivk -H "Content-type:application/json" -u admin:admin http://192.168.9.125:8080/ranger-admin/service/plugins/policies/download/MyserviceName
start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/policies/download/MyserviceName'
start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/policies/download/hadoopdev001'

service_name='hbasedev'
start_url='http://192.168.9.125:8080/ranger-admin/service/plugins/policies/download/'+service_name
s=requests.session()
headers = {
    'Accept':'application/json, text/javascript, */*; q=0.01',
    'Accept-Encoding': 'gzip, deflate',
	'Accept-Language': 'zh-CN,zh;q=0.9',
    'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36'
}
r=s.get(url=start_url,headers=headers)
out_jsonfile(json.loads(r.text), 'C://download_service_'+service_name+'.json')

service_name='MyHiveService'
start_url='http://192.168.11.240:6080/service/plugins/policies/download/'+service_name
#http://192.168.11.240:6080/
-------------------------------------------------------------------------------------


start_url='http://192.168.9.125:8080/ranger-admin/plugins/policies/service/28'
r=s.get(url=start_url,headers=headers)
start_url='http://192.168.9.125:8080/ranger-admin/plugins/policies/66'
start_url='http://192.168.9.125:8080/ranger-admin/plugins/policies/download/hadoopdev001'
r=s.get(url=start_url,headers=headers)


start_url=’http://192.168.9.125:8080//ranger-admin/service/plugins/policies/service/28‘
r=s.get(url=start_url,headers=headers)
#>>> import json
#>>> aa = json.loads(r.text)
#>>> jsona=json.dumps(aa, indent=4)
#>>> print(jsona)
with open("C://service_def.json", "w") as f:
    f.write(jsona)

with open("C://service_def.json", "w") as f:
    f.write(jsona)

	
	
http://192.168.9.125:8080/ranger-admin/service/plugins/definitions?page=0&pageSize=25&startIndex=0&sortBy=serviceTypeId&_=1566783496509

start_url=’http://192.168.9.125:8080//ranger-admin/service/plugins/policies/service/28‘
start_url='http://192.168.9.125:8080/ranger-admin/plugins/policies/66'
start_url='http://192.168.9.125:8080/ranger-admin/plugins/policies/download/hadoopdev001'

data={'user':'admin', 'password':'admin'}
r=s.get(url=start_url,data=data)

headers['Cookies']=r.headers['Set-Cookie']
headers['Accept']='application/json, text/javascript, */*; q=0.01'
headers['X-Requested-With']='XMLHttpRequest'

application/json, text/javascript, */*; q=0.01
>>> r.cookies.values
<bound method RequestsCookieJar.values of <RequestsCookieJar[Cookie(versio
IONID', value='03437161A12EEA7C312C4F447F11551D', port=None, port_specifie
.125', domain_specified=False, domain_initial_dot=False, path='/ranger-adm
 secure=False, expires=None, discard=True, comment=None, comment_url=None,
rfc2109=False)]>>

>>> r.cookies.get_dict()
{'RANGERADMINSESSIONID': '03437161A12EEA7C312C4F447F11551D'}
>>> c=requests.cookies.RequestsCookieJar()
>>> c.set('clientTimeOffset','-480')
Cookie(version=0, name='clientTimeOffset', value='-480', port=None, port_s
 domain_specified=False, domain_initial_dot=False, path='/', path_specifie
res=None, discard=True, comment=None, comment_url=None, rest={'HttpOnly':





>>> c=requests.cookies.RequestsCookieJar()
>>> c
<RequestsCookieJar[]>
>>> c.set('aaa','bbb')
Cookie(version=0, name='aaa', value='bbb', port=None, port_specified=False, domain='', domain_specif
ied=False, domain_initial_dot=False, path='/', path_specified=True, secure=False, expires=None, disc
ard=True, comment=None, comment_url=None, rest={'HttpOnly': None}, rfc2109=False)
>>>

{'j_username': 'admin', 'j_password': 'admin'}

```
