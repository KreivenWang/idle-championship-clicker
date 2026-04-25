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

; 全局变量：存储交互定时器项
InteractTimerItems := []

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

; 启动导航状态保持定时器
SetTimer(NavigationLoopWrapper, ScanInterval)

; 为每个交互项创建独立定时器
SetupInteractTimers()

; ==========================================
; 导航状态保持包装函数
; ==========================================

/**
 * 导航状态保持包装函数
 * 用于定时器调用，执行导航状态保持
 */
NavigationLoopWrapper() {
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

    ; 保持导航状态开启
    EnsureNavigationOn(
        GameWindowTitle,
        NavigationOnImage,
        NavigationOffImage,
        NavigationImageVariance,
        navRegion
    )
}

; ==========================================
; 交互定时器设置
; ==========================================

/**
 * 为每个交互项创建独立定时器
 */
SetupInteractTimers() {
    global InteractItems
    global InteractTimerItems
    
    ; 初始化数组
    InteractTimerItems := []
    
    for i, item in InteractItems {
        ; 将交互项存储到全局数组，通过索引访问
        InteractTimerItems.Push(item)
        ; 创建定时器，传入索引
        SetTimer(CreateInteractTimerFunc(i), ScanInterval)
        GuiLogger.Log("已创建 交互定时器" item.LogMsg)
    }
    
}

/**
 * 创建交互定时器函数
 * @param index Integer 交互项索引
 * @return Func 定时器回调函数
 */
CreateInteractTimerFunc(index) {
    return (*) => InteractTimerCallback(index)
}

/**
 * 交互定时器回调函数
 * @param index Integer 交互项索引
 */
InteractTimerCallback(index) {
    global InteractTimerItems
    
    ; 检查是否暂停
    if (HotkeyUtil.IsPaused()) {
        return
    }

    ; 检查窗口是否存在
    if (GameWindowTitle != "") {
        if !WindowUtils.Exists(GameWindowTitle) {
            return
        }
    }

    ; 检测并触发单个交互项
    TryInteractSingle(InteractTimerItems[index])
}