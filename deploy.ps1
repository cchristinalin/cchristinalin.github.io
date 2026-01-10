# deploy.ps1 - Automate local publish to GitHub Pages
# Usage: Open PowerShell in the project root and run: .\deploy.ps1

$repoUrl = 'git@github.com:cchristinalin/cchristinalin.github.io.git'

function ExitWith($msg) { Write-Host $msg -ForegroundColor Red; exit 1 }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { ExitWith 'git not found. Install Git and re-run this script.' }

if (-not (Get-Command git-lfs -ErrorAction SilentlyContinue)) {
  Write-Host 'git-lfs not found. Attempting to run `git lfs install` (may still require installation).' -ForegroundColor Yellow
  git lfs install
}

# Ensure LFS tracks large files
git lfs track "assets/files/*" | Out-Null
if (Test-Path .gitattributes) { Write-Host 'Updated .gitattributes for LFS.' } else { Write-Host 'Created .gitattributes for LFS.' }

# Initialize repo if needed
if (-not (Test-Path .git)) {
  git init
  Write-Host 'Initialized new git repository.'
}

# Add and commit
git add .gitattributes 2>$null
git add -A
try {
  git commit -m "chore: publish site (prepared for GitHub Pages)" -q
  Write-Host 'Committed changes.' -ForegroundColor Green
} catch {
  Write-Host 'No changes to commit or commit failed (this may be fine).' -ForegroundColor Yellow
}

# Set or update remote
$existing = git remote -v | Out-String
if ($existing -notmatch 'origin') {
  git remote add origin $repoUrl
  Write-Host "Added remote origin -> $repoUrl"
} else {
  git remote set-url origin $repoUrl
  Write-Host "Set origin URL -> $repoUrl"
}

# Ensure branch name
git branch -M main

Write-Host 'Pushing to GitHub (you may be prompted for credentials)...' -ForegroundColor Cyan
try {
  git push -u origin main
  Write-Host 'Push succeeded. If the repository exists, GitHub Pages will publish automatically for `cchristinalin.github.io`.' -ForegroundColor Green
} catch {
  Write-Host 'Push failed. If the remote repository does not exist, create it on GitHub and re-run this script.' -ForegroundColor Red
  Write-Host 'Manual remote creation URL: https://github.com/new' -ForegroundColor Yellow
  exit 1
}

Write-Host '`Done.`' -ForegroundColor Green
