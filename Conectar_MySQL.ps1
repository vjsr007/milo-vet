# CONECTAR A MYSQL - Acceso Rapido

# Configurar PATH
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"

Write-Host "`nConectando a la base de datos de la Veterinaria...`n" -ForegroundColor Cyan

# Verificar que MySQL esté corriendo
$mysqlProcess = Get-Process -Name mysqld -ErrorAction SilentlyContinue

if (-not $mysqlProcess) {
    Write-Host "MySQL no esta corriendo." -ForegroundColor Yellow
    Write-Host "Ejecuta primero: " -NoNewline
    Write-Host ".\Iniciar_MySQL.ps1`n" -ForegroundColor Cyan
    pause
    exit
}

# Conectar a MySQL
Write-Host "Iniciando MySQL Command Line Client...`n" -ForegroundColor Green
Write-Host "Consejos rápidos:" -ForegroundColor Yellow
Write-Host "  • Para ver tablas: SHOW TABLES;" -ForegroundColor Gray
Write-Host "  • Para ver dueños: SELECT * FROM duenos;" -ForegroundColor Gray
Write-Host "  • Para salir: exit" -ForegroundColor Gray
Write-Host ""

mysql -u root veterinaria_db
