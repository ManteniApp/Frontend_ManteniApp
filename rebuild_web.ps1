# Script para limpiar y reconstruir la aplicación Flutter para Web
Write-Host "🧹 Limpiando proyecto..." -ForegroundColor Yellow
flutter clean

Write-Host "📦 Obteniendo dependencias..." -ForegroundColor Yellow
flutter pub get

Write-Host "🏗️ Construyendo para Web..." -ForegroundColor Yellow
flutter build web --release

Write-Host "✅ ¡Listo! Ahora ejecuta: flutter run -d chrome" -ForegroundColor Green
