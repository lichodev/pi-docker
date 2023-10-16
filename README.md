# Despliegue de Primera Infancia

## Build de imágenes de las aplicaciones

### Cliente (Angular)

1. Clonamos el repositorio

```bash
$ git clone https://github.com/SoleMer/primera-infancia.git angular
```

2. Entramos al repositorio

```bash
$ cd angular
```

3. Creamos la imagen:

```bash
$ docker build -t primera-infancia/angular .
```

### Backend (Java Springboot)

1. Clonamos el repositorio

```bash
$ git clone https://github.com/SoleMer/primeraInfanciaRest.git springboot
```

2. Entramos al repositorio

```bash
$ cd springboot
```

3. Creamos la imagen:

```bash
$ docker build -t primera-infancia/springboot .
```

## Desplegar imágenes con Docker

Toda la configuración está en este repositorio por lo que es útil clonarlo.

```bash
$ git clone https://gitlab.com/SoleMer/primera-infancia-docker deploy && cd deploy
```

La configuración se obtiene de un archivo `.env` para proteger las credenciales. Se debe copiar el archivo de ejemplo y completar los campos correspondientes.

```bash
$ cp .env.example .env
```

Se debe crear un volumen para almacenar los datos del contendor de MySQL. Utilizaremos un volumen externo al `docker-compose.yml`.

```bash
$ docker volume create pi_data
```

Ya se pueden levantar los contenedores definidos en el archivo `docker-compose.yml`.

```bash
$ docker compose up -d
```

### Inicialización de la base de datos

Al iniciar los contenedores, cuando se inicializa por primera el contenedor con la imagen de `mysql`, se creará una base de datos con el nombre especificado en el archivo `.env` y ejecutará el archivo `primera_infancia.sql` al inicio para precargar datos.

Finalemente la aplicación ya está disponible en sus respectivos puertos.
