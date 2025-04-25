#!/usr/bin/env pwsh

<#
.SYNOPSIS
Checks if required dependencies (pandoc, wkhtmltopdf) are installed and accessible.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue" # Don't stop script, just check

$dependencies = @(
    @{ Name = "pandoc"; InstallCommand = "choco install pandoc --no-progress -y" },
    @{ Name = "wkhtmltopdf"; InstallCommand = "choco install wkhtmltopdf --no-progress -y" }
)

$missingDeps = @()

Write-Host "Checking dependencies..."

foreach ($dep in $dependencies) {
    Write-Host "Checking for $($dep.Name)..." -NoNewline
    $commandCheck = Get-Command $dep.Name -ErrorAction SilentlyContinue
    if ($null -eq $commandCheck) {
        Write-Host " MISSING" -ForegroundColor Red
        $missingDeps += $dep
    } else {
        Write-Host " OK ($($commandCheck.Source))" -ForegroundColor Green
    }
}

if ($missingDeps.Count -gt 0) {
    Write-Error "Required dependencies are missing!"
    Write-Host "Please install the following using Chocolatey (in an Administrator PowerShell):" -ForegroundColor Yellow
    foreach ($dep in $missingDeps) {
        Write-Host "  $($dep.InstallCommand)" -ForegroundColor Cyan
    }
    Write-Host "See README.md for more details and alternative installation methods." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "All dependencies found." -ForegroundColor Green
    exit 0
}
