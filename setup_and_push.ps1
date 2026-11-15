# Setup and Push Script for GitHub with Submodule & PR System
param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubUsername,

    [Parameter(Mandatory=$false)]
    [string]$MainRepoName = "test-c-app",

    [Parameter(Mandatory=$false)]
    [string]$SubmoduleRepoName = "math_utils"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Pushing Repositories Online (Main & Submodule) to GitHub" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not $GitHubUsername) {
    $GitHubUsername = Read-Host "Enter your GitHub username"
}

if (-not $GitHubUsername) {
    Write-Error "GitHub username is required to configure remotes."
    exit 1
}

# Update CODEOWNERS with the actual username
$codeownersPath = ".github\CODEOWNERS"
if (Test-Path $codeownersPath) {
    (Get-Content $codeownersPath) -replace "@YOUR_GITHUB_USERNAME", "@$GitHubUsername" | Set-Content $codeownersPath
    Write-Host "[✓] Updated .github\CODEOWNERS with @$GitHubUsername" -ForegroundColor Green
}

$submoduleUrl = "https://github.com/$GitHubUsername/$SubmoduleRepoName.git"
$mainRepoUrl = "https://github.com/$GitHubUsername/$MainRepoName.git"

# Update .gitmodules URL
$gitmodulesContent = @"
[submodule "submodules/math_utils"]
	path = submodules/math_utils
	url = $submoduleUrl
"@
Set-Content -Path ".gitmodules" -Value $gitmodulesContent
Write-Host "[✓] Updated .gitmodules with online submodule URL: $submoduleUrl" -ForegroundColor Green

# 1. Push Submodule Repository
Write-Host "`n>>> [1/2] Preparing and Pushing Submodule ($SubmoduleRepoName)..." -ForegroundColor Yellow
Push-Location "submodules\math_utils"
try {
    git branch -M main 2>$null
    $existingRemote = git remote get-url origin 2>$null
    if ($existingRemote) {
        git remote set-url origin $submoduleUrl
    } else {
        git remote add origin $submoduleUrl
    }
    Write-Host "Pushing submodule to $submoduleUrl..." -ForegroundColor Cyan
    git push -u origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Submodule push failed. Please ensure the repository '$SubmoduleRepoName' exists on your GitHub."
    } else {
        Write-Host "[✓] Submodule pushed successfully!" -ForegroundColor Green
    }
} finally {
    Pop-Location
}

# 2. Commit and Push Main Repository
Write-Host "`n>>> [2/2] Preparing and Pushing Main Repository ($MainRepoName)..." -ForegroundColor Yellow
git branch -M main 2>$null
git add .
git commit -m "Initial commit with math_utils submodule, CI workflow, and CODEOWNERS" 2>$null
$existingMainRemote = git remote get-url origin 2>$null
if ($existingMainRemote) {
    git remote set-url origin $mainRepoUrl
} else {
    git remote add origin $mainRepoUrl
}

Write-Host "Pushing main repository to $mainRepoUrl..." -ForegroundColor Cyan
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Main repo push failed. Please ensure the repository '$MainRepoName' exists on your GitHub."
} else {
    Write-Host "[✓] Main repository pushed successfully!" -ForegroundColor Green
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS TO ACTIVATE THE 1-TICK PR SYSTEM ON GITHUB:" -ForegroundColor Yellow
Write-Host "1. Open your repository on GitHub: https://github.com/$GitHubUsername/$MainRepoName"
Write-Host "2. Go to 'Settings' > 'Branches' (or 'Rules' > 'Rulesets')."
Write-Host "3. Add a branch protection rule for 'main':"
Write-Host "   - Check 'Require a pull request before merging'"
Write-Host "   - Set 'Required approvals' to 1 (Only 1 tick/approval needed)"
Write-Host "   - Check 'Require review from Code Owners' (You are the designated owner)"
Write-Host "   - (Optional) Check 'Require status checks to pass' and select 'Build & Verify'"
Write-Host "==========================================================" -ForegroundColor Cyan
