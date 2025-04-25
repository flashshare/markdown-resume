#!/usr/bin/env pwsh

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$srcDir = Join-Path $PSScriptRoot "src"
$files = Get-ChildItem -Path $srcDir -Filter *.md

if ($null -eq $files) {
    Write-Warning "No markdown files found in $srcDir"
    exit 0
}

foreach ($f in $files) {
    $filePath = $f.FullName
    Write-Host "Processing $filePath file..."
    
    Write-Host "Compiling pdf..."
    & "$PSScriptRoot\compile.ps1" -SourceFile $filePath -Format pdf
    if ($LASTEXITCODE -ne 0) {
        Write-Error "PDF compilation failed for $filePath"
        # Optionally exit here or continue with other files
        # exit 1 
    }

    Write-Host "Compiling html..."
    & "$PSScriptRoot\compile.ps1" -SourceFile $filePath -Format html
    if ($LASTEXITCODE -ne 0) {
        Write-Error "HTML compilation failed for $filePath"
        # Optionally exit here or continue with other files
        # exit 1 
    }
    
    Write-Host "DONE processing $filePath!"
}

Write-Host "All files processed." -ForegroundColor Green
