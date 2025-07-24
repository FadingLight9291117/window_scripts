
## Check-ScoopApps.ps1

这是一个PowerShell脚本 `Check-ScoopApps.ps1`，该脚本具有以下功能：

### 主要功能：

1. 检测Scoop是否已安装
2. 从txt文件或命令行参数读取软件列表
3. 检查软件是否已安装
4. 自动安装未安装的软件

### 使用方法：

1. 从命令行参数指定软件：

```pwsh
.\Check-ScoopApps.ps1 -Apps 'git','nodejs','python'
```

2. 从txt文件读取软件列表：

```pwsh
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt'
```

3. 检测并自动安装未安装的软件：

```pwsh
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt' -Install
```


### 脚本特性：

- 彩色输出：使用不同颜色显示安装状态（绿色=已安装，红色=未安装）
- 错误处理：包含完善的错误处理机制
- 文件解析：支持注释行（以#开头）和空行过滤
- 安装统计：显示详细的检查和安装结果统计
- 批量操作：支持批量检测和安装

### txt文件格式：

我也创建了一个示例文件 apps.txt，格式如下：

- 每行一个软件名
- 支持注释行（以#开头）
- 自动忽略空行

你可以根据需要修改 apps.txt 文件来添加或删除要检测的软件。脚本会自动处理所有的检测和安装逻辑。