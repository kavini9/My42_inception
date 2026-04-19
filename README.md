*This project has been created as part of the 42 curriculum by wweerasi.*

# Inception

## Description
Inception is a system administration project that introduces Docker and containerized microservice architectures. The goal of this project is to broaden knowledge of system administration by virtualizing several Docker images inside a personal virtual machine and orchestrating them with docker compose. 

The infrastructure consists of three distinct containers running on a custom Docker bridge network:
- **NGINX:** A web server handling TLSv1.2/TLSv1.3 secure connections on port 443.
- **WordPress & PHP-FPM:** The core application serving the website.
- **MariaDB:** The SQL database storing the application's persistent data.

The sources included in this repository (`srcs/requirements/`) contain custom Dockerfiles and configuration scripts. Instead of using pre-configured images like DockerHub's official WordPress or MariaDB, everything is built from scratch using Alpine Linux as the base OS to ensure a minimal, secure footprint.

**Main Design Choices:**
- **Strict Isolation:** One service per container (NGINX, WordPress, MariaDB).
- **Dependency Control:** Strict Docker Compose health checks prevent race conditions during startup.
- **Data Persistence:** Permanent data is bound to specific host directories to survive container destruction.

### Architectural Comparisons

| Concept | Option A | Option B | Project Choice & Why |
| :--- | :--- | :--- | :--- |
| **Infrastructure** | **Virtual Machines:** Emulates entire hardware; requires a heavy guest OS; boots slowly. | **Docker:** Shares the host OS kernel; contains only the app and dependencies; boots in milliseconds. | **Docker:** For lightweight, rapid, and modular deployment. |
| **Variables** | **Docker Secrets:** Encrypted, securely mounted files, best for production Swarm clusters. | **Environment Variables:** Passed into the container at runtime via a `.env` file. | **Environment Variables:** Simpler for local development and explicitly requested by the subject. |
| **Networking** | **Docker Network (Bridge):** Creates an isolated internal network where containers resolve each other by name (DNS). | **Host Network:** Removes isolation; containers share the host's exact IP and ports. | **Docker Network:** Ensures services like the database cannot be accessed directly from the outside. |
| **Storage** | **Docker Volumes:** Stored deep in Docker's internal system files; entirely managed by the Docker daemon. | **Bind Mounts:** Explicitly maps a specific folder on the host (e.g., `~/data/`) to the container. | **Bind Mounts:** Enforced by the subject to easily view and manage persistent data locally. |

---

## Instructions
For detailed instructions on how to use and maintain this infrastructure, please refer to the dedicated documentation files included in this repository:
- If you are an **End User or Administrator** looking to run the site, access the dashboard, or perform basic checks, read [USER_DOC.md](./USER_DOC.md).
- If you are a **Developer or Evaluator** looking to understand the architecture, health checks, setup process, and data persistence, read [DEV_DOC.md](./DEV_DOC.md).

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [NGINX Official Documentation](https://nginx.org/en/docs/)
- [Alpine Linux Wiki](https://wiki.alpinelinux.org/)

### AI Usage Explanation
Artificial Intelligence (LLMs) was used as an interactive tutor and pair-programmer during the development of this project. Specifically, AI assisted with:
1. Debug Docker networking timeouts and DNS resolution errors during the MariaDB and WordPress handshake.
2. Formulate and optimize the `sed` commands used in configuration scripts.
3. Understand and implement strict Docker Compose `healthcheck` and `depends_on` rules to prevent race conditions (e.g., ensuring MariaDB is fully initialized before WordPress boots, avoiding NGINX 403 errors).
4. Refactor standard `echo` statements to POSIX-compliant `printf` statements in the Makefile to fix SSH terminal color rendering.