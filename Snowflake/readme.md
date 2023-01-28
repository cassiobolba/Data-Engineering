# Snowflake

# Intro 

## Criar Account
- explicar as difrencas 
- enquanto espera o email mostrar por cima as docs

## Acessar a instancia
- url
- login app.snowflake.com enter the instance name
- save the link to login to your account
- mostrar onde no painel pegar o account name

## Snowsight
- sheets - executa código, pode organizar, estilo notebook
- databases - dbs que tem acesso
- se nao tiver acesso as samples:
```sql
-- Create a database from the share.
create database snowflake_sample_data from share sfc_samples.sample_data;

-- Grant the PUBLIC role access to the database.
-- Optionally change the role name to restrict access to a subset of users.
grant imported privileges on database snowflake_sample_data to role public;
	we can’t run, because no warehouse
```

## Architecture 
https://docs.snowflake.com/en/user-guide/intro-key-concepts.html
- 3 layers
- storage: columnar compressed data stored in object storage (if - selected AWS, S3)
- query processing: virtual WH are servers
    - Various sizes XS (1 - server)  to 4XL (128 servers) that are independent
    - Billed by - credit (1 server = 1 credit) billed by second (min 1min). Can - use multi cluster to increase WH number during usage peak
- cloud provider: chooses provider that manages various activities to run snowflake