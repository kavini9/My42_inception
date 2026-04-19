# Developer & Evaluation Documentation

This guide outlines the technical setup, architecture, and commands required to develop, build, and evaluate the Inception project.

## 1. Setting Up the Environment from Scratch

**Prerequisites:**
Ensure your host machine (or Virtual Machine) has the following installed:
- Docker Engine
- Docker Compose
- `make` utility

**Host Resolution:**
Your machine must route the target domain to localhost. Edit your `/etc/hosts` file (requires `sudo`) and add:
```text
127.0.0.1 wweerasi.42.fr
```

**Configuration & Secrets:**
1. Locate the `.env.example` file in the root directory.
2. Create a `.env` file inside the `srcs/` directory: `cp .env.example srcs/.env`
3. Edit `srcs/.env` to configure your specific database passwords, users, and domain name.

**Transferring files to the VM (Optional):**
If you need to copy the project from your local machine to your VM:
```bash
scp -P <SSH_PORT> -r /path/to/local/Inception wweerasi@localhost:~/
```

## 2. Building and Launching the Project

The project workflow is fully automated via the `Makefile` located at the repository root.

- **`make`** (or `make all`): Creates the host data directories, builds the Docker images, and starts the containers in detached mode.
- **`make up`**: Starts the infrastructure without forcing a full rebuild (useful for warm boots).
- **`make down`**: Gracefully stops the containers and removes the network. **Data is preserved.**
- **`make clean`**: Stops containers and removes them alongside their Docker cache.
- **`make fclean`**: The nuclear option. Safely stops everything, runs a full Docker system prune, and forcefully deletes the permanent data folders on the host disk.
- **`make re`**: Runs `fclean` followed by `all`.

*To launch manually without make:*
```bash
cd srcs
docker compose up --build -d
```

## 3. Data Persistence
To comply with strict microservice requirements, data persistence is handled via local bind mounts, not internal Docker volumes. 

- **MariaDB Data:** Bound to `/home/wweerasi/data/mariadb/`. This ensures database tables and users survive container destruction.
- **WordPress Data:** Bound to `/home/wweerasi/data/wordpress/`. This allows NGINX to read the generated PHP/HTML files and persists `wp-config.php`.

## 4. Management & Evaluation Commands

Use the following commands to manage the infrastructure or verify requirements during the evaluation.

### General & Cleanup
**Nuclear Docker Cleanup (Manual):**
```bash
docker stop $(docker ps -qa); docker rm $(docker ps -qa)
docker rmi -f $(docker images -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q) 2>/dev/null
```
**Verify PID 1 Compliance (PID 1 cannot be bash, sh, or sleep):**
```bash
docker exec -it nginx ps aux
```

### Network & Volumes
**Inspect Network and Volumes:**
```bash
docker network inspect inception
docker volume ls
docker volume inspect mariadb
```

### MariaDB Verification
**Access Database Internals:**
```bash
docker exec -it mariadb sh
mariadb -u root -p
```
**Check Tables and Privileges (Run inside MariaDB shell):**
```sql
SHOW DATABASES;
SELECT User, Host FROM mysql.user;
SHOW GRANTS FOR wpuser;
USE wordpress;
SHOW TABLES;
SELECT * FROM wp_users;
```

### WordPress & PHP-FPM Verification
**Check PHP-FPM Process:**
```bash
docker exec -it wordpress ps aux | grep php-fpm
```
**Test Database Connection from WordPress Container:**
```bash
docker exec -it wordpress sh
mariadb -h mariadb -u wpuser -p
```

### NGINX & Security Verification
**Verify Internal Port Binding:**
```bash
docker exec -it nginx netstat -tlnp
```
**Verify Host Port Mapping (If "HostPort: 443" is missing, it fails):**
```bash
docker inspect nginx | grep "443"
```
**Test HTTP vs HTTPS routing (Run from the host terminal):**
```bash
curl -k [http://wweerasi.42.fr](http://wweerasi.42.fr)     # Should fail or be rejected
curl -k [https://wweerasi.42.fr](https://wweerasi.42.fr)    # Should display the HTML document
```
**Check TLS/SSL Certificate details:**
```bash
docker exec -it nginx sh
openssl s_client -connect wweerasi.42.fr:443
```