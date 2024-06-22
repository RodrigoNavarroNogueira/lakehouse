import requests
import json


resposta = requests.get('https://pokeapi.co/api/v2/pokemon/ditto')
dados = resposta.json()
dados_json = json.dumps(dados)

with open('/home/navarro/projects/pokeapi/ditto.json', 'w') as arquivo:
    arquivo.write(dados_json)
    print('Pegamos as informações do Ditto!')
