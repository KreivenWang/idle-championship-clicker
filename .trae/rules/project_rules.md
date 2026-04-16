# Idle Championship Clicker 项目规则

## 项目概述

这是一个用于 Unity 游戏 **Idle Champions of the Forgotten Realms** 的自动化辅助工具项目，主要使用 **AutoHotkey v2.0** 编写。项目实现游戏内自动升级、窗口操作和点击测试等脚本功能。

## 技术栈

- **主要语言**: AutoHotkey v2.0
- **开发环境**: Windows
- **推荐编辑器**: VS Code + vscode-autohotkey2-lsp 插件

## 编码规范

### 语言要求
1. 所有代码注释必须使用**中文**
2. 代码注释使用 UTF-8 编码
3. 保持中文注释清晰、准确

### 代码风格
1. 使用 `#Requires AutoHotkey v2.0` 声明版本
2. 采用**函数式调用风格**，如 `ControlClick(...)`、`ToolTip(...)`
3. 所有函数必须添加**函数级注释**，注释使用中文
4. 优先复用 `src/lib/` 目录下的库函数

### 文件组织
- `src/script/` - 主脚本文件
- `src/lib/` - 可复用的库函数
- `src/tests/` - 测试脚本
- `docs/` - 文档说明

## 关键文件

- [auto-level-up.ahk](src\auto-level-up\auto-level-up.ahk) - 主自动升级脚本
- [window-util.ahk](src\lib\window-util.ahk) - 窗口操作与通用辅助函数
- [click-background-app-test.ahk](src\tests\click-background-app-test.ahk) - 后台点击测试脚本
- [tooltip-test.ahk](src\tests\tooltip-test.ahk) - ToolTip 测试脚本
- [auto-level-up.md](docs\auto-level-up.md) - 升级按钮坐标与颜色记录

## 业务背景

### 目标游戏
- **游戏名称**: Idle Champions of the Forgotten Realms
- **引擎**: Unity
- **窗口类名**: `UnityWndClass`
- **可执行文件**: `IdleDragons.exe`

### 技术注意事项
1. Unity 游戏可能对后台点击 (`ControlClick`) 不响应
2. 需要测试并支持不同的点击方式
3. 运行脚本前必须确保游戏已启动

## 开发原则

### 代码修改
1. **保留原有逻辑**: 修改函数实现时，保留之前的函数逻辑，不要随意移除
2. **最小化改动**: 只根据需求实现功能，不添加额外的功能
3. **向后兼容**: 确保修改不破坏现有功能

### 功能开发
1. **优先复用**: 参考并使用现有的 `src/lib/window-util.ahk` 等库函数
2. **测试驱动**: 新增功能时需补充必要的测试脚本
3. **文档同步**: 新功能需要更新 `docs/` 目录下的文档

### 质量保证
1. 不引入中文乱码（生成代码时需检查）
2. 不提交任何密钥或敏感信息
3. 遵循 AutoHotkey v2 的最佳实践

## 运行环境

- **操作系统**: Windows
- **依赖**: AutoHotkey v2.0+
- **游戏依赖**: Idle Champions of the Forgotten Realms 游戏客户端

## 开发建议

1. 使用 VS Code 进行编辑，安装 `vscode-autohotkey2-lsp` 插件
2. 修改脚本前先运行相关测试确保不破坏现有功能
3. 新增功能时参考现有代码风格和实现方式
4. 保持代码简洁、易维护
