# Idle Championship Clicker - 自动升级脚本

## 📖 项目概述

这是一个用于 Unity 游戏 **Idle Champions of the Forgotten Realms** 的自动化辅助工具项目，主要使用 **AutoHotkey v2.0** 编写。项目实现游戏内自动升级、窗口操作和点击测试等脚本功能。

## 🎯 功能特性

- ✅ **自动颜色检测**：识别游戏中的升级按钮颜色（绿色/蓝色）
- ✅ **自动点击升级**：检测到目标颜色后自动点击 5 次
- ✅ **敌人区域扫描**：蛇形移动鼠标扫描涂抹敌人区域
- ✅ **选择按钮检测**：优先点击出现的"选择"按钮
- ✅ **调试可视化**：红色圆圈标记按钮坐标和扫描区域顶点
- ✅ **暂停/退出控制**：支持 Pause 暂停和 ScrollLock 退出

## 📁 项目结构

```
idle-championship-clicker/
├── src/
│   ├── auto-level-up/              # 自动升级脚本目录
│   │   ├── auto-level-up.ahk       # 主脚本入口（简洁，仅初始化和流程控制）
│   │   └── modules/                # 功能模块目录
│   │       ├── config.ahk          # 配置模块（所有可配置参数）
│   │       ├── select-button.ahk   # 点击选择按钮模块
│   │       ├── enemy-scanner.ahk   # 敌人区域扫描模块
│   │       └── main-flow.ahk       # 主流程模块（核心逻辑）
│   ├── lib/                        # 可复用的工具库
│   │   ├── window-util.ahk         # 窗口操作工具
│   │   ├── hotkey-util.ahk         # 快捷键工具
│   │   ├── color-util.ahk          # 颜色匹配工具
│   │   ├── gui-logger.ahk          # 日志窗口工具
│   │   └── coords-debug-util.ahk   # 坐标调试工具
│   └── tests/                      # 测试脚本目录
├── docs/                           # 文档目录
└── README.md                       # 项目说明文档（本文件）
```

## 🏗️ 模块划分

### 1. **配置模块** (`modules/config.ahk`)

**职责**：集中管理所有可配置参数

**配置项**：
- 游戏窗口标题
- 目标颜色数组和容差
- 按钮坐标配置（起始位置、宽度、数量）
- 扫描频率
- 选择按钮图片路径
- 敌人区域扫描配置
- 调试标记配置

**使用示例**：
```autohotkey
#Include "modules/config.ahk"
; 直接使用配置变量，如：GameWindowTitle, TargetColors, ButtonCoords
```

### 2. **点击选择按钮模块** (`modules/select-button.ahk`)

**职责**：检测并点击游戏中的"选择"按钮

**核心函数**：
- `TryClickSelectButton(windowTitle, selectButtonImage, selectImageVariance)`
  - 在整个窗口范围内搜索选择按钮图片
  - 找到后移动鼠标并点击
  - 返回是否成功点击

### 3. **敌人区域扫描模块** (`modules/enemy-scanner.ahk`)

**职责**：蛇形移动鼠标扫描涂抹敌人所在区域

**核心函数**：
- `ScanEnemyArea(windowTitle, startX, startY, endX, endY, lineSpacing, scanStep, mouseSpeed)`
  - 从左上角开始，逐行左右扫描
  - 蛇形路径覆盖整个敌人区域
  - 扫描完成后回到起始位置

### 4. **主流程模块** (`modules/main-flow.ahk`)

**职责**：自动升级的核心逻辑

**核心函数**：
- `CheckButtons(...)` - 主流程函数
  - 尝试点击选择按钮
  - 从后往前遍历按钮坐标
  - 检测颜色并点击匹配的按钮
  - 调用敌人区域扫描

- `InitDebugMarkers(...)` - 初始化调试标记
  - 绘制按钮坐标的红色圆圈
  - 绘制扫描区域顶点的红色圆圈

### 5. **主脚本** (`auto-level-up.ahk`)

**职责**：脚本入口，初始化和流程控制

**特点**：
- 仅 80 余行代码，简洁清晰
- 引入配置和主流程模块
- 初始化快捷键和日志
- 启动定时循环

## 🚀 快速开始

### 前置条件

1. **操作系统**：Windows
2. **AutoHotkey**：v2.0+
3. **游戏**：Idle Champions of the Forgotten Realms

### 安装步骤

1. 安装 AutoHotkey v2.0
   - 下载地址：https://www.autohotkey.com/

2. 克隆或下载项目到本地

3. （可选）安装 VS Code 和 `vscode-autohotkey2-lsp` 插件

### 运行脚本

1. **启动游戏**：确保 Idle Champions 游戏已启动

2. **运行脚本**：
   - 双击 `src/auto-level-up/auto-level-up.ahk`
   - 或右键选择 "Run Script"

3. **控制脚本**：
   - `Pause` - 暂停/恢复脚本
   - `ScrollLock` - 退出脚本
   - `Ctrl+Q` - 退出（调试模式下）

### 配置说明

打开 `src/auto-level-up/modules/config.ahk`，根据实际情况修改：

```autohotkey
; 游戏窗口标题
GameWindowTitle := "Idle Champions"

; 目标颜色（16 进制 RGB 格式）
TargetColors := ["0x5CCB2F", "0x5CABF7"]

; 颜色容差（0-255）
ColorVariance := 20

; 按钮配置
ButtonStartX := 230    ; 起始 X 坐标
ButtonWidth := 173     ; 按钮宽度
ButtonY := 1384        ; 按钮 Y 坐标
ButtonCount := 13      ; 按钮数量

; 扫描频率（毫秒）
ScanInterval := 3000

; 敌人区域扫描配置
EnemyAreaStartX := 1027
EnemyAreaStartY := 461
EnemyAreaEndX := 2462
EnemyAreaEndY := 1000
```

## 🔍 调试功能

### 可视化调试标记

脚本启动时会自动绘制红色圆圈标记：

- **按钮坐标**：13 个红色小圆圈（半径 15 像素）
- **扫描区域顶点**：2 个红色大圆圈（半径 20 像素）

### 关闭调试标记

在 `config.ahk` 中设置：
```autohotkey
EnableDebugMarkers := false
```

### 日志窗口

脚本会打开日志窗口，显示：
- 脚本启动/退出信息
- 按钮点击记录
- 错误信息
- 当前状态

## 🛠️ 开发指南

### 模块开发原则

1. **职责单一**：每个模块只负责一个明确的功能
2. **参数传递**：通过函数参数传递配置，避免全局依赖
3. **函数注释**：所有函数必须有中文注释
4. **可复用性**：模块应可在其他脚本中复用

### 添加工具库

在 `src/lib/` 下创建新的工具库：

```autohotkey
#Requires AutoHotkey v2.0

/**
 * 工具库说明
 */

/**
 * 函数说明
 * @param param1 参数 1
 * @param param2 参数 2
 */
MyFunction(param1, param2) {
    ; 实现
}
```

### 添加功能模块

在 `src/auto-level-up/modules/` 下创建新模块：

```autohotkey
#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"

/**
 * 模块说明
 */

/**
 * 函数说明
 */
MyFeature() {
    ; 实现
}
```

## 📝 常见问题

### Q: 脚本不工作怎么办？

A: 检查以下几点：
1. 确保游戏已启动
2. 检查窗口标题是否正确（`GameWindowTitle`）
3. 查看日志窗口的错误信息
4. 确认 AutoHotkey v2.0 已安装

### Q: 颜色检测不准确？

A: 调整 `ColorVariance` 参数：
- 调大（20-30）：增加容差，更容易匹配
- 调小（5-10）：减少容差，更精确匹配

### Q: 按钮位置不对？

A: 修改按钮配置参数：
- `ButtonStartX`：第一个按钮的 X 坐标
- `ButtonWidth`：按钮之间的间距
- `ButtonY`：按钮的 Y 坐标
- 启用调试标记查看实际位置

### Q: Unity 游戏不响应后台点击？

A: 这是 Unity 引擎的限制。本脚本使用 `MouseMove + Click` 的方式，需要游戏窗口在前台。

## 📚 技术参考

### AutoHotkey v2 资源

- 官方文档：https://www.autohotkey.com/docs/v2/
- 中文教程：https://www.autohotkey.com/docs/v2/Tutorial.htm

### 项目使用的工具库

- **window-util.ahk**：窗口操作（获取位置、激活窗口等）
- **hotkey-util.ahk**：快捷键管理（暂停、退出等）
- **color-util.ahk**：颜色匹配（颜色比较、容差处理）
- **gui-logger.ahk**：日志窗口（显示运行日志）
- **coords-debug-util.ahk**：坐标调试（绘制红色标记）

## 📄 许可证

本项目仅供学习和研究使用。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📧 联系方式

如有问题，请在 GitHub 上提交 Issue。
