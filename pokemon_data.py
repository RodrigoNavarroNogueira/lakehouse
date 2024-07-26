import requests
import json


resposta = requests.get('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0')
dados = resposta.json()
res = dados['results']
dados_json = json.dumps(res)
dicionario = json.loads(dados_json)

with open('/home/navarro/lakehouse/pokemon.json', 'w') as arquivo:
    arquivo.write(dados_json)

with open('/home/navarro/lakehouse/pokemon_edit.json', 'w') as arquivo:
    for pokemon in dicionario:
        a = str(pokemon)
        string_modificada = a.replace("'", '"')
        arquivo.write(string_modificada + '\n')

print('Pegamos as informações de todos os Pokemon!')