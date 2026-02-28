# Apache Webserver on Ubuntu

An Apache HTTP Server running on Ubuntu 24.04 LTS inside a Docker container. The container automatically updates all packages to their latest versions on each deployment.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) 20.10+
- [Docker Compose](https://docs.docker.com/compose/install/) v2.0+

## Repository Structure

```
.
├── Dockerfile              # Container image definition
├── docker-compose.yml      # Docker Compose configuration
├── entrypoint.sh           # Startup script (runs apt-get upgrade before Apache)
├── config/
│   └── 000-default.conf    # Apache virtual host configuration
├── html/                   # Web root (mount point for site content)
└── README.md
```

## Quick Start

### Using Docker Compose (recommended)

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository-url>
   cd webserver
   ```

2. Place your website files in the `html/` directory (it will be created on first run).

3. Build and start the container:
   ```bash
   docker compose up -d
   ```

4. The webserver is now accessible at [http://localhost](http://localhost).

### Using Docker directly

Build the image:
```bash
docker build -t apache-webserver .
```

Run the container:
```bash
docker run -d \
  --name apache-webserver \
  -p 80:80 \
  -v $(pwd)/html:/var/www/html \
  apache-webserver
```

## Automatic Updates

Each time the container starts, the entrypoint script runs `apt-get upgrade` before launching Apache. This ensures the container always runs the latest available package versions, including the most recent stable Apache release, without requiring an image rebuild.

> **⚠️ Important:** Running package upgrades at container start introduces non-deterministic behaviour. Updates may include breaking changes or cause longer startup times. This approach is best suited for **non-production** environments. For production deployments, rebuild the image on a schedule, test it, and redeploy a known-good image instead.

To pick up the latest updates, simply restart the container:
```bash
docker compose restart
```

Or redeploy with a fresh container:
```bash
docker compose down && docker compose up -d
```

## Configuration

### Apache Virtual Host

The default virtual host configuration is located in `config/000-default.conf`. It:

- Serves files from `/var/www/html`
- Enables `AllowOverride All` so `.htaccess` files work
- Enables `mod_rewrite`, `mod_headers`, and `mod_ssl`

To customise the configuration, edit `config/000-default.conf` and rebuild the image:
```bash
docker compose up -d --build
```

### Serving Content

Place your HTML, CSS, JavaScript, and other static files in the `html/` directory. They will be served at the root URL (`http://localhost/`).

### Changing the Port

Edit `docker-compose.yml` and update the `ports` mapping:
```yaml
ports:
  - "8080:80"   # Expose on host port 8080 instead of 80
```

## Logs

Apache access and error logs are written inside the container to `/var/log/apache2/`. To view them:
```bash
docker compose logs webserver
```

Or follow live:
```bash
docker compose logs -f webserver
```

## Stopping and Removing the Container

```bash
# Stop
docker compose stop

# Stop and remove containers
docker compose down

# Stop, remove containers, and remove the built image
docker compose down --rmi local
```

## Base Image & Software Versions

| Component | Version |
|-----------|---------|
| Base OS   | Ubuntu 24.04 LTS (Noble Numbat) |
| Web Server | Apache 2.4 (latest stable from Ubuntu repos) |
