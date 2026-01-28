# Auto-Commit Script
# Automatically commits and pushes changes every 10 minutes

Write-Host "🤖 Auto-Commit Script Started" -ForegroundColor Green
Write-Host "⏰ Will commit every 10 minutes. Press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host ""

# Interval in seconds (10 minutes = 600 seconds)
$interval = 600

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
        Write-Host "⏳ Next check in 10 minutes..." -ForegroundColor Cyan
        Write-Host ""
        
        # Wait for 20 minutes
        Start-Sleep -Seconds $interval
        
    } catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
        Write-Host "Retrying in 10 minutes..." -ForegroundColor Yellow
        Write-Host ""
        Start-Sleep -Seconds $interval
    }
}
