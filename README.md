# TechnicalLover.Infras

welcome to TechnicalLover infrastructure

## Linux Server

### Create User Account

1. Add new user

    ```
    $   sudo adduser ldt
    ```

2. Add new user to `sudo` group

    ```
    $   usermod -aG sudo ldt
    ```

3. Copy ssh public key from root to new user

    ```
    $   cp -r ./ssh /home/ldt
    ```

4. Change owinership from root to new user. New user can use these files

    ```
    $   sudo chown -R ldt: /home/ldt/.ssh/
    ```

### Setup the repository

1. Update the `apt` package index:

    ```
    $   sudo apt-get update
    ```

2. Install packages allow `apt` to use a repository over HTTPS:

    ```
    $   sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    ```

3. Add Docker's official GPG key:

    ```
    $   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```

    Verify the you now have the key with the fingerprint
    `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88` by search

    ```
    $   sudo apt-key fingerprint 0EBFCD88
    ```

4. Setup **stable** repository

    ```
    $   sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    ```

### Setup Domain Name

-   [How to Use a Custom Domain Name with Your Web Server](https://www.youtube.com/watch?v=C6gfNAAa-d8)

## Docker

1. Update `apt` package index

    ```
    $   sudo apt-get update
    ```

2. Install the _latest version_ of Docker Engine -Community

    ```
    $   sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```

3. Verify that Docker Engine is installed correctly

    ```
    $   sudo docker run hello-world
    ```

4. _(optional)_ If you want `docker command` on your local machine interact with a docker host on server.

    Back to you machine, and set `DOCKER_HOST` environment variable:

    ```
    $   export DOCKER_HOST=ssh://username@server-ip-address
    ```

    If you want to turn back to local docker host, just set this variable with empty string:

    ```
    $   export DOCKER_HOST=
    ```

## Git

```
sudo apt install git-all
```

## Baget (Nuget Server)

### Run BaGet

1. Create BaGet working directory

    ```
    $ mkdir baget
    ```

2. Create file named `baget.env` to store BaGet's configurations

    ```
    $   touch ~/baget/baget.env
    ```

3. Seed content inside `baget.env`

    ```
    $   echo '# The following config is the API Key used to publish packages. # You should change this to a secret value to secure your server.
    ApiKey=NUGET-SERVER-API-KEY

        Storage__Type=FileSystem
        Storage__Path=/var/baget/packages
        Database__Type=Sqlite
        Database__ConnectionString=Data Source=/var/baget/baget.db
        Search__Type=Database' >> ~/baget/baget.env
    ```

4. Create folder named `baget-data` in the same directory as the `baget.env` file. This will be used by BaGet to persist its state.

    ```
    $ mkdir ~/baget/baget-data
    ```

5. Pull BaGet's docker image

    ```
    $ docker pull loicsharma/baget
    ```

6. Run BaGet

    ```
    $   cd ~/baget

    $   docker run --rm --name nuget-server -p 5555:80 --env-file baget.env -v "$(pwd)/baget-data:/var/baget" -d loicsharma/baget:latest
    ```

### Publish Packages

-   Publish package with:

    ```
    $   dotnet nuget push -s http://yourhost:5555/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg
    ```

-   Publish symbol package with:

    ```
    $   dotnet nuget push -s http://yourhost:5555/v3/index.json -k NUGET-SERVER-API-KEY symbol.package.1.0.0.snupkg
    ```

## Nginx

### Up and Running

1. Pull Ngigx's docker image

    ```
    $   docker pull nginx
    ```

2. Setup configuration and content

    ```
    $   mkdir nginx
    $   mkdir nginx/conf
    $   mkdir nginx/www
    $   touch nginx/www/index.html
    $   touch nginx/conf/default.conf
    ```

    _content of default.conf file is in **samples** directory of this repo_

    _inside **nginx/www** you can put you whole website_

3. Run image

    - Run empty nginx

        ```
        $   docker run --name my-nginx -p 80:80 -d nginx
        ```

    - Run nginx with web content and configuration

        ```
        $    docker run --name mynginx -v /home/ldt/nginx/www:/usr/share/nginx/html:ro -v /home/ldt/nginx/conf:/etc/nginx/conf:ro -p 80:80 -d nginx
        ```

4. Start a helper container named `mynginx_files` that has a shell, providing access the content and configuration directories of the `mynginx` container we just created:

    ```
    $   docker run -i -t --volumes-from mynginx --name mynginx_files debian /bin/bash
    ```

    To exit the shell but leave the container running, press `Ctrl+p` followed by `Ctrol+q`.

    To regain shell access to a running container, run this command:

    ```
    $   docker attach mynginx_files
    ```

## EventStore

## SqlServer

### Run SqlServer

1. Pull SqlServer's docker image

    ```
    $   docker pull mcr.microsoft.com/mssql/server
    ```

2. Run image

    ```
    $   docker run --name 'sqlserver' -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=P@ssword1' -p 1433:1433 -d mcr.microsoft.com/mssql/server:latest
    ```

### Connect and execute sql script

1. Connect to the SQL Server

    ```
    $   docker exec -it sqlserver 'bash'
    ```

2. Use the `sqlcmd` tool inside of the container

    ```
    $   /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "P@ssword1"
    ```

## Tools & Referrence

-   [Complete the domain control validation (DCV) for SSL certificate](https://www.namecheap.com/support/knowledgebase/article.aspx/9637/14/how-can-i-complete-the-domain-control-validation-dcv-for-my-ssl-certificate)

-   [Install SSL certificate](https://www.digitalocean.com/community/tutorials/how-to-install-an-ssl-certificate-from-a-commercial-certificate-authority) - [Install SSL certificate on Nginx](https://www.namecheap.com/support/knowledgebase/article.aspx/9419/33/installing-an-ssl-certificate-on-nginx/)

-   [IntoDNS (check dns record)](https://intodns.com/)

-   [Docker for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

*   [Nginx Docker image](https://hub.docker.com/_/nginx) - [Deploying Nginx on Docker](https://www.digitalocean.com/community/tutorials/how-to-run-nginx-in-a-docker-container-on-ubuntu-14-04) - [Managing content and configuration file](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/#managing-content-and-configuration-files)

*   [Quick start: install and connection SQLServer container](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-bash)

## Question

-   [What are pseudo terminals(pty/tty)?](https://unix.stackexchange.com/questions/21147/what-are-pseudo-terminals-pty-tty)

-   [How to kill a service that obtain a specific port](https://stackoverflow.com/questions/10745878/ubuntu-error-with-apache-98address-already-in-use)
