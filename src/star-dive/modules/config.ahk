#Requires AutoHotkey v2.0

/**
 * Star Dive 配置模块
 * 包含所有可配置的参数和坐标
 */

; ==========================================
; 游戏窗口配置
; ==========================================

/**
 * 游戏窗口标题
 * 如果不确定，可以留空 ""，脚本会默认操作当前激活的窗口
 */
GameWindowTitle := "Idle Champions"

; ==========================================
; 导航按钮配置
; ==========================================

/**
 * 导航按钮检测中心坐标
 */
NavigationButtonCenterX := 2436
NavigationButtonCenterY := 1148

/**
 * 导航按钮检测范围（中心点周围半径）
 */
NavigationButtonRadius := 100

/**
 * 导航按钮图片路径
 */
NavigationOnImage := "docs\navigation-on.png"
NavigationOffImage := "docs\navigation-off.png"

/**
 * 图像搜索容差
 */
NavigationImageVariance := 50

; ==========================================
; 交互按钮配置
; ==========================================

/**
 * F按钮检测中心坐标
 */
InteractButtonCenterX := 1508
InteractButtonCenterY := 811

/**
 * F按钮检测范围（中心点周围半径）
 */
InteractButtonRadius := 50

/**
 * F按钮图片路径
 */
InteractButtonImage := "docs\interact-f.png"

/**
 * F按钮图像搜索容差
 */
InteractImageVariance := 50

; ==========================================
; 扫描频率配置
; ==========================================

/**
 * 检测频率（毫秒）
 * 每多少毫秒扫描一次屏幕
 */
ScanInterval := 1000

; ==========================================
; 坐标计算辅助函数
; ==========================================

/**
 * 获取导航按钮检测区域
 * @return Array [left, top, right, bottom]
 */
GetNavigationSearchRegion() {
    local left := NavigationButtonCenterX - NavigationButtonRadius
    local top := NavigationButtonCenterY - NavigationButtonRadius
    local right := NavigationButtonCenterX + NavigationButtonRadius
    local bottom := NavigationButtonCenterY + NavigationButtonRadius
    return [left, top, right, bottom]
}

/**
 * 获取F按钮检测区域
 * @return Array [left, top, right, bottom]
 */
GetInteractSearchRegion() {
    local left := InteractButtonCenterX - InteractButtonRadius
    local top := InteractButtonCenterY - InteractButtonRadius
    local right := InteractButtonCenterX + InteractButtonRadius
    local bottom := InteractButtonCenterY + InteractButtonRadius
    return [left, top, right, bottom]
}