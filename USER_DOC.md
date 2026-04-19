# User Documentation

This guide provides simple instructions for end-users and administrators to understand and operate the Inception infrastructure.

## 1. Services Provided by the Stack
This project runs a fully containerized web infrastructure consisting of three main services:
- **NGINX:** A secure web server that handles incoming HTTPS traffic.
- **WordPress:** The core content management system (CMS) used to build and serve the website.
- **MariaDB:** The database backend that securely stores all website data, user accounts, and settings.

## 2. Starting and Stopping the Project
The infrastructure is controlled using simple Makefile commands from the root directory of the project.

- **To start the project:**
  ```bash
  make up
  ```
  *(Note: If running for the first time, simply typing `make` will build the necessary images and start the containers.)*

- **To safely stop the project (preserving all data):**
  ```bash
  make down
  ```

## 3. Accessing the Website and Administration Panel
Once the containers are running and healthy, you can access the application through your web browser. 

*(Note: Because the site uses a self-signed local SSL certificate, your browser may show a security warning. You will need to click "Advanced" and proceed to the site).*

- **Main Website:** [https://wweerasi.42.fr](https://wweerasi.42.fr)
- **Administration Panel:** [https://wweerasi.42.fr/wp-admin](https://wweerasi.42.fr/wp-admin)

**To set up or manage your credentials:**
1. Locate the **`.env.example`** file at the root of the repository. This template contains all the required variable names.
2. Create a new file named **`.env`** inside the `srcs/` directory.
3. Copy the entire contents of `.env.example` into your new `srcs/.env` file.
4. Open the new `srcs/.env` file with a text editor and change the dummy details to your actual database passwords (`MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`) and WordPress accounts (`WP_ADMIN`, `WP_USER`).
5. **Important:** If the database has already been created, updating the `.env` file will not change the passwords inside the live database. You must perform a full wipe (`make fclean`) and restart (`make`) to apply new credentials.

## 5. Checking that Services are Running Correctly
If you need to verify the health of the system or troubleshoot issues, use the following commands:

## 5. Checking that Services are Running Correctly
If you need to verify the health of the system or troubleshoot issues, use the following commands:

**Check Container Status:**
```bash
docker ps
```
*Look under the `STATUS` column. You should see `Up (healthy)` for all containers. If a container says `(health: starting)`, wait a few moments for it to finish booting.*

**View Live Application Logs:**
```bash
docker compose -f srcs/docker-compose.yml logs -f <service_name>
```
*(Replace `<service_name>` with `nginx`, `wordpress`, or `mariadb`. Press `Ctrl+C` to exit the logs).*