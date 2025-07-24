
# Windows Scripts

Windows 系统下的实用 PowerShell 脚本集合，主要用于自动化软件管理和系统配置。

## 📁 项目结构

```
window_scripts/
├── Check-ScoopApps.ps1    # Scoop 应用检测和安装脚本
├── apps.txt               # 预配置的软件列表
└── readme.md             # 项目说明文档
```

## 🚀 Check-ScoopApps.ps1

一个功能强大的 PowerShell 脚本，用于批量检测和安装 Scoop 包管理器的应用程序。

### ✨ 主要功能

- 🔍 **智能检测**：自动检测 Scoop 是否已安装
- 📋 **灵活输入**：支持命令行参数和文件两种方式指定软件列表
- ✅ **状态检查**：检查指定软件的安装状态
- 🔄 **自动安装**：可选择自动安装未安装的软件
- 📊 **详细统计**：显示完整的检查和安装结果统计

### 📖 使用方法

#### 1. 通过命令行参数指定软件

```powershell
.\Check-ScoopApps.ps1 -Apps 'git','nodejs','python'
```

#### 2. 从文件读取软件列表

```powershell
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt'
```

#### 3. 检测并自动安装未安装的软件

```powershell
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt' -Install
```

#### 4. 获取帮助信息

```powershell
Get-Help .\Check-ScoopApps.ps1 -Detailed
```

### 🎯 脚本参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `-Apps` | `string[]` | 否 | 要检查的应用程序名称数组 |
| `-AppListFile` | `string` | 否 | 包含应用程序列表的文本文件路径 |
| `-Install` | `switch` | 否 | 自动安装未安装的应用程序 |

### 🌈 脚本特性

- **🎨 彩色输出**：使用不同颜色清晰显示安装状态
  - 🟢 绿色：已安装
  - 🔴 红色：未安装
  - 🟡 黄色：警告信息
  - 🔵 蓝色：处理信息
- **🛡️ 错误处理**：完善的错误处理和用户友好的错误信息
- **📝 文件解析**：智能解析配置文件，支持注释和空行
- **📈 统计报告**：详细的安装状态和结果统计
- **⚡ 批量操作**：支持一键批量检测和安装

### 📄 apps.txt 文件格式

应用列表文件采用简单的文本格式：

```text
# 这是注释行，以 # 开头
git                    # 行尾注释也会被忽略
nodejs
python

# 空行会被自动忽略

# 分类组织（注释形式）
# 开发工具
vim
vscode
```

**格式规则：**
- 每行一个软件包名称
- 支持注释行（以 `#` 开头）
- 自动忽略空行和空白字符
- 不区分大小写

### 📦 预配置软件列表

项目包含一个预配置的 `apps.txt` 文件，涵盖：

- **开发工具**：git, nodejs, python, go, rust 等
- **编辑器**：vim, neovim, vscode 等
- **系统工具**：wget, curl, 7zip, grep 等
- **构建工具**：make, cmake, gcc, llvm 等
- **媒体工具**：ffmpeg, imagemagick 等
- **应用软件**：微信、Notion、Zotero 等

### 🔧 前置条件

确保系统已安装以下组件：

1. **PowerShell 5.1** 或更高版本
2. **Scoop 包管理器**（脚本会自动检测并提示安装）

如果尚未安装 Scoop，请访问 [scoop.sh](https://scoop.sh) 获取安装说明。

### 💡 使用示例

```powershell
# 快速检查常用开发工具
.\Check-ScoopApps.ps1 -Apps 'git','node','python','vscode'

# 使用预配置文件检查所有软件
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt'

# 一键安装所有缺失的软件
.\Check-ScoopApps.ps1 -AppListFile 'apps.txt' -Install
```

### 🐛 故障排除

**常见问题及解决方案：**

1. **Scoop 未安装**
   - 错误：`Scoop未安装，请先安装Scoop`
   - 解决：访问 [scoop.sh](https://scoop.sh) 安装 Scoop

2. **执行策略限制**
   - 错误：`无法加载脚本，因为在此系统上禁止运行脚本`
   - 解决：以管理员身份运行 `Set-ExecutionPolicy RemoteSigned`

3. **文件路径问题**
   - 错误：`文件不存在`
   - 解决：确保使用正确的文件路径，支持相对路径和绝对路径

## 🤝 贡献

欢迎提交问题报告和功能请求！如果你有改进建议或发现了 bug，请：

1. Fork 这个项目
2. 创建你的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 📝 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🔗 相关链接

- [Scoop 官网](https://scoop.sh)
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)
- [Windows Terminal](https://github.com/Microsoft/Terminal)