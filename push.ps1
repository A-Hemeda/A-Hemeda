# Quick Push to GitHub
# This script pushes all changes to GitHub to activate the workflows

Write-Host "Pushing changes to GitHub..." -ForegroundColor Cyan
Write-Host ""

# Add all changes
git add .

# Commit with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Setup complete - Snake animation and Last Update ready - $timestamp"

# Push to main
git push origin main

Write-Host ""
Write-Host "Done! Your workflows will start running automatically." -ForegroundColor Green
Write-Host ""
Write-Host "Snake animation will update:" -ForegroundColor Yellow
Write-Host "   - Every 4 hours (snake-contribution.yml)" -ForegroundColor Gray
Write-Host "   - On every push to main" -ForegroundColor Gray
Write-Host ""
Write-Host "Auto-commit will update:" -ForegroundColor Yellow
Write-Host "   - Every 10 minutes automatically" -ForegroundColor Gray
Write-Host "   - Check LAST_UPDATED file for timestamp" -ForegroundColor Gray
Write-Host ""
Write-Host "Check your GitHub Actions tab to see workflows running!" -ForegroundColor Cyan
