#Requires AutoHotkey v2.0

#Include "..\lib\window-util.ahk"
#Include "..\lib\gui-logger.ahk"

; ==========================================
; ⚙️ 配置区域 (请根据实际情况修改这里)
; ==========================================

; 1. 游戏窗口标题 (如果不确定，可以先留空 ""，脚本会默认操作当前激活的窗口)
GameWindowTitle := "Idle Champions" ; 例如 "Idle Champions" 或者留空 ""

; 2. "变绿"的颜色代码 (从 Window Spy 获取，格式 0xRRGGBB)
TargetColor := "0x5CCB2F" ; <--- 替换成你看到的绿色代码

; 3. 颜色误差容差 (0-255)。因为游戏可能有光影效果，颜色不会完全一样，建议设为 10-30
ColorVariance := 20

; 4. 13个格子的坐标列表 (X, Y)
; 格式: [ [x1, y1], [x2, y2], ... ]
; 使用变量和计算方式生成坐标，方便维护
ButtonStartX := 230
ButtonWidth := 173
ButtonY := 1384
ButtonCount := 13

ButtonCoords := []
Loop ButtonCount {
    x := ButtonStartX + (A_Index - 1) * ButtonWidth
    ButtonCoords.Push([x, ButtonY])
}

; 5. 检测频率 (毫秒)。每多少毫秒扫描一次屏幕？建议 200-500
ScanInterval := 2000
DebugDelay := 500 ; 调试时的额外延迟，正式使用时可以设为0

; ==========================================
; 🚀 核心逻辑 (下面代码通常不需要动)
; ==========================================

; 初始化 Pause 快捷键
WindowUtils.SetupPauseHotkey("Auto Level Up")

; 初始化日志窗口
GuiLogger.Init("Auto Level Up - 日志")

; 记录脚本启动
GuiLogger.Log("脚本启动")

; 主循环
SetTimer(CheckButtons, ScanInterval)

CheckButtons() {
    global GameWindowTitle, TargetColor, ColorVariance, ButtonCoords

    ; 检查是否暂停
    if (WindowUtils.IsPaused()) {
        return
    }

    ; 1. 检查窗口是否存在并激活到前台
    if (GameWindowTitle != "") {
        if !WindowUtils.Exists(GameWindowTitle) {
            GuiLogger.Log("窗口不存在: " GameWindowTitle)
            return
        }
        ; 确保窗口激活到前台
        if WinActive(GameWindowTitle) = 0 {
            GuiLogger.Log("激活窗口到前台")
            WinActivate(GameWindowTitle)
            WinWaitActive(GameWindowTitle, , 2)
        }
    }

    ; 2. 遍历 13 个坐标
    for Index, Coord in ButtonCoords {
        ; 获取窗口位置，计算屏幕绝对坐标
        WinPos := WindowUtils.GetPosition(GameWindowTitle)
        x := WinPos.x + Coord[1]
        y := WinPos.y + Coord[2]

        ; 2.1 先移动鼠标到目标位置
        MouseMove(x, y, 0)

        ; 2.2 稍微等待鼠标移动完成
        Sleep(50 + DebugDelay)

        ; 3. 获取该坐标的像素颜色
        currentColor := PixelGetColor(x, y, "RGB")

        ; 4. 判断颜色是否匹配 (考虑容差)
        if (ColorsMatch(currentColor, TargetColor, ColorVariance)) {
            ; 颜色匹配！执行点击
            Click()

            GuiLogger.Log("点击了按钮 #" Index " 坐标: " x "," y " 颜色: " Format("{:#x}", currentColor))
            GuiLogger.UpdateStatus("已点击按钮 #" Index)

            ; 点击后稍微停顿一下
            Sleep(1000 + DebugDelay)
            break ; 跳出循环，重新开始检测
        }
    }
}

; 简单的颜色容差比较函数
ColorsMatch(c1, c2, variance) {
    r1 := (c1 >> 16) & 0xFF
    g1 := (c1 >> 8) & 0xFF
    b1 := c1 & 0xFF

    r2 := (c2 >> 16) & 0xFF
    g2 := (c2 >> 8) & 0xFF
    b2 := c2 & 0xFF

    return (Abs(r1 - r2) <= variance && Abs(g1 - g2) <= variance && Abs(b1 - b2) <= variance)
}