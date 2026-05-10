# 1. MASUKIN LINK RAW SCRIPT INI DI SINI BIAR BISA AUTO-ADMIN
$scriptUrl = "LINK_RAW_SCRIPT_PS1_LU_DISINI"

# 2. MASUKIN LINK DIRECT DOWNLOAD ZIP PROGRAM LU (Yang isinya .exe & MSOffice)
$programsUrl = "LINK_ZIP_PROGRAM_LU_DISINI"

# ==========================================
# AUTO-ELEVATE ADMINISTRATOR
# ==========================================
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Meminta akses Administrator otomatis... Klik YES aja vro!" -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm '$scriptUrl' | iex`"" -Verb RunAs
    Exit
}

function Ask-YesNo ($Message) {
    do {
        $response = Read-Host "$Message (Y/N)"
    } until ($response -match "^[yYnN]$")
    return $response -match "^[yY]$"
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   Installation Script" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$installDir = "C:\Program Installer"
$officeDir = "C:\MSOffice"
$programsZip = "$env:TEMP\Program-Installer.zip"

# ==========================================
# 1. DOWNLOAD & EXTRACT ZIP PROGRAM UTAMA
# ==========================================
Write-Host "Downloading Program Bundles... (File gede nih, ngopi dulu vro)" -ForegroundColor Yellow
Invoke-WebRequest -Uri $programsUrl -OutFile $programsZip

Write-Host "Extracting to C:\Program Installer..." -ForegroundColor Yellow
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
Expand-Archive -Path $programsZip -DestinationPath $installDir -Force
Remove-Item -Path $programsZip -Force # Hapus ZIP biar hemat storage

# Cek & Pindahin folder MSOffice ke C:\MSOffice
$extractedOffice = Get-ChildItem -Path $installDir -Filter "MSOffice" -Directory -Recurse | Select-Object -First 1
if ($extractedOffice) {
    if (!(Test-Path $officeDir)) { New-Item -ItemType Directory -Path $officeDir -Force | Out-Null }
    Write-Host "Memindahkan file Office ke C:\MSOffice..." -ForegroundColor Cyan
    Copy-Item -Path "$($extractedOffice.FullName)\*" -Destination $officeDir -Recurse -Force
}

Write-Host ""

# ==========================================
# 2. INSTALL PROGRAM DARI ZIP
# ==========================================

# -- WINRAR --
if (Ask-YesNo "Do you want to install WinRAR?") {
    Write-Host "Membuka Installer WinRAR..." -ForegroundColor Green
    $winrarExe = Get-ChildItem -Path $installDir -Filter "*winrar*.exe" -Recurse | Select-Object -First 1
    if ($winrarExe) { Start-Process -FilePath $winrarExe.FullName -Wait } 
    else { Write-Host "Installer WinRAR nggak ketemu!" -ForegroundColor Red }
}

# -- CHROME --
if (Ask-YesNo "Do you want to install Google Chrome?") {
    Write-Host "Membuka Installer Chrome..." -ForegroundColor Green
    $chromeExe = Get-ChildItem -Path $installDir -Filter "*Chrome*.exe" -Recurse | Select-Object -First 1
    if ($chromeExe) { Start-Process -FilePath $chromeExe.FullName -Wait } 
    else { Write-Host "Installer Chrome nggak ketemu!" -ForegroundColor Red }
}

# -- QUICKSHARE --
if (Ask-YesNo "Do you want to install QuickShare?") {
    Write-Host "Membuka Installer QuickShare..." -ForegroundColor Green
    $qsExe = Get-ChildItem -Path $installDir -Filter "*QuickShare*.exe" -Recurse | Select-Object -First 1
    if ($qsExe) { Start-Process -FilePath $qsExe.FullName -Wait } 
    else { Write-Host "Installer QuickShare nggak ketemu!" -ForegroundColor Red }
}

# -- VS CODE --
if (Ask-YesNo "Do you want to install Visual Studio Code?") {
    Write-Host "Membuka Installer VS Code..." -ForegroundColor Green
    $vscodeExe = Get-ChildItem -Path $installDir -Filter "*VSCode*.exe" -Recurse | Select-Object -First 1
    if ($vscodeExe) { Start-Process -FilePath $vscodeExe.FullName -Wait } 
    else { Write-Host "Installer VS Code nggak ketemu!" -ForegroundColor Red }
}

# -- OBS STUDIO --
if (Ask-YesNo "Do you want to install OBS Studio?") {
    Write-Host "Membuka Installer OBS Studio..." -ForegroundColor Green
    $obsExe = Get-ChildItem -Path $installDir -Filter "*OBS*.exe" -Recurse | Select-Object -First 1
    if ($obsExe) { Start-Process -FilePath $obsExe.FullName -Wait } 
    else { Write-Host "Installer OBS Studio nggak ketemu!" -ForegroundColor Red }
}

# -- PDANET --
if (Ask-YesNo "Do you want to install PdaNet?") {
    Write-Host "Membuka Installer PdaNet..." -ForegroundColor Green
    $pdaExe = Get-ChildItem -Path $installDir -Filter "*PdaNet*.exe" -Recurse | Select-Object -First 1
    if ($pdaExe) { Start-Process -FilePath $pdaExe.FullName -Wait } 
    else { Write-Host "Installer PdaNet nggak ketemu!" -ForegroundColor Red }
}

# -- STEAM --
if (Ask-YesNo "Do you want to install Steam?") {
    Write-Host "Membuka Installer Steam..." -ForegroundColor Green
    $steamExe = Get-ChildItem -Path $installDir -Filter "*Steam*.exe" -Recurse | Select-Object -First 1
    if ($steamExe) { Start-Process -FilePath $steamExe.FullName -Wait } 
    else { Write-Host "Installer Steam nggak ketemu!" -ForegroundColor Red }
}

# -- AMD ADRENALIN (DARI ZIP) --
if (Ask-YesNo "Do you want to install AMD Adrenalin (Dari ZIP)?") {
    Write-Host "Membuka Installer AMD Adrenalin..." -ForegroundColor Green
    $amdZipExe = Get-ChildItem -Path $installDir -Filter "*amd-software*.exe" -Recurse | Select-Object -First 1
    if ($amdZipExe) { Start-Process -FilePath $amdZipExe.FullName -Wait } 
    else { Write-Host "Installer AMD Adrenalin nggak ketemu!" -ForegroundColor Red }
}

Write-Host ""

# ==========================================
# 3. INSTALL MICROSOFT OFFICE
# ==========================================
if (Ask-YesNo "Do you want to install MS Office?") {
    Write-Host "Installing MS Office..." -ForegroundColor Green
    $officeSetup = "$officeDir\setup.exe"
    
    if (Test-Path $officeSetup) {
        Start-Process -FilePath $officeSetup -ArgumentList "/configure Configuration.xml" -WorkingDirectory $officeDir -Wait
    } else {
        Write-Host "File setup.exe nggak ketemu di C:\MSOffice!" -ForegroundColor Red
    }
}

Write-Host ""

# ==========================================
# 4. INSTALL AMD DRIVER TECNO (PALING TERAKHIR)
# ==========================================
if (Ask-YesNo "Do you want to install driver (Khusus Tecno)?") {
    Write-Host "Downloading Driver Tecno dari server... (Sabar vro)" -ForegroundColor Yellow
    $amdUrl = "https://d13pvy8xd75yde.cloudfront.net/global/download/MEGABOOK-K15S-AMD/MEGABOOK%20K15S%20AMD_20251017.zip"
    $amdZip = "$env:TEMP\AMD_Driver.zip"
    $amdExtracted = "$env:TEMP\AMD_Driver_Extracted"
    
    Invoke-WebRequest -Uri $amdUrl -OutFile $amdZip
    Write-Host "Extracting Driver Tecno..." -ForegroundColor Yellow
    if (Test-Path $amdExtracted) { Remove-Item -Path $amdExtracted -Recurse -Force }
    Expand-Archive -Path $amdZip -DestinationPath $amdExtracted -Force
    
    $amdSetup = Get-ChildItem -Path $amdExtracted -Filter "*.exe" -Recurse | Select-Object -First 1
    if ($amdSetup) {
        Write-Host "Membuka Installer Tecno..." -ForegroundColor Green
        Start-Process -FilePath $amdSetup.FullName -WorkingDirectory $amdSetup.DirectoryName -Wait
    } else {
        Write-Host "File installer Tecno nggak ketemu!" -ForegroundColor Red
    }
    
    Remove-Item -Path $amdZip -Force
    Remove-Item -Path $amdExtracted -Recurse -Force
}

Write-Host ""
# ==========================================
# 5. CLEANUP AKHIR
# ==========================================
if (Ask-YesNo "Do you want to delete the installer files in C:\Program Installer?") {
    Remove-Item -Path $installDir -Recurse -Force
    Write-Host "Instalasi selesai dan folder installer telah dibersihkan." -ForegroundColor Green
} else {
    Write-Host "Installer di C:\Program Installer akan disimpan." -ForegroundColor Cyan
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   Installation Complete!" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan