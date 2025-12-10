@echo off
echo ============================================
echo    LMS Production Deployment Script
echo ============================================
echo.

REM Check if .env file exists
if not exist ".env" (
    echo ERROR: .env file not found!
    echo Please create .env file from .env.example
    exit /b 1
)

echo [1/4] Stopping existing containers...
docker-compose -f docker-compose.prod.yml down

echo.
echo [2/4] Building and starting containers...
docker-compose -f docker-compose.prod.yml up -d --build

echo.
echo [3/4] Waiting for MySQL to be ready...
timeout /t 30 /nobreak > nul

echo.
echo [4/4] Running security cleanup...
docker exec lms-mysql mysql -u root -p%MYSQL_ROOT_PASSWORD% lms_database -e "UPDATE users SET temp_password = NULL WHERE temp_password IS NOT NULL;"

echo.
echo ============================================
echo    Deployment Complete!
echo ============================================
echo.
echo Frontend: http://your-server-ip:3000
echo Backend:  http://your-server-ip:3000/api
echo.
echo Check logs: docker-compose -f docker-compose.prod.yml logs -f
echo.
