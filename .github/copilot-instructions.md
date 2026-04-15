# Idle Championship Clicker Copilot 指令

## 项目目标

这是一个用于 Unity 游戏 **Idle Champions of the Forgotten Realms** 的自动化辅助工具仓库，主要用 **AutoHotkey v2.0** 编写。项目目标是实现游戏内自动升级、窗口操作和点击测试等脚本，并保持代码易于维护。

## 关键文件

- `src/script/auto-level-up.ahk`：主自动升级脚本
- `src/lib/window-util.ahk`：窗口操作与通用辅助函数
- `src/tests/click-background-app-test.ahk`：后台点击测试脚本
- `src/tests/tooltip-test.ahk`：ToolTip 测试脚本
- `docs/auto-level-up.md`：升级按钮坐标与颜色记录

## 技术与约定

- 使用 `#Requires AutoHotkey v2.0`
- 所有 AutoHotkey 命令都采用函数调用形式，如 `ControlClick(...)`、`ToolTip(...)`
- 注释和说明以中文为主
- 通过 `#Include` 引用 `src/lib/` 目录下的库文件

## 业务背景

- 目标游戏是 Unity 引擎游戏，窗口类名为 `UnityWndClass`，可执行文件名为 `IdleDragons.exe`
- Unity 游戏可能对后台点击(`ControlClick`)不响应，需要测试并支持不同点击方式
- 运行前应确保游戏已启动，否则脚本可能退出

## Copilot 协助方向

当你为该仓库生成或修改代码时，请遵循以下原则：

- 优先保持 AutoHotkey v2 兼容性和函数式调用风格
- 保持中文注释清晰、准确
- 参考现有 `src/lib/window-util.ahk` 实现通用窗口操作，并尽量复用已有辅助函数
- 修改脚本时注意不要破坏已有测试文件和文档说明
- 如果需要新增功能，请同时补充必要的 `docs/` 说明或测试脚本

## 运行提示

建议在 VS Code 中使用 `vscode-autohotkey2-lsp` 插件进行编辑和语法检查。