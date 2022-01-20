import apache_beam as beam

p = beam.Pipeline()

black = ('Adão','Jesus','Mike')
White = ('Tulio','Mary','Joca')
first_nations = ('Vic','Marta','Tom')

black_pc = p | "Creating Pcollection black" >> beam.Create(black)
White_pc = p | "Creating Pcollection White" >> beam.Create(White)
first_nations_pc = p | "Creating Pcollection first_nations" >> beam.Create(first_nations)

people = (
    (black_pc,White_pc,first_nations_pc) 
        | beam.Flatten()
        | beam.Map(print))
p.run()