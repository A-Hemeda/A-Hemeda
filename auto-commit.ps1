# Auto-Commit Script
# Automatically commits and pushes changes every 180 seconds (3 minutes)

Write-Host "🤖 Auto-Commit Script Started" -ForegroundColor Green
Write-Host "⏰ Will commit every 180 seconds (3 minutes). Press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host ""

# Interval in seconds (180 seconds = 3 minutes)
$interval = 180

while ($true) {
    try {
        # Get current timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        Write-Host "[$timestamp] Checking for changes..." -ForegroundColor Cyan
        
        Write-Host "📝 Committing (even if no changes)..." -ForegroundColor Yellow
        # Add all changes
        git add .
        # Commit with timestamp, allow empty
        git commit --allow-empty -m "Auto-commit: $timestamp"
        # Push to remote
        git push origin main
        Write-Host "✅ Commit (possibly empty) pushed!" -ForegroundColor Green
        Write-Host "⏳ Next check in 180 seconds..." -ForegroundColor Cyan
        Write-Host ""
        
        # Wait for 180 seconds
        Start-Sleep -Seconds $interval
        
    } catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
        Write-Host "Retrying in 180 seconds..." -ForegroundColor Yellow
        Write-Host ""
        Start-Sleep -Seconds $interval
    }
}
