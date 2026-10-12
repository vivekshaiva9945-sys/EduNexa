# Script to push segregated repos to GitHub
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Pushing EduNexa Frontend & Backend Repos" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n1. Pushing EduNexa-Frontend to GitHub..." -ForegroundColor Yellow
cd "c:\Users\VIVEK I H\OneDrive\Desktop\EduNexa-Frontend"
git push origin main

Write-Host "`n2. Pushing Edunexa-Backend to GitHub..." -ForegroundColor Yellow
cd "c:\Users\VIVEK I H\OneDrive\Desktop\EduNexa-Backend"
git push origin main

Write-Host "`n[DONE] Both repositories successfully pushed to GitHub!" -ForegroundColor Green
