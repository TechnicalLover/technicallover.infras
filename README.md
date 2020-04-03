# technicallover.infras

welcome to TechnicalLover infrastructure

# Linux Server

## Create User Account

# Baget (Nuget Server)

## Run BaGet

1. Create BaGet working directory

```
$   mkdir baget
```

2. Create file named `baget.env` to store BaGet's configurations

```
$   touch ~/baget/baget.env
```

3. Seed content inside `baget.env`

```
$   echo '# The following config is the API Key used to publish packages.
    # You should change this to a secret value to secure your server.
    ApiKey=NUGET-SERVER-API-KEY

    Storage__Type=FileSystem
    Storage__Path=/var/baget/packages
    Database__Type=Sqlite
    Database__ConnectionString=Data Source=/var/baget/baget.db
    Search__Type=Database' >> ~/baget/baget.env
```

4. Create folder named `baget-data` in the same directory as the `baget.env` file. This will be used by BaGet to persist its state.

```
$   mkdir ~/baget/baget-data
```

5. Pull BaGet's docker image

```
$   docker pull loicsharma/baget
```

6. Run BaGet

```
$   cd ~/baget
$   docker run --rm --name nuget-server -p 5555:80 --env-file baget.env -v "$(pwd)/baget-data:/var/baget" loicsharma/baget:latest
```

## Publish Packages

Publish package with:

```
$   dotnet nuget push -s http://yourhost:5555/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg
```

Publish symbol package with:

```
$   dotnet nuget push -s http://yourhost:5555/v3/index.json -k NUGET-SERVER-API-KEY symbol.package.1.0.0.snupkg
```

# Nginx

[link](https://hub.docker.com/_/nginx)

1. Pull Ngigx's docker image

```
$   docker pull nginx
```

2. Run image

```
$   docker run --name my-nginx -v /mywebcontent:/usr/share/nginx/html:ro -d nginx
```

# EventStore

# SqlServer

[link](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

## Run SqlServer

1. Pull SqlServer's docker image

```
$   docker pull mcr.microsoft.com/mssql/server
```

2. Run image

```
$   docker run --name 'sqlserver' -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=P@ssword1' -p 1433:1433 -d mcr.microsoft.com/mssql/server:latest
```

## Connect and execute sql script

1. Connect to the SQL Server

```
$   docker exec -it sqlserver 'bash'
```

2. Use the `sqlcmd` tool inside of the container

```
$   /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "P@ssword1"
```
