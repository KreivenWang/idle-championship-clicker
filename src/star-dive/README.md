# Star Dive 自动脚本

## 项目概述

Star Dive 是 Idle Championship Clicker 项目的衍生产物，用于自动化游戏内的星界潜水（Star Dive）功能。该项目与 `auto-level-up` 项目无关，仅共用 `src/lib/` 目录下的工具库。

## 功能说明

1. **保持导航状态开启**：检测导航按钮状态，如果为关闭则按 R 键切换
2. **自动触发交互**：检测 F 按钮出现时自动按 F 键交互
3. **所有坐标和范围可配置**：通过配置模块统一管理

## 文件结构

```
src/star-dive/
├── auto-start-dive.ahk          # 主程序入口
├── modules/
│   ├── config.ahk               # 配置模块（坐标、范围、图片路径）
│   ├── navigation.ahk           # 导航状态保持模块
│   └── interact.ahk             # 自动交互模块
└── docs/
    ├── plan.txt                 # 需求文档
    ├── navigation-on.png        # 导航开启状态图片
    ├── navigation-off.png       # 导航关闭状态图片
    └── interact-f.png           # F 按钮交互图片
```

## 代码流程

### 启动流程

```
auto-start-dive.ahk 启动
    │
    ├─ 1. DPI 适配（DllCall SetProcessDPIAware）
    │
    ├─ 2. 初始化快捷键
    │     ├─ Pause 键：暂停/恢复脚本
    │     └─ ScrollLock：退出脚本
    │
    ├─ 3. 初始化日志窗口（GuiLogger）
    │
    └─ 4. 启动定时器（SetTimer）
          └─ 每 ScanInterval 毫秒执行一次 MainLoopWrapper()
```

### 主循环流程（MainLoopWrapper）

```
MainLoopWrapper() 每次触发
    │
    ├─ 1. 检查暂停状态
    │     └─ 如果暂停，直接返回
    │
    ├─ 2. 检查游戏窗口
    │     ├─ 窗口不存在 → 记录日志，返回
    │     └─ 窗口存在 → 确保窗口激活
    │
    ├─ 3. 计算搜索区域
    │     ├─ 导航按钮区域：(2436,1148) 周围 100 像素
    │     └─ F 按钮区域：(1508,811) 周围 50 像素
    │
    ├─ 4. 保持导航状态开启
    │     ├─ 搜索 navigation-on.png
    │     │     ├─ 找到 → 已是开启状态，不做操作
    │     │     └─ 未找到 → 继续
    │     │
    │     └─ 搜索 navigation-off.png
    │           ├─ 找到 → 按 R 键切换
    │           └─ 未找到 → 记录日志
    │
    └─ 5. 自动触发交互
          └─ 搜索 interact-f.png
                ├─ 找到 → 按 F 键交互
                └─ 未找到 → 无操作
```

## 模块职责

| 模块 | 文件 | 职责 |
|------|------|------|
| 配置 | `modules/config.ahk` | 所有坐标、范围、图片路径、容差等可配置参数 |
| 导航 | `modules/navigation.ahk` | 检测导航按钮状态，off 时按 R 切换 |
| 交互 | `modules/interact.ahk` | 检测 F 按钮，出现时按 F 交互 |
| 主程序 | `auto-start-dive.ahk` | 初始化、定时器调度、调用各模块 |

## 配置说明

### 关键配置项（`modules/config.ahk`）

```autohotkey
; 导航按钮配置
NavigationButtonCenterX := 2436        ; 中心 X 坐标
NavigationButtonCenterY := 1148        ; 中心 Y 坐标
NavigationButtonRadius := 100          ; 搜索半径（像素）
NavigationImageVariance := 50          ; 图像搜索容差

; F 按钮配置
InteractButtonCenterX := 1508          ; 中心 X 坐标
InteractButtonCenterY := 811           ; 中心 Y 坐标
InteractButtonRadius := 50             ; 搜索半径（像素）
InteractImageVariance := 50            ; 图像搜索容差

; 扫描频率
ScanInterval := 1000                   ; 检测间隔（毫秒）
```

### 修改坐标

如需调整检测位置，只需修改 `config.ahk` 中的对应参数：

1. 修改中心坐标 `*CenterX` / `*CenterY`
2. 修改搜索半径 `*Radius`
3. 如图像识别不准确，可调整容差 `*Variance`

## 快捷键

| 按键 | 功能 |
|------|------|
| Pause | 暂停/恢复脚本 |
| ScrollLock | 退出脚本 |

## 依赖

- AutoHotkey v2.0+
- 共用库：`src/lib/window-util.ahk`、`src/lib/hotkey-util.ahk`、`src/lib/gui-logger.ahk`

## 运行方式

直接双击运行 `auto-start-dive.ahk` 即可。
