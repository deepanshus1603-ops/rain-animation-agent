param(
    [string]$ProjectRoot = (Join-Path $env:USERPROFILE "Desktop\blender\project4"),
    [string]$MasterBlend = ""
)

$ErrorActionPreference = "Stop"

$RepoRoot = Join-Path $ProjectRoot "rain-animation-agent"

if ([string]::IsNullOrWhiteSpace($MasterBlend)) {
    $MasterBlend = Join-Path $ProjectRoot "project4_rain_wave_working.blend"
}

Write-Host ""
Write-Host "=============================================="
Write-Host "RAIN AGENT - LOCAL SETUP"
Write-Host "=============================================="
Write-Host "Project root : $ProjectRoot"
Write-Host "Repo root    : $RepoRoot"
Write-Host "Master blend : $MasterBlend"
Write-Host ""

if (-not (Test-Path $RepoRoot)) {
    throw "Repository folder not found: $RepoRoot"
}

$TrackedDirs = @(
    "blender_tools",
    "knowledge",
    "prompts"
)

$RuntimeDirs = @(
    "workspace",
    "workspace\checkpoints",
    "workspace\previews",
    "workspace\reports"
)

foreach ($rel in $TrackedDirs + $RuntimeDirs) {
    $path = Join-Path $RepoRoot $rel
    New-Item -ItemType Directory -Path $path -Force | Out-Null
}

foreach ($rel in $TrackedDirs) {
    $keep = Join-Path (Join-Path $RepoRoot $rel) ".gitkeep"
    if (-not (Test-Path $keep)) {
        New-Item -ItemType File -Path $keep -Force | Out-Null
    }
}

$AgentBlend = Join-Path $RepoRoot "workspace\agent_working.blend"

if (-not (Test-Path $AgentBlend)) {
    if (Test-Path $MasterBlend) {
        Copy-Item $MasterBlend $AgentBlend -Force
        Write-Host "Created agent working copy:"
        Write-Host "  $AgentBlend"
    }
    else {
        Write-Warning "Master Blender file was not found."
        Write-Warning "Expected: $MasterBlend"
        Write-Warning "Folders were created, but agent_working.blend was not copied."
    }
}
else {
    Write-Host "Existing agent_working.blend preserved."
}

Write-Host ""
Write-Host "Local folder structure is ready."
Write-Host "The MASTER .blend was not modified."
Write-Host "=============================================="
