# ============================================================
# 🧩 Avira Antivirus - Silent Downloader & Installer (BITS)
# PowerShell 7 Only
# ============================================================

# ------------------------------------------------------------
# ⚙️ Section : Configuration - Start
# ------------------------------------------------------------
$DownloadUrl   = "https://package.avira.com/package/oeavira/win/int/avira_en_av_ww.exe"
$InstallerName = "AviraSetup.exe"
$TargetDir     = Join-Path $env:TEMP "installer"
$InstallerPath = Join-Path $TargetDir $InstallerName
# ------------------------------------------------------------
# ⚙️ Section : Configuration - End
# ------------------------------------------------------------


# ------------------------------------------------------------
# 📁 Section : Ensure Target Directory - Start
# ------------------------------------------------------------
function Ensure-Directory {
    if (-not (Test-Path -Path $TargetDir)) {
        Write-Host "Creating download directory: $TargetDir" -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    } else {
        Write-Host "Download directory already exists: $TargetDir" -ForegroundColor DarkGray
    }
}
# ------------------------------------------------------------
# 📁 Section : Ensure Target Directory - End
# ------------------------------------------------------------


# ------------------------------------------------------------
# 🚚 Section : Download via BITS - Start
# ------------------------------------------------------------
function Download-InstallerBITS {
    param (
        [string]$Url,
        [string]$OutFile
    )

    try {
        Write-Host "Starting download from: $Url" -ForegroundColor Cyan

        if (Test-Path $OutFile) {
            Remove-Item $OutFile -Force
        }

        Start-BitsTransfer -Source $Url -Destination $OutFile -TransferType Download -ErrorAction Stop

        if (Test-Path $OutFile) {
            Write-Host "✅ Download completed successfully!" -ForegroundColor Green
            return $true
        } else {
            throw "File not found after transfer."
        }
    }
    catch {
        Write-Host "❌ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}
# ------------------------------------------------------------
# 🚚 Section : Download via BITS - End
# ------------------------------------------------------------


# ------------------------------------------------------------
# 🧰 Section : Silent Install - Start
# ------------------------------------------------------------
function Install-Avira {
    param (
        [string]$FilePath
    )

    Write-Host "`nStarting silent installation..." -ForegroundColor Cyan
    try {
        # Silent install parameters
        $Arguments = "/SILENT"

        $process = Start-Process -FilePath $FilePath -ArgumentList $Arguments -Wait -PassThru -ErrorAction Stop
        if ($process.ExitCode -eq 0) {
            Write-Host "✅ Avira installed successfully." -ForegroundColor Green
        } else {
            Write-Host "⚠️  Installer exited with code: $($process.ExitCode)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "❌ Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# ------------------------------------------------------------
# 🧰 Section : Silent Install - End
# ------------------------------------------------------------


# ------------------------------------------------------------
# 🧹 Section : Cleanup Files - Start
# ------------------------------------------------------------
function Cleanup-Installer {
    Write-Host "`nCleaning up temporary files..." -ForegroundColor Cyan
    try {
        if (Test-Path $TargetDir) {
            Remove-Item -Path $TargetDir -Recurse -Force
            Write-Host "🧹 Temporary files removed from: $TargetDir" -ForegroundColor DarkGray
        } else {
            Write-Host "No temporary files found."
        }
    }
    catch {
        Write-Host "⚠️  Cleanup failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
# ------------------------------------------------------------
# 🧹 Section : Cleanup Files - End
# ------------------------------------------------------------


# ------------------------------------------------------------
# 🚀 Section : Main Logic - Start
# ------------------------------------------------------------
Ensure-Directory

if (Download-InstallerBITS -Url $DownloadUrl -OutFile $InstallerPath) {
    Install-Avira -FilePath $InstallerPath
    Cleanup-Installer
    Write-Host "`n✅ All tasks completed successfully." -ForegroundColor Green
} else {
    Write-Host "`n❌ Download failed. Installation skipped." -ForegroundColor Red
}
# ------------------------------------------------------------
# 🚀 Section : Main Logic - End
# ------------------------------------------------------------
