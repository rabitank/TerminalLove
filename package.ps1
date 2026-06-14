param(
    [Parameter(Mandatory)]
    [string]$Version,

    [string]$EngineVersion = "latest",
    [string]$Suffix = ""
)

$ErrorActionPreference = "Stop"

$PackageName = "TerminalLove-v${Version}${Suffix}"
$Staging = "staging/${PackageName}"

if ($EngineVersion -eq "latest") {
    Write-Host "==> Querying latest TermAVG release..."
    $apiHeaders = @{ "Accept" = "application/vnd.github+json"; "User-Agent" = "PowerShell" }
    try {
        $release = Invoke-RestMethod -Uri "https://api.github.com/repos/rabitank/TermAVG/releases/latest" -Headers $apiHeaders
        $EngineVersion = $release.tag_name
        Write-Host "==> TermAVG latest: ${EngineVersion}"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Error "No published TermAVG release found. Publish an engine release first: https://github.com/rabitank/TermAVG/releases"
        } else {
            Write-Error "Failed to query TermAVG releases: $_"
        }
        exit 1
    }
}
$EngineVer = $EngineVersion -replace '^v', ''
$BaseUrl = "https://github.com/rabitank/TermAVG/releases/download/${EngineVersion}"

$tmp = "engine_dl"
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "$tmp/tmj","$tmp/wgpu" | Out-Null

Write-Host "==> Downloading engine binaries (${EngineVersion})..."
try {
    Invoke-WebRequest -Uri "${BaseUrl}/tmj-x86_64-pc-windows-msvc-v${EngineVer}.zip" -OutFile "$tmp/tmj.zip"
    Invoke-WebRequest -Uri "${BaseUrl}/tmj-wgpu-x86_64-pc-windows-msvc-v${EngineVer}.zip" -OutFile "$tmp/wgpu.zip"
} catch {
    Write-Error "Download failed: $_. Ensure the engine release is published and assets are available."
    exit 1
}

Write-Host "==> Extracting..."
Expand-Archive -LiteralPath "$tmp/tmj.zip" -DestinationPath "$tmp/tmj" -Force
Expand-Archive -LiteralPath "$tmp/wgpu.zip" -DestinationPath "$tmp/wgpu" -Force

Copy-Item "$tmp/tmj/tmj_terminal.exe" "tmj.exe"
Copy-Item "$tmp/wgpu/tmj_wgpu.exe" "tmj_gui.exe"
Copy-Item "$tmp/tmj/LICENSE" "engine_license.txt"
Remove-Item -Recurse -Force $tmp

Write-Host "==> Assembling ${PackageName}..."
Remove-Item -Recurse -Force staging -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $Staging | Out-Null
New-Item -ItemType Directory -Force -Path "$Staging/save" | Out-Null

Copy-Item "tmj.exe" $Staging
Copy-Item "tmj_gui.exe" $Staging

Copy-Item "setting.toml" $Staging
Copy-Item "layout.toml" $Staging
Copy-Item "game_setting.toml" $Staging

Copy-Item "README.md" $Staging
Copy-Item "engine_license.txt" "$Staging/LICENSE"

Copy-Item -Recurse "resource" "$Staging/resource"

Get-ChildItem -Recurse "$Staging/resource" -Include "*.kra","*.kra~","*.aseprite" | Remove-Item -Force
Remove-Item -Recurse -Force "$Staging/resource/fc_old","$Staging/resource/bxy_old","$Staging/resource/fc_1" -ErrorAction SilentlyContinue
Remove-Item -Force "$Staging/resource/delete.fs","$Staging/resource/title_store.txt","$Staging/resource/需求说明.pdf","$Staging/resource/需求说明.zip","$Staging/resource/悬浮图片资源需求.md" -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Force -Path target/artifacts | Out-Null
Compress-Archive -Path "$Staging/*" -DestinationPath "target/artifacts/${PackageName}.zip" -Force

Remove-Item -Recurse -Force staging
Remove-Item -Force "tmj.exe","tmj_gui.exe","engine_license.txt" -ErrorAction SilentlyContinue

Write-Host "==> Built target/artifacts/${PackageName}.zip"
