#Requires AutoHotkey v2.0

#Include "..\lib\window-util.ahk"
#Include "..\lib\hotkey-util.ahk"
#Include "..\lib\gui-logger.ahk"
#Include "..\lib\coords-debug-util.ahk"
#Include "modules\config.ahk"
#Include "modules\navigation.ahk"
#Include "modules\interact.ahk"

; ==========================================
; Star Dive 自动启动脚本
; ==========================================

; 让脚本适应高 DPI 屏幕，确保没有 windows 缩放 125% 150%，确保坐标和颜色检测准确
DllCall("SetProcessDPIAware")

; 初始化 Pause 快捷键
HotkeyUtil.SetupPauseHotkey("Star Dive")

; 初始化 ScrollLock 退出快捷键
HotkeyUtil.SetupScrollLockExit("Star Dive")

; 初始化日志窗口
GuiLogger.Init("Star Dive - 日志")

; 记录脚本启动
GuiLogger.Log("Star Dive 脚本启动")

; 启动主循环
SetTimer(MainLoopWrapper, ScanInterval)

; ==========================================
; 主循环包装函数
; ==========================================

/**
 * 主循环包装函数
 * 用于定时器调用，执行导航状态保持和自动交互
 */
MainLoopWrapper() {
    ; 检查是否暂停
    if (HotkeyUtil.IsPaused()) {
        return
    }

    ; 检查窗口是否存在
    if (GameWindowTitle != "") {
        if !WindowUtils.Exists(GameWindowTitle) {
            GuiLogger.Log("窗口不存在：" GameWindowTitle)
            return
        }
        WindowUtils.EnsureActive(GameWindowTitle)
    }

    ; 获取搜索区域
    local navRegion := GetNavigationSearchRegion()

    ; 1. 保持导航状态开启
    EnsureNavigationOn(
        GameWindowTitle,
        NavigationOnImage,
        NavigationOffImage,
        NavigationImageVariance,
        navRegion
    )

    ; 2. 自动触发交互
    TryInteract()
}