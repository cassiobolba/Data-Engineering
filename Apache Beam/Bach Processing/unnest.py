dataDict = ('LAX', {'Qtd_Atrasos': [4], 'Tempo_Atrasos': [92]})

class teste(beam.DoFn):
    def process(self,record):
        dict_ = {} 
        dict_['airport'] = str(record[0])
        dict_['lista'] = record[1]
        return(dict_)

    #print(criar_dict(dataDict))

    def process(self,record):
        def expand(key, value):
            if isinstance(value, dict):
                return [ (key + '_' + k, v) for k, v in process(value).items() ]
            else:
                return [ (key, value) ]

        items = [ item for k, v in record.items() for item in expand(k, v) ]

        return dict(items)

    #teste = (desaninhar_dict(criar_dict(dataDict)))
    # teste['lista_Qtd_Atrasos'] = teste['lista_Qtd_Atrasos'][0]
    # teste['lista_Tempo_Atrasos'] = teste['lista_Tempo_Atrasos'][0]

    #print(teste)

    def process(self,record):
        dict_ = {} 
        dict_['airport'] = record['airport']
        dict_['lista_Qtd_Atrasos'] = record['lista_Qtd_Atrasos'][0]
        dict_['lista_Tempo_Atrasos'] = record['lista_Tempo_Atrasos'][0]
        return(dict_)

print(teste(teste))











# def criar_dict2(x):
#     dict_ = {} 
#     dict_['airport'] = str(x[0])
#     dict_['lista_Qtd_Atrasos'] = str(x[1])
#     dict_['lista_Qtd_Atrasos'] = str(x[2])
#     return(dict_)

# print(criar_dict2(teste))

# def criar_lista(x):
#     lista = list(x.values())
#     return lista
# print(criar_lista(teste))