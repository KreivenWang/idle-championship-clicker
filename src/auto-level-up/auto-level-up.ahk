#Requires AutoHotkey v2.0

#Include "..\lib\window-util.ahk"
#Include "..\lib\hotkey-util.ahk"
#Include "..\lib\gui-logger.ahk"
#Include "modules\config.ahk"
#Include "modules\main-flow.ahk"

; ==========================================
; 🚀 脚本启动与初始化
; ==========================================

; 让脚本适应高 DPI 屏幕，确保没有 windows 缩放 125% 150%，确保坐标和颜色检测准确
DllCall("SetProcessDPIAware")

; 初始化 Pause 快捷键
HotkeyUtil.SetupPauseHotkey("Auto Level Up")

; 初始化 ScrollLock 退出快捷键
HotkeyUtil.SetupScrollLockExit("Auto Level Up")

; 初始化日志窗口
GuiLogger.Init("Auto Level Up - 日志")

; 记录脚本启动
GuiLogger.Log("脚本启动")

; 初始化调试标记
InitDebugMarkers(GameWindowTitle, ButtonCoords, ScanCoords, EnableDebugMarkers, DebugMarkerRadius, DebugVertexMarkerRadius)

; 启动主循环
SetTimer(CheckButtonsWrapper, ScanInterval)

; ==========================================
; 📋 包装函数（适配定时器调用）
; ==========================================

/**
 * 主流程包装函数
 * 用于定时器调用，传递所有配置参数
 */
CheckButtonsWrapper() {
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

    ; 调用主流程
    CheckButtons(
        GameWindowTitle,
        TargetColors,
        ColorVariance,
        ButtonCoords,
        SelectButtonImage,
        SelectImageVariance,
        ScanCoords,
        ScanMouseSpeed,
        ScanMoveStep,
        ScanClickDelay
    )
}
