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

# EventStore

# SqlServer
# technicallover.infras
