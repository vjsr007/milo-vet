# INICIAR MySQL - Script Automatico

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   SISTEMA VETERINARIA - MySQL" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Agregar MySQL al PATH
Write-Host "1. Configurando PATH de MySQL..." -ForegroundColor Yellow
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.4\bin"
Write-Host "   ✅ PATH configurado`n" -ForegroundColor Green

# 2. Verificar si MySQL ya está corriendo
Write-Host "2. Verificando estado de MySQL..." -ForegroundColor Yellow
$mysqlProcess = Get-Process -Name mysqld -ErrorAction SilentlyContinue

if ($mysqlProcess) {
    Write-Host "   ✅ MySQL ya está corriendo (PID: $($mysqlProcess.Id))`n" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  MySQL no está corriendo. Iniciando...`n" -ForegroundColor Yellow
    
    # Iniciar MySQL
    Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" `
        -ArgumentList "--datadir=`"C:\ProgramData\MySQL\MySQL Server 8.4\data`"" `
        -WindowStyle Hidden
    
    # Esperar 5 segundos para que arranque
    Write-Host "   Esperando que MySQL inicie..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    # Verificar que arrancó
    $mysqlProcess = Get-Process -Name mysqld -ErrorAction SilentlyContinue
    if ($mysqlProcess) {
        Write-Host "   ✅ MySQL iniciado correctamente`n" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Error al iniciar MySQL`n" -ForegroundColor Red
        Write-Host "   Intenta ejecutar PowerShell como Administrador`n" -ForegroundColor Yellow
        pause
        exit
    }
}

# 3. Verificar conexión
Write-Host "3. Probando conexión a MySQL..." -ForegroundColor Yellow
try {
    $result = mysql -u root -e "SELECT 'OK' AS estado;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Conexión exitosa`n" -ForegroundColor Green
    } else {
        throw "Error de conexión"
    }
} catch {
    Write-Host "   ❌ No se pudo conectar a MySQL`n" -ForegroundColor Red
    pause
    exit
}

# 4. Verificar base de datos veterinaria
Write-Host "4. Verificando base de datos..." -ForegroundColor Yellow
$dbCheck = mysql -u root -e "SHOW DATABASES LIKE 'veterinaria_db';" 2>&1
if ($dbCheck -like "*veterinaria_db*") {
    Write-Host "   ✅ Base de datos 'veterinaria_db' encontrada`n" -ForegroundColor Green
    
    # Mostrar resumen de datos
    Write-Host "5. Resumen de datos:" -ForegroundColor Yellow
    mysql -u root veterinaria_db -e "SELECT 'Duenos' AS tabla, COUNT(*) AS registros FROM duenos UNION ALL SELECT 'Mascotas', COUNT(*) FROM mascotas UNION ALL SELECT 'Servicios', COUNT(*) FROM servicios UNION ALL SELECT 'Historial', COUNT(*) FROM historial_servicios UNION ALL SELECT 'Productos', COUNT(*) FROM productos UNION ALL SELECT 'Ventas', COUNT(*) FROM ventas;"
} else {
    Write-Host "   ⚠️  Base de datos no encontrada. ¿Deseas crearla? (S/N): " -ForegroundColor Yellow -NoNewline
    $respuesta = Read-Host
    
    if ($respuesta -eq "S" -or $respuesta -eq "s") {
        Write-Host "`n   Creando base de datos..." -ForegroundColor Yellow
        Get-Content "$PSScriptRoot\setup_simple.sql" -Raw | mysql -u root
        Write-Host "   ✅ Base de datos creada con éxito`n" -ForegroundColor Green
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   SISTEMA LISTO PARA USAR" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "OPCIONES DISPONIBLES:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Abrir MySQL Command Line" -ForegroundColor White
Write-Host "     Escribe: " -NoNewline; Write-Host "mysql -u root veterinaria_db" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Ver todos los dueños" -ForegroundColor White
Write-Host "     Escribe: " -NoNewline; Write-Host "mysql -u root veterinaria_db -e 'SELECT * FROM duenos;'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. Ver todas las mascotas" -ForegroundColor White
Write-Host "     Escribe: " -NoNewline; Write-Host "mysql -u root veterinaria_db -e 'SELECT * FROM mascotas;'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  4. Abrir guía de comandos" -ForegroundColor White
Write-Host "     Escribe: " -NoNewline; Write-Host "notepad COMANDOS_TERMINAL.md" -ForegroundColor Cyan
Write-Host ""

Write-Host "`nTIP: Deja esta ventana abierta mientras uses MySQL" -ForegroundColor Yellow
Write-Host "Para cerrar MySQL, cierra esta ventana o presiona Ctrl+C`n" -ForegroundColor Yellow

# Mantener la ventana abierta
Write-Host "Presiona Enter para continuar trabajando o cierra esta ventana..." -ForegroundColor Gray
Read-Host
