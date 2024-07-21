import requests
import json


resposta = requests.get('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0')
dados = resposta.json()
dados_json = json.dumps(dados, indent=4)

with open('/home/navarro/lakehouse/pokemon.json', 'w') as arquivo:
    arquivo.write(dados_json)
    print('Pegamos as informações de todos os Pokemon!')
