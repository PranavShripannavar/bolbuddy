$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

function Require-Command([string]$name, [string]$package) {
  if (Get-Command $name -ErrorAction SilentlyContinue) { return $true }
  Write-Host "Installing $name..." -ForegroundColor Yellow
  winget install --id $package --exact --accept-package-agreements --accept-source-agreements
  return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Restart-Setup {
  Write-Host "Restarting setup to continue with the newly installed dependency..." -ForegroundColor Cyan
  Start-Process powershell.exe -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $PSCommandPath
  exit
}

Write-Host "BolBuddy one-time offline setup" -ForegroundColor Cyan
if (-not (Require-Command 'node' 'OpenJS.NodeJS.LTS')) {
  Restart-Setup
}
if (-not (Require-Command 'ollama' 'Ollama.Ollama')) {
  Restart-Setup
}
if (-not (Require-Command 'py' 'Python.Python.3.12')) {
  Restart-Setup
}

Write-Host "Downloading the local tutor model (one-time)..." -ForegroundColor Yellow
ollama pull qwen2.5:3b

$runtime = Join-Path $root '.voice-runtime'
Write-Host "Installing local voice runtime (one-time)..." -ForegroundColor Yellow
py -3 -m pip install --target $runtime faster-whisper

Write-Host "Downloading the local Whisper voice model (one-time)..." -ForegroundColor Yellow
$code = "import sys; sys.path.insert(0, r'$runtime'); from faster_whisper import WhisperModel; WhisperModel('base', device='cpu', compute_type='int8', download_root=r'$root\..\..\work\whisper-model')"
py -3 -c $code

Write-Host "Setup complete. Starting BolBuddy..." -ForegroundColor Green
Start-Process cmd.exe -ArgumentList '/c', "`"$root\start-bolbuddy.cmd`""
