

---

# **n8n Installation with Docker Compose**

This repository contains a setup for deploying `n8n` using Docker Compose, with persistent storage for both `n8n` and PostgreSQL data. It also includes `Qdrant` for vector database functionality.

---

## **Note: Testing Only**

**This setup is intended for testing and development purposes only.** It is not suitable for production use because:

1. **Lack of Security Hardening**:  
   - Basic authentication credentials (`N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`) are stored in plain text in the `.env` file.
   - The default configuration does not use secure certificates (HTTPS).

2. **Limited Scalability**:  
   - This setup uses a single-node architecture and does not include load balancing or redundancy.

3. **No Backup or Monitoring**:  
   - There is no mechanism to back up workflows, logs, or database data regularly.
   - Logging and monitoring for production use are not configured.

4. **Container Persistence**:  
   - Data persistence is limited to local directories (`n8n_data` and `pgdata`), which are not designed for robust, long-term storage in a production environment.

---

## **Prerequisites**

Ensure the following are installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

---

## **Setup Instructions**

You can set up this project using an automated script or by manually cloning and configuring the repository.

---

### **Option 1: Automated Installation**

1. **Run the Installer Script**:
   Use the following command to set up the project automatically:
   ```bash
   wget -qO- https://raw.githubusercontent.com/butdiditwork/n8n-docker/main/install-n8n.sh | bash
   ```

2. **Follow the Prompts**:
   - The script will:
     - Install Git if it's not already installed.
     - Clone this repository into a directory called `n8n-docker`.
     - Create the required `n8n_data` and `pgdata` directories.
     - Set the correct ownership for these directories.
     - Copy the example `.env` file and prompt you to edit it.

3. **Edit the `.env` File**:
   - Configure environment variables in the `.env` file when prompted. Instructions will be provided during the setup process.

4. **Start the Services**:
   - Once the `.env` file is configured, run the following command to start the services:
     ```bash
     docker compose up -d
     ```
   - Access `n8n` at [http://localhost:5678](http://localhost:5678).

---

### **Option 2: Manual Installation**

Follow these steps if you prefer to set up the project manually.

#### **1. Clone the Repository**
```bash
git clone https://github.com/butdiditwork/n8n-docker.git
cd n8n-docker
```

#### **2. Create Volume Mount Directories**
Create directories for persistent storage:
```bash
mkdir n8n_data pgdata
```

#### **3. Set Ownership**
Set the correct ownership for these directories to match the `n8n` container's user:
```bash
chown -R 1000:1000 ./n8n_data ./pgdata
```

#### **4. Configure Environment Variables**
Copy the example `.env` file and edit it:
```bash
cp .env.example .env
nano .env
```
- Configure the following variables in the `.env` file:

**Environment Variables**:
```env
# n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password
N8N_HOST=localhost
N8N_PORT=5678
WEBHOOK_URL=http://localhost:5678
N8N_DIAGNOSTICS_ENABLED=false
N8N_SECURE_COOKIE=false

# PostgreSQL Configuration
POSTGRES_USER=n8n
POSTGRES_PASSWORD=n8n
POSTGRES_DB=n8n

# Qdrant Configuration
QDRANT_PORT=6333
QDRANT_GRPC_PORT=6334
```

#### **5. Start the Services**
Run the following command to start all services:
```bash
docker compose up -d
```
- Access `n8n` at [http://localhost:5678](http://localhost:5678).

---

## **Compose Services Overview**

### **Services**
1. **n8n**:
   - The main service for workflow automation.
   - Persistent data is stored in `n8n_data` under `./n8n_data:/home/node/.n8n`.

2. **PostgreSQL**:
   - Provides a database backend for n8n.
   - Persistent data is stored in `pgdata` under `./pgdata:/var/lib/postgresql/data`.

3. **Qdrant**:
   - A vector database for storing and querying vector embeddings.
   - Configured to expose the following ports:
     - REST API: `${QDRANT_PORT}:6333`
     - gRPC API: `${QDRANT_GRPC_PORT}:6334`

---

## **Usage**

### **Start the Services**
To start the services for the first time:
```bash
docker compose up
```
- Watch the logs to ensure the services initialize properly.
- Access `n8n` at [http://localhost:5678](http://localhost:5678).

### **Restart in Detached Mode**
To restart the services in the background:
```bash
docker compose up -d
```

---

## **Maintenance**

### **Restart Services**
To restart the services:
```bash
docker compose restart
```

### **Stop and Remove Services**
To stop and clean up:
```bash
docker compose down -v
```

---

## **Troubleshooting**

### **Permission Errors**
If you encounter permission issues:
1. Ensure directories exist:
   ```bash
   mkdir -p ./n8n_data ./pgdata
   ```
2. Fix ownership:
   ```bash
   chown -R 1000:1000 ./n8n_data ./pgdata
   ```

### **Check Logs**
To debug issues, view the logs:
```bash
docker compose logs -f
```

---

## **Credits**

- [n8n Documentation](https://docs.n8n.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Qdrant Documentation](https://qdrant.tech/documentation/)

---

