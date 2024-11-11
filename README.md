# Docker Matomo App (v5.1.2)

This repository provides a **Dockerized version of Matomo v5.1.2**, an open-source web analytics platform. The Docker image has been created by cloning the official Matomo repository, setting up the necessary dependencies, and pushing it to Docker Hub. This setup allows you to easily deploy Matomo with MariaDB using Docker.

## Docker Image

- **Image Name**: `sampath987/matomo-app`
- **Tag**: `latest`

You can easily pull this image from Docker Hub and run Matomo in a Docker container.

## Features

- Matomo v5.1.2 pre-configured and ready to run in Docker.
- Based on PHP 8.3 with Nginx as the web server.
- Includes all necessary PHP extensions for Matomo.
- Configured to run with PHP-FPM and Nginx.
- Persistent data storage via Docker volumes.

## Requirements

1. **Docker** and **Docker Compose** installed on your machine.
2. A **Docker network** for linking Matomo with MariaDB.

## How to Set Up

### Step 1: Create a Docker Network

First, create a Docker network to allow communication between the Matomo app and the MariaDB container.

```bash
docker network create matomo_network
```

### Step 2: Pull and Run the MariaDB Container

Next, you'll need to pull and run a MariaDB container that Matomo will use for its database. Use the following command to run the MariaDB container:

```bash
docker run -d --name matomo_mariadb -p 3306:3306 \
  -e MYSQL_DATABASE=matomo \
  -e MYSQL_USER=matomouser \
  -e MYSQL_PASSWORD=matomopass \
  -e MYSQL_ROOT_PASSWORD=root_password \
  -v mariadb_data:/var/lib/mysql \
  --network matomo_network \
  mariadb:latest
```

This command will:

- Create a MariaDB container named `matomo_mariadb`.
- Expose the database on port `3306`.
- Set up the Matomo database with the following credentials:
  - **Database**: `matomo`
  - **User**: `matomouser`
  - **Password**: `matomopass`
  - **Root Password**: `root_password`
- Link the MariaDB container to the `matomo_network`.

### Step 3: Pull and Run the Matomo App Container

After setting up MariaDB, run the Matomo container using the following command:

```bash
docker run -d --name matomo_app --network matomo_network -p 8081:80 \
  --link matomo_mariadb:mariadb \
  -v matomo_data:/var/www/html \
  sampath987/matomo-app:latest
```

This command will:

- Create a Matomo container named `matomo_app`.
- Expose Matomo on port `8081`.
- Link the Matomo container to the MariaDB container.
- Mount a volume (`matomo_data`) to persist Matomo's data.

### Step 4: Access Matomo

Once both containers are running, you can access the Matomo application in your browser at:

```
http://localhost:8081
```

Follow the on-screen instructions to complete the setup of Matomo, including connecting to your MariaDB database.

### Step 5: Persisting Data

Both the MariaDB and Matomo containers use Docker volumes to persist data:

- **MariaDB Volume**: `mariadb_data`
- **Matomo Volume**: `matomo_data`

This ensures that your data will persist even if you stop or restart the containers.

## Troubleshooting

- **Matomo Not Loading**: Ensure that the `matomo_mariadb` container is running and properly linked to the `matomo_app` container.
- **MariaDB Connection Issues**: Check if the MariaDB credentials match those set in the environment variables (`MYSQL_USER`, `MYSQL_PASSWORD`, etc.).
- **Port Conflicts**: If port `8081` is already in use, modify the port in the `-p 8081:80` part of the Matomo run command.


## Contact

If you have any questions or need further assistance, feel free to reach out!

- Author: [SAMPATHKUMAR P](https://github.com/sampath-code04)
- Docker Hub: [sampath987](https://hub.docker.com/u/sampath987)

## Contributing

Feel free to fork this repository, open issues, or create pull requests for any improvements or bug fixes!
