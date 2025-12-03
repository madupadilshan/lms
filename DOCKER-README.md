# LMS (Learning Management System)

A full-stack Learning Management System built with Spring Boot and React.

## 🚀 Quick Start with Docker

### Prerequisites

- Docker & Docker Compose installed
- Git (optional, for cloning)

### Local Development

```bash
# Clone or navigate to project directory
cd lms-main

# Start all services (MySQL, Backend, Frontend)
docker compose up -d --build

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

Access the application:

- **Frontend**: http://localhost
- **Backend API**: http://localhost:8080/api
- **MySQL**: localhost:3306

### Default Login Credentials

- **Admin**: admin@lms.com / admin123
- **Teacher**: teacher@lms.com / teacher123
- **Student**: student@lms.com / student123

---

## 🌐 Production Deployment (VPS)

### Step 1: Install Docker on VPS

SSH into your VPS and run:

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Install Docker Compose plugin
apt install docker-compose-plugin -y

# Start Docker
systemctl enable docker
systemctl start docker

# Verify installation
docker --version
docker compose version
```

### Step 2: Upload Project Files

**Option A: Using SCP (from local machine)**

```bash
# From your local machine
scp -r /path/to/lms-main root@YOUR_SERVER_IP:/opt/lms/
```

**Option B: Using Git**

```bash
# On the VPS
cd /opt
git clone YOUR_REPO_URL lms
```

### Step 3: Configure Environment Variables

```bash
cd /opt/lms

# Create .env file
cp .env.example .env

# Edit with your passwords
nano .env
```

Example `.env` file:

```env
MYSQL_ROOT_PASSWORD=YourStrongRootPassword123!
MYSQL_USER=lmsuser
MYSQL_PASSWORD=YourStrongDbPassword123!
API_URL=http://YOUR_SERVER_IP/api
```

### Step 4: Deploy with Docker

```bash
cd /opt/lms

# Build and start all containers
docker compose -f docker-compose.prod.yml up -d --build

# Check status
docker compose -f docker-compose.prod.yml ps

# View logs
docker compose -f docker-compose.prod.yml logs -f

# View specific service logs
docker compose -f docker-compose.prod.yml logs -f backend
docker compose -f docker-compose.prod.yml logs -f frontend
docker compose -f docker-compose.prod.yml logs -f mysql
```

### Step 5: Configure Firewall

```bash
# Allow required ports
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS (for future SSL)
ufw enable
```

### Step 6: Access Your Application

Open your browser and navigate to:

```
http://YOUR_SERVER_IP
```

---

## 🔧 Useful Docker Commands

```bash
# Stop all containers
docker compose -f docker-compose.prod.yml down

# Stop and remove volumes (WARNING: deletes database!)
docker compose -f docker-compose.prod.yml down -v

# Rebuild specific service
docker compose -f docker-compose.prod.yml up -d --build backend

# View container logs
docker logs lms-backend
docker logs lms-frontend
docker logs lms-mysql

# Access MySQL container
docker exec -it lms-mysql mysql -u lmsuser -p

# Access backend container shell
docker exec -it lms-backend /bin/sh

# Check container status
docker ps

# Check resource usage
docker stats
```

---

## 🔒 SSL/HTTPS Setup (Optional)

For production, it's recommended to set up SSL using Let's Encrypt:

```bash
# Install certbot
apt install certbot python3-certbot-nginx -y

# Get SSL certificate (replace with your domain)
certbot --nginx -d yourdomain.com
```

---

## 📁 Project Structure

```
lms-main/
├── docker-compose.yml          # Local development
├── docker-compose.prod.yml     # Production deployment
├── database.sql                # Initial database schema
├── .env.example                # Environment variables template
├── deploy.sh                   # Deployment helper script
│
├── lms/                        # Backend (Spring Boot)
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
│
└── my-react-app/               # Frontend (React)
    ├── Dockerfile              # Development
    ├── Dockerfile.prod         # Production
    ├── nginx.conf              # Development nginx config
    ├── nginx.prod.conf         # Production nginx config
    └── src/
```

---

## 🛠️ Technology Stack

### Backend

- Java 17
- Spring Boot 3.3.5
- Spring Security + JWT
- Spring Data JPA
- MySQL 8.0

### Frontend

- React 18.3
- React Router 6
- Bootstrap 5.3
- Material UI 5
- Axios

### Infrastructure

- Docker & Docker Compose
- Nginx (reverse proxy)
- MySQL 8.0

---

## 📝 Troubleshooting

### Container won't start

```bash
# Check logs
docker compose -f docker-compose.prod.yml logs -f

# Rebuild from scratch
docker compose -f docker-compose.prod.yml down -v
docker compose -f docker-compose.prod.yml up -d --build
```

### Database connection issues

```bash
# Check if MySQL is healthy
docker compose -f docker-compose.prod.yml ps

# Wait for MySQL to be ready (it may take 30-60 seconds on first start)
docker compose -f docker-compose.prod.yml logs mysql
```

### Frontend shows "Cannot connect to API"

- Make sure backend is running: `docker logs lms-backend`
- Check nginx config is proxying `/api/` correctly
- Verify `API_URL` in `.env` is correct

### Reset everything

```bash
docker compose -f docker-compose.prod.yml down -v
docker system prune -af
docker compose -f docker-compose.prod.yml up -d --build
```
