[[ _TOC_ ]]

# Instalación de Primera Infancia en Docker con Portainer

## 1. Configurar VM con Docker

Requerimientos de hardware:

|             | Memoria | CPU    | Disco |
| ----------- | ------- | ------ | ----- |
| Minimo      | 2GB     | 1 vCPU | 20GB  |
| Recomendado | 4GB     | 2 vCPU | 20GB  |

### 1.1 Instalar Docker

Para poder trabajar en la VM, es necesario tener Docker instalado y ejecutándose en la VM. Para ello, [seguimos la documentación oficial de cómo instalar Docker Engine según tu plataforma.](https://docs.docker.com/engine/install/)

En el caso de Ubuntu, son necesarios los siguientes comandos (nótese que si se está usando el usuario `root` hay que evitar usar el comando `sudo`):

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 1.2 Configurar usuario no-root

Si se utiliza un usuario no-root, se debe agregar al usuario al grupo `docker` para poder ejecutar contenedores sin necesidad de sudo. Hay una guía que indica los [pasos post-instalación para sistemas operativos Linux](https://docs.docker.com/engine/install/linux-postinstall/).

```sh 
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker --rm run hello-world
```

## 2. Levantar Caddy con Portainer

Una vez configurado Docker, hay que levantar dos servicios mínimos: [Caddy](https://caddyserver.com/) y [Portainer](https://www.portainer.io/). El primero actuará de proxy reverso, y se encargará de generar los certificados. El segundo, es un panel de adminstración web para host Docker.

La variable de entorno `DOMINIO` debe coincidir con el dominio donde va a ser expuesta la aplicación.

```sh
export DOMINIO=tudominio.com

sed -i "s/priminf.unicen.edu.ar/$DOMINIO/g" Caddyfile

docker compose -f docker-compose.base.yml up -d
```

Una vez levantado los contenedores, se va a poder navegar https://tudominio.com/portainer/ y acceder al panel de administración, donde vas a poder crear el primer usuario de Portainer. 

## 3. Crear _stack_ de Primera Infancia

## 4. Configurar CD

## 5. Configurar backups

### 5.1 Configurar `crontab`

En este repositorio se provee un script de backup simple que genera un dump de la base de datos, y ejecuta el comando `upload-backup <dump>` para poder subir el archivo. En el archivo `.env` se debe definir un directorio donde se van a guardar los backup. Si no se define, utilizará un directorio temporal. Esto último es útil si se copia el backup a un destino remoto.

```sh
crontab -e

# dentro de crontab
@daily /path/hasta/backup.sh >> /var/log/backup.app.log
# o si se desea semanal
@weekly /path/hasta/backup.sh >> /var/log/backup.app.log
```

Esto generará un dump local. Cada entorno deberá definir una implemetación del script `upload-backup`, donde se decidira si subirlo a S3, Google Drive, FTP, scp, etc.

Un ejemplo es realizar scp a otro servidor, para guardar el backup:

```sh
#! /bin/env bash
#
# /usr/bin/upload-backup
scp $1 backup@backup.server:~/backups/
```

De esta forma, se puede cambiar el esquema con el que se distribuirá el backup sin estar atado a una tecnología o método. 