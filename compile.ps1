#!/usr/bin/env pwsh
param(
    [Parameter(Mandatory=$true)][string]$SourceFile,
    [Parameter(Mandatory=$true)][ValidateSet('pdf', 'html')][string]$Format,
    [string]$StyleName = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourceFile -PathType Leaf)) {
    Write-Error "Source file not found: $SourceFile"
    exit 1
}

# Extract style from front matter
$extractedStyle = pandoc -s $SourceFile --template extract_style.txt

if ([string]::IsNullOrWhiteSpace($StyleName)) {
    $Style = $extractedStyle
} else {
    $Style = $StyleName
}

if ([string]::IsNullOrWhiteSpace($Style)) {
    Write-Host "Style not set in markdown front matter or arguments, using default" -ForegroundColor Yellow
    $Style = "default"
}

$styleDir = Join-Path $PSScriptRoot "styles" $Style
if (-not (Test-Path $styleDir -PathType Container)) {
    Write-Host "Style directory '$styleDir' doesn't exist, using default" -ForegroundColor Yellow
    $Style = "default"
    $styleDir = Join-Path $PSScriptRoot "styles" $Style
} else {
    Write-Host "Using '$Style' style"
}

$sourceBase = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
$outputDir = Join-Path $PSScriptRoot "output"

# Ensure output directory exists
if (-not (Test-Path $outputDir -PathType Container)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$outputFile = Join-Path $outputDir "$($sourceBase).$($Format)"

# Get CSS files
$cssFiles = Get-ChildItem -Path $styleDir -Filter *.css | ForEach-Object { "-c $($_.FullName)" }
$cssArgs = $cssFiles -join " "

# Construct Pandoc arguments
$pandocArgs = @(
    "-s",
    "--self-contained",
    $cssArgs.Split(' '),
    "`"$SourceFile`"",
    "-o", "`"$outputFile`""
)

# Add PDF specific options if format is pdf
if ($Format -eq 'pdf') {
    $pandocArgs += "--pdf-engine=wkhtmltopdf"
    $pandocArgs += "--pdf-engine-opt=--enable-local-file-access"
}

Write-Host "Running Pandoc: pandoc $($pandocArgs -join ' ')"

# Execute Pandoc
Invoke-Expression "pandoc $($pandocArgs -join ' ')"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Pandoc execution failed."
    exit $LASTEXITCODE
}

Write-Host "Successfully created $outputFile" -ForegroundColor Green
