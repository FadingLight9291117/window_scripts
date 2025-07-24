param(
    [Parameter(Mandatory = $false)]
    [string[]]$Apps,
    
    [Parameter(Mandatory = $false)]
    [string]$AppListFile,
    
    [Parameter(Mandatory = $false)]
    [switch]$Install
)

# 检查Scoop是否已安装
function Test-ScoopInstalled {
    try {
        $null = Get-Command scoop -ErrorAction Stop
        return $true
    }
    catch {
        Write-Error "Scoop未安装，请先安装Scoop。访问 https://scoop.sh 获取安装说明。"
        return $false
    }
}

# 获取已安装的Scoop应用列表
function Get-InstalledScoopApps {
    try {
        # 使用 Out-String 将输出转换为字符串，然后按行分割
        $scoopOutput = scoop list | Out-String
        $lines = $scoopOutput -split "`r?`n"
        
        $installedApps = $lines | Where-Object { 
            # 跳过标题行、分隔线和空行
            $_ -and 
            $_ -notmatch '^Installed apps:' -and 
            $_ -notmatch '^Name\s+Version' -and 
            $_ -notmatch '^-+\s+-+' -and 
            $_.Trim() -ne ""
        } | ForEach-Object {
            # 提取应用名称（第一列，以空格分割）
            $parts = $_.Trim() -split '\s+', 2
            if ($parts.Length -gt 0 -and $parts[0] -ne "") {
                $parts[0]
            }
        } | Where-Object { $_ }  # 过滤掉空值
        
        return $installedApps
    }
    catch {
        Write-Error "无法获取已安装的Scoop应用列表: $_"
        return @()
    }
}

# 从文件读取应用列表
function Get-AppsFromFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "文件不存在: $FilePath"
        return @()
    }
    
    try {
        $apps = Get-Content $FilePath | Where-Object { 
            $_.Trim() -ne "" -and -not $_.StartsWith("#") 
        } | ForEach-Object { $_.Trim() }
        return $apps
    }
    catch {
        Write-Error "读取文件失败: $_"
        return @()
    }
}

# 检查应用是否已安装
function Test-AppInstalled {
    param(
        [string]$AppName,
        [string[]]$InstalledApps
    )
    
    return $InstalledApps -contains $AppName
}

# 安装应用
function Install-ScoopApp {
    param([string]$AppName)
    
    Write-Host "正在安装 $AppName..." -ForegroundColor Yellow
    try {
        scoop install $AppName
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ $AppName 安装成功" -ForegroundColor Green
            return $true
        } else {
            Write-Host "✗ $AppName 安装失败 (退出代码: $LASTEXITCODE)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "✗ $AppName 安装失败: $_" -ForegroundColor Red
        return $false
    }
}

# 主函数
function Main {
    Write-Host "=== Scoop应用检测和安装工具 ===" -ForegroundColor Cyan
    Write-Host ""
    
    # 检查Scoop是否安装
    if (-not (Test-ScoopInstalled)) {
        exit 1
    }
    
    # 获取要检查的应用列表
    $appsToCheck = @()
    
    if ($Apps) {
        $appsToCheck = $Apps
        Write-Host "从命令行参数读取应用列表: $($Apps -join ', ')" -ForegroundColor Blue
    }
    elseif ($AppListFile) {
        $appsToCheck = Get-AppsFromFile -FilePath $AppListFile
        Write-Host "从文件读取应用列表: $AppListFile" -ForegroundColor Blue
    }
    else {
        Write-Host "请提供应用列表或文件路径。" -ForegroundColor Yellow
        Write-Host "使用方法:" -ForegroundColor Gray
        Write-Host "  .\Check-ScoopApps.ps1 -Apps 'git','nodejs','python'" -ForegroundColor Gray
        Write-Host "  .\Check-ScoopApps.ps1 -AppListFile 'apps.txt'" -ForegroundColor Gray
        Write-Host "  .\Check-ScoopApps.ps1 -AppListFile 'apps.txt' -Install" -ForegroundColor Gray
        exit 1
    }
    
    if ($appsToCheck.Count -eq 0) {
        Write-Host "没有找到要检查的应用。" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host ""
    
    # 获取已安装的应用列表
    Write-Host "正在获取已安装的Scoop应用..." -ForegroundColor Blue
    $installedApps = Get-InstalledScoopApps
    
    if ($installedApps.Count -eq 0) {
        Write-Host "未检测到已安装的Scoop应用。" -ForegroundColor Yellow
    } else {
        Write-Host "已安装的应用数量: $($installedApps.Count)" -ForegroundColor Blue
    }
    
    Write-Host ""
    
    # 检查每个应用的安装状态
    $missingApps = @()
    $installedCount = 0
    
    foreach ($app in $appsToCheck) {
        if (Test-AppInstalled -AppName $app -InstalledApps $installedApps) {
            Write-Host "✓ $app - 已安装" -ForegroundColor Green
            $installedCount++
        } else {
            Write-Host "✗ $app - 未安装" -ForegroundColor Red
            $missingApps += $app
        }
    }
    
    Write-Host ""
    Write-Host "检查结果:" -ForegroundColor Cyan
    Write-Host "  总计应用: $($appsToCheck.Count)" -ForegroundColor Gray
    Write-Host "  已安装: $installedCount" -ForegroundColor Green
    Write-Host "  未安装: $($missingApps.Count)" -ForegroundColor Red
    
    # 如果有未安装的应用
    if ($missingApps.Count -gt 0) {
        Write-Host ""
        Write-Host "未安装的应用: $($missingApps -join ', ')" -ForegroundColor Yellow
        
        if ($Install) {
            Write-Host ""
            Write-Host "开始安装未安装的应用..." -ForegroundColor Cyan
            
            $successCount = 0
            $failedApps = @()
            
            foreach ($app in $missingApps) {
                if (Install-ScoopApp -AppName $app) {
                    $successCount++
                } else {
                    $failedApps += $app
                }
            }
            
            Write-Host ""
            Write-Host "安装结果:" -ForegroundColor Cyan
            Write-Host "  成功安装: $successCount" -ForegroundColor Green
            Write-Host "  安装失败: $($failedApps.Count)" -ForegroundColor Red
            
            if ($failedApps.Count -gt 0) {
                Write-Host "  失败的应用: $($failedApps -join ', ')" -ForegroundColor Red
            }
        } else {
            Write-Host ""
            Write-Host "要自动安装这些应用，请使用 -Install 参数。" -ForegroundColor Yellow
            Write-Host "例如: .\Check-ScoopApps.ps1 -AppListFile 'apps.txt' -Install" -ForegroundColor Gray
        }
    } else {
        Write-Host ""
        Write-Host "所有应用都已安装！" -ForegroundColor Green
    }
}

# 运行主函数
Main
