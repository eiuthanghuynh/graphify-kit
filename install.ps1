<#
.SYNOPSIS
Install graphify-kit global plugins, optional skill overrides, and per-repo templates for Google Antigravity on Windows.

.EXAMPLE
.\install.ps1 -Preview
.\install.ps1
.\install.ps1 -WithSkillOverrides
.\install.ps1 -InitRepo "E:\my-project" -WithPrTemplate
#>
[CmdletBinding()]
param(
    [switch]$Preview,
    [switch]$WithSkillOverrides,
    [string]$InitRepo,
    [switch]$WithPrTemplate
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigRoot = Join-Path $env:USERPROFILE ".gemini\config"
$PluginsDst = Join-Path $ConfigRoot "plugins"
$SkillsDst = Join-Path $ConfigRoot "skills"
$BackupRoot = Join-Path $ConfigRoot "backups"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Copy-WithBackup {
    param([string]$Source, [string]$Destination, [string]$Label)
    if ($Preview) {
        Write-Host "[PREVIEW] Copy $Label -> $Destination"
        return
    }
    if (Test-Path $Destination) {
        New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
        $bak = Join-Path $BackupRoot ("{0}.bak-{1}" -f (Split-Path -Leaf $Destination), $Stamp)
        Copy-Item -Recurse -Force $Destination $bak
        Write-Host "[BACKUP]  $Destination -> $bak"
        Remove-Item -Recurse -Force $Destination
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
    Copy-Item -Recurse -Force $Source $Destination
    Write-Host "[OK]      Installed $Label -> $Destination"
}

foreach ($pluginName in @("graphify-workflow", "engineering-guardrails")) {
    $src = Join-Path $RepoRoot "plugins\$pluginName"
    $dst = Join-Path $PluginsDst $pluginName
    Copy-WithBackup -Source $src -Destination $dst -Label "plugin/$pluginName"
}

if ($WithSkillOverrides) {
    foreach ($skillName in @("subagent-driven-development", "writing-plans")) {
        $src = Join-Path $RepoRoot "skill-overrides\$skillName"
        $dst = Join-Path $SkillsDst $skillName
        Copy-WithBackup -Source $src -Destination $dst -Label "skill/$skillName"
    }
}

if ($InitRepo) {
    $gitExclude = Join-Path $InitRepo ".git\info\exclude"
    if (-not (Test-Path (Join-Path $InitRepo ".git"))) {
        throw "Target is not a git repository (missing .git): $InitRepo"
    }
    $templateLines = Get-Content (Join-Path $RepoRoot "templates\git-info-exclude.txt")
    if ($Preview) {
        Write-Host "[PREVIEW] Append missing exclude rules to $gitExclude"
    } else {
        $existing = if (Test-Path $gitExclude) { Get-Content $gitExclude } else { @() }
        $toAdd = $templateLines | Where-Object { $_ -and ($existing -notcontains $_) }
        if ($toAdd.Count -gt 0) {
            Add-Content -Path $gitExclude -Value $toAdd -Encoding UTF8
            Write-Host "[OK]      Added $($toAdd.Count) rule(s) to $gitExclude"
        } else {
            Write-Host "[OK]      $gitExclude already up to date"
        }
    }

    if ($WithPrTemplate) {
        $prDst = Join-Path $InitRepo ".github\pull_request_template.md"
        if ($Preview) {
            Write-Host "[PREVIEW] Copy PR template -> $prDst"
        } else {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $prDst) | Out-Null
            Copy-Item -Force (Join-Path $RepoRoot "templates\.github\pull_request_template.md") $prDst
            Write-Host "[OK]      Installed PR template -> $prDst"
        }
    }
}

Write-Host "`nDone. Open a new Antigravity conversation (e.g. using Hydrogen/Flash) to verify active rules."
