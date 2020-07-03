import yaml
import os
file = open('C://rule.yaml', 'r', encoding='utf-8')
file_data=file.read()
file.close()
data=yaml.load(file_data)


>>> data['type']
'rec'
>>> data['required']
{'title': {'type': 'str', 'length': {'min': 1, 'max':
': 'rec', 'optional': {'category': 'str', 'product':
efinition': 'str'}}, 'detection': {'type': 'rec', 're
pe': 'any', 'of': [{'type': 'str'}, {'type': 'arr', '
 {'min': 2}}]}}, 'optional': {'timeframe': 'str'}, 'r
 [{'type': 'arr', 'contents': 'str'}, {'type': 'map',
'of': [{'type': 'str'}, {'type': 'arr', 'contents': '
]}}]}}}

>>> data['required']['title']
{'type': 'str', 'length': {'min': 1, 'max': 256}}
>>> data['required']['title']['type']
'str'
>>> data['required']['title']['length']
{'min': 1, 'max': 256}


import json
jsontext=json.dumps(data, indent=4)
print(jsontext)
