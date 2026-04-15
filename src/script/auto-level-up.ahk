#Requires AutoHotkey v2.0

#Include "lib\window-util.ahk"

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
ButtonStartX := 280
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

; ==========================================
; 🚀 核心逻辑 (下面代码通常不需要动)
; ==========================================

; 初始化 Pause 快捷键
WindowUtils.SetupPauseHotkey("Auto Level Up")

; 主循环
SetTimer(CheckButtons, ScanInterval)

CheckButtons() {
    global GameWindowTitle, TargetColor, ColorVariance, ButtonCoords

    ; 检查是否暂停
    if (WindowUtils.IsPaused()) {
        return
    }

    ; 1. 检查窗口是否存在 (如果设置了窗口标题)
    if (GameWindowTitle != "") {
        if !WindowUtils.Exists(GameWindowTitle) {
            ; 窗口没找到，不做任何事
            return
        }
        ; 保持后台运行，不激活窗口
    }

    ; 2. 遍历 13 个坐标
    for Index, Coord in ButtonCoords {
        x := Coord[1]
        y := Coord[2]

        ; 2.1 先移动鼠标到目标位置
        MouseMove(x, y, 0)

        ; 2.2 稍微等待鼠标移动完成
        Sleep(50)

        ; 3. 获取该坐标的像素颜色
        ; PixelGetColor 返回的是十进制，需要转换或者直接比较
        currentColor := PixelGetColor(x, y, "RGB")

        ; 4. 判断颜色是否匹配 (考虑容差)
        ; 这里使用简单的颜色近似判断
        if (ColorsMatch(currentColor, TargetColor, ColorVariance)) {
            ; 颜色匹配！执行点击
            ; Click()
            ControlClick("x" x " y" y, "Idle Champions")

            ; 如果你想用 ToolTip 在屏幕上显示日志，而不是在 VS Code 控制台
            ToolTip("后台点击了: " x "," y)

            ; 点击后稍微停顿一下，防止一帧内重复点击或误触
            Sleep(1000)
            break ; 跳出循环，重新开始检测 (防止一次扫描点多个)
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

RemoveToolTip() {
    ToolTip()
}