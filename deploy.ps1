Clear-Host
Write-Host "? ENGAGING HYBRID OPERATOR DEPLOYMENT PIPELINE" -ForegroundColor Cyan
Write-Host "Evaluating local state vectors before pushing to the global lattice...`n" -ForegroundColor DarkGray

# Step 1: Ensure Node packages are synchronized locally
if (-not (Test-Path "package.json")) {
    Write-Host "[*] Initializing local NPM matrix..." -ForegroundColor Yellow
    npm init -y | Out-Null
    npm install --save-dev hardhat @openzeppelin/contracts @nomicfoundation/hardhat-toolbox | Out-Null
}

# Step 2: Fire local compilation matrix
Write-Host "[+] Compiling Solidity Smart Contracts..." -ForegroundColor Yellow
npx hardhat compile
if ($LASTEXITCODE -ne 0) {
    Write-Error "[!] Compilation failure inside contract silicon layer. Aborting."; exit
}

# Step 3: Run the local automated trace test suite
Write-Host "`n[+] Executing local transaction verification tests..." -ForegroundColor Yellow
npx hardhat test
if ($LASTEXITCODE -ne 0) {
    Write-Error "[!] Validation failure inside the local test grid. Aborting."; exit
}

# Step 4: Synchronize local state with the global cloud swarm
Write-Host "`n[?] Local checks passed. Staging commit and firing git push sequence..." -ForegroundColor Green
git add .
git commit -m "build: deployed and verified hybrid swarm node state" 2>$null
git push

Write-Host "`n? GLOBAL SWARM PIPELINE ENGAGED SUCCESSFULY." -ForegroundColor Cyan
Write-Host "? Check GitHub Actions to monitor the live cloud lattice triggers." -ForegroundColor Yellow
