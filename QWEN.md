# Idle Championship Clicker

## 项目概述

这是一个用于游戏 **Idle Champions of the Forgotten Realms** 的自动化辅助工具集合，使用 **AutoHotkey v2.0** 编写。

主要功能：
- **自动升级 (Auto Level Up)**：通过检测屏幕颜色变化，自动点击游戏中的升级按钮
- **后台点击测试**：测试不同的窗口点击方式（ControlClick、PostMessage、前台点击）
- **窗口工具库**：封装通用的窗口操作（激活、位置获取、暂停控制等）

## 技术栈

- **AutoHotkey v2.0** - 自动化脚本语言
- **VSCode** - 推荐编辑器（配合 `vscode-autohotkey2-lsp` 插件）

## 项目结构

```
idle-championship-clicker/
├── docs/                          # 文档和资源
│   ├── auto-level-up.md           # 坐标和颜色信息记录
│   └── green-click.png            # 升级按钮截图
├── src/
│   ├── lib/                       # 公共库
│   │   └── window-util.ahk        # 窗口操作工具类
│   ├── script/                    # 主脚本
│   │   └── auto-level-up.ahk      # 自动升级脚本
│   └── tests/                     # 测试脚本
│       ├── click-background-app-test.ahk   # 后台点击测试
│       └── tooltip-test.ahk                # ToolTip 测试
└── QWEN.md                        # 项目上下文（本文件）
```

## 使用方法

### 运行脚本

```bash
# 直接运行 AutoHotkey 脚本
AutoHotkey.exe src\script\auto-level-up.ahk
```

### 快捷键

| 按键 | 功能 |
|------|------|
| `Pause` | 暂停/恢复脚本 |

## 开发约定

- 所有脚本使用 **AutoHotkey v2.0** 语法
- 所有命令使用**函数调用形式**（带括号），例如 `ControlClick(...)`、`ToolTip(...)`
- 使用 `#Requires AutoHotkey v2.0` 声明版本
- 库文件放在 `src/lib/` 目录，通过 `#Include` 引用
- 中文注释

## 注意事项

- **Idle Champions** 是 Unity 引擎游戏 (`ahk_class UnityWndClass`, `ahk_exe IdleDragons.exe`)
- Unity 游戏可能对后台点击 (`ControlClick`) 不响应，需要测试不同点击方式
- 坐标和颜色信息记录在 `docs/auto-level-up.md` 中
- 运行前确保游戏已启动，否则脚本会退出
