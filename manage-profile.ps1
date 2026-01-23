# GitHub Profile Helper Script
# This script helps you manage your GitHub profile repository

Write-Host "🚀 GitHub Profile Helper" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

function Show-Menu {
    Write-Host "Choose an action:" -ForegroundColor Yellow
    Write-Host "1. 📤 Push all changes to GitHub"
    Write-Host "2. 🔄 Check workflow status"
    Write-Host "3. 🎯 Trigger all workflows manually"
    Write-Host "4. 📊 View repository status"
    Write-Host "5. 🔍 List all workflows"
    Write-Host "6. ❌ Exit"
    Write-Host ""
}

function Push-Changes {
    Write-Host "📤 Pushing changes to GitHub..." -ForegroundColor Green
    
    git add .
    $commitMessage = Read-Host "Enter commit message (or press Enter for default)"
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        $commitMessage = "Update GitHub profile - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    
    git commit -m $commitMessage
    git push origin main
    
    Write-Host "✅ Changes pushed successfully!" -ForegroundColor Green
}

function Check-WorkflowStatus {
    Write-Host "🔄 Checking workflow status..." -ForegroundColor Green
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        gh run list --limit 10
    } else {
        Write-Host "⚠️  GitHub CLI (gh) is not installed." -ForegroundColor Yellow
        Write-Host "Install it from: https://cli.github.com/" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Or check workflows at: https://github.com/$(git config --get remote.origin.url | Select-String -Pattern '([^/:]+)/([^/]+)\.git' | ForEach-Object { $_.Matches.Groups[1].Value + '/' + $_.Matches.Groups[2].Value })/actions" -ForegroundColor Cyan
    }
}

function Trigger-AllWorkflows {
    Write-Host "🎯 Triggering all workflows..." -ForegroundColor Green
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $workflows = @(
            "Generate snake animation",
            "Generate Snake",
            "Overview",
            "Achievements",
            "Isometric Contributions",
            "StarGazers",
            "WakaTime",
            "Introduction"
        )
        
        foreach ($workflow in $workflows) {
            Write-Host "  ▶️  Triggering: $workflow" -ForegroundColor Cyan
            gh workflow run "$workflow" 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✅ Triggered successfully" -ForegroundColor Green
            }
        }
        
        Write-Host ""
        Write-Host "✅ All workflows triggered! Check status in a few moments." -ForegroundColor Green
    } else {
        Write-Host "⚠️  GitHub CLI (gh) is not installed." -ForegroundColor Yellow
        Write-Host "Install it from: https://cli.github.com/" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Alternative: Manually trigger workflows from GitHub Actions tab" -ForegroundColor Cyan
    }
}

function Show-RepoStatus {
    Write-Host "📊 Repository Status:" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "📁 Git Status:" -ForegroundColor Cyan
    git status --short
    Write-Host ""
    
    Write-Host "🌿 Current Branch:" -ForegroundColor Cyan
    git branch --show-current
    Write-Host ""
    
    Write-Host "📝 Recent Commits:" -ForegroundColor Cyan
    git log --oneline -5
    Write-Host ""
    
    Write-Host "📂 Workflow Files:" -ForegroundColor Cyan
    Get-ChildItem ".github\workflows\*.yml" | ForEach-Object { Write-Host "  ✓ $($_.Name)" -ForegroundColor Green }
    Write-Host ""
    
    Write-Host "🎨 Asset Files:" -ForegroundColor Cyan
    if (Test-Path "assets") {
        Get-ChildItem "assets\*.svg" | ForEach-Object { Write-Host "  ✓ $($_.Name)" -ForegroundColor Green }
    }
    Write-Host ""
    
    Write-Host "🐍 Snake Animation Files:" -ForegroundColor Cyan
    if (Test-Path "dist") {
        Get-ChildItem "dist\*.svg", "dist\*.gif" -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  ✓ $($_.Name)" -ForegroundColor Green }
    }
}

function List-Workflows {
    Write-Host "🔍 Available Workflows:" -ForegroundColor Green
    Write-Host ""
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        gh workflow list
    } else {
        Write-Host "Workflow files in .github/workflows/:" -ForegroundColor Cyan
        Get-ChildItem ".github\workflows\*.yml" | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            if ($content -match 'name:\s*(.+)') {
                Write-Host "  ✓ $($matches[1].Trim())" -ForegroundColor Green
                Write-Host "    File: $($_.Name)" -ForegroundColor Gray
            }
        }
    }
}

# Main loop
do {
    Write-Host ""
    Show-Menu
    $choice = Read-Host "Enter your choice (1-6)"
    Write-Host ""
    
    switch ($choice) {
        "1" { Push-Changes }
        "2" { Check-WorkflowStatus }
        "3" { Trigger-AllWorkflows }
        "4" { Show-RepoStatus }
        "5" { List-Workflows }
        "6" { 
            Write-Host "👋 Goodbye!" -ForegroundColor Cyan
            break 
        }
        default { Write-Host "❌ Invalid choice. Please try again." -ForegroundColor Red }
    }
    
    if ($choice -ne "6") {
        Write-Host ""
        Read-Host "Press Enter to continue..."
        Clear-Host
        Write-Host "🚀 GitHub Profile Helper" -ForegroundColor Cyan
        Write-Host "=========================" -ForegroundColor Cyan
    }
    
} while ($choice -ne "6")
