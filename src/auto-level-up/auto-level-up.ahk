#Requires AutoHotkey v2.0

#Include "..\lib\window-util.ahk"
#Include "..\lib\hotkey-util.ahk"
#Include "..\lib\color-util.ahk"
#Include "..\lib\gui-logger.ahk"
#Include "..\lib\coords-debug-util.ahk"

; ==========================================
; ⚙️ 配置区域 (请根据实际情况修改这里)
; ==========================================

; 1. 游戏窗口标题 (如果不确定，可以先留空 ""，脚本会默认操作当前激活的窗口)
GameWindowTitle := "Idle Champions" ; 例如 "Idle Champions" 或者留空 ""

; 2. 需要点击的颜色数组
TargetColors := ["0x5CCB2F", "0x5CABF7"]  ; 绿色, 蓝色

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
ScanInterval := 3000

; 6. "选择"按钮图片路径（若出现绿色"选择"按钮，优先点击）
SelectButtonImage := "select-btn.png"
SelectImageVariance := 200 ; 图像搜索容差，可根据需要调大

; 7. 敌人区域扫描配置
EnemyAreaStartX := 1027       ; 扫描区域左上角 X
EnemyAreaStartY := 461       ; 扫描区域左上角 Y
EnemyAreaEndX := 2462        ; 扫描区域右下角 X
EnemyAreaEndY := 1000        ; 扫描区域右下角 Y
EnemyAreaScanLineSpacing := 50 ; 每行扫描间距（像素），默认 50
EnemyAreaScanStep := 50      ; 蛇形扫描每步移动的像素距离，默认 50
EnemyAreaMouseMoveSpeed := 50 ; 鼠标移动速度 (0-100)，0=瞬间移动，数值越大越慢，默认 3

; ==========================================
; 🚀 核心逻辑 (下面代码通常不需要动)
; ==========================================

; 让脚本适应高DPI屏幕，确保没有windows缩放 125% 150%，确保坐标和颜色检测准确
DllCall("SetProcessDPIAware")

; 初始化 Pause 快捷键
HotkeyUtil.SetupPauseHotkey("Auto Level Up")

; 初始化 ScrollLock 退出快捷键
HotkeyUtil.SetupScrollLockExit("Auto Level Up")

; 初始化日志窗口
GuiLogger.Init("Auto Level Up - 日志")

; 记录脚本启动
GuiLogger.Log("脚本启动")

; 启动时绘制调试标记
; 1. 绘制按钮坐标位置
DrawCoordMarkers(GameWindowTitle, ButtonCoords, 15)
GuiLogger.Log("已绘制 " ButtonCoords.Length " 个按钮坐标的红色标识（调试用）")

; 2. 绘制扫描区域的两个顶点（左上角和右下角）
EnemyAreaVertices := [[EnemyAreaStartX, EnemyAreaStartY], [EnemyAreaEndX, EnemyAreaEndY]]
DrawCoordMarkers(GameWindowTitle, EnemyAreaVertices, 20)
GuiLogger.Log("已绘制扫描区域 2 个顶点的红色标识（调试用）")

; 主循环
SetTimer(CheckButtons, ScanInterval)

CheckButtons() {
    global GameWindowTitle, TargetColors, ColorVariance, ButtonCoords, SelectButtonImage, SelectImageVariance, EnemyAreaStartX, EnemyAreaStartY, EnemyAreaEndX, EnemyAreaEndY, EnemyAreaScanLineSpacing, EnemyAreaMouseMoveSpeed

    ; 检查是否暂停
    if (HotkeyUtil.IsPaused()) {
        return
    }

    ; 1. 检查窗口是否存在并激活到前台
    if (GameWindowTitle != "") {
        if !WindowUtils.Exists(GameWindowTitle) {
            GuiLogger.Log("窗口不存在: " GameWindowTitle)
            return
        }
        WindowUtils.EnsureActive(GameWindowTitle)
    }

    ; 尝试先点击“选择”按钮
    if (TryClickSelectButton()) {
        Sleep(50)
    }

    ; 2. 从后往前遍历坐标
    totalCount := ButtonCoords.Length
    Loop totalCount {
        Index := totalCount - A_Index + 1  ; 从后往前
        Coord := ButtonCoords[Index]

        ; 获取窗口位置，计算屏幕绝对坐标
        WinPos := WindowUtils.GetPosition(GameWindowTitle)
        x := WinPos.x + Coord[1]
        y := WinPos.y + Coord[2]

        ; 2.1 先移动鼠标到目标位置
        MouseMove(x, y, 0)

        ; 2.2 稍微等待鼠标移动完成
        Sleep(50)

        ; 3. 获取该坐标的像素颜色
        currentColor := PixelGetColor(x, y, "RGB")

        ; 4. 判断颜色是否匹配 (遍历所有目标颜色)
        matched := false
        for targetColor in TargetColors {
            if (ColorUtil.ColorsMatch(currentColor, targetColor, ColorVariance)) {
                matched := true
                break
            }
        }

        if (matched) {
            ; 5. 颜色匹配！执行点击5次
            Loop 5 {
                Click()
                Sleep(20)
            }
            GuiLogger.Log("点击了按钮5次 #" Index " 坐标: " x "," y " 颜色: " Format("{:#x}", currentColor))
            GuiLogger.UpdateStatus("已点击按钮5次 #" Index)

            ; 点击后稍微停顿一下
            Sleep(50)
        }


    }

    ; 6. 蛇形移动鼠标涂抹敌人所在区域
    ScanEnemyArea()
}

TryClickSelectButton() {
    global GameWindowTitle, SelectButtonImage, SelectImageVariance

    local FoundX := 0, FoundY := 0

    if (SelectButtonImage = "") {
        return false
    }

    WinPos := WindowUtils.GetPosition(GameWindowTitle)
    if !IsObject(WinPos) {
        return false
    }

    result := ImageSearch(&FoundX, &FoundY, WinPos.x, WinPos.y, WinPos.x + WinPos.w, WinPos.y + WinPos.h, "*n" SelectImageVariance " " SelectButtonImage)

    if (result = 1 and FoundX != "" and FoundY != "") {
        MouseMove(FoundX + 10, FoundY + 10, 0)
        Sleep(50)
        Click()
        GuiLogger.Log("检测到并点击了选择按钮：" SelectButtonImage)
        GuiLogger.UpdateStatus("已点击选择按钮")
        return true
    }

    GuiLogger.Log("未检测到选择按钮：" SelectButtonImage)
    return false
}

/**
 * 蛇形逐行移动鼠标扫描涂抹敌人所在区域
 * 从左上角开始，逐行左右扫描，覆盖整个敌人区域
 */
ScanEnemyArea() {
    global GameWindowTitle, EnemyAreaStartX, EnemyAreaStartY, EnemyAreaEndX, EnemyAreaEndY, EnemyAreaScanLineSpacing, EnemyAreaScanStep, EnemyAreaMouseMoveSpeed

    ; 获取窗口位置，计算绝对坐标
    WinPos := WindowUtils.GetPosition(GameWindowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 计算扫描区域的绝对坐标
    startX := WinPos.x + EnemyAreaStartX
    startY := WinPos.y + EnemyAreaStartY
    endX := WinPos.x + EnemyAreaEndX
    endY := WinPos.y + EnemyAreaEndY

    ; 计算扫描行数
    totalLines := Ceil((endY - startY) / EnemyAreaScanLineSpacing)

    ; 蛇形扫描：逐行左右移动
    Loop totalLines {
        lineIndex := A_Index
        currentY := startY + (lineIndex - 1) * EnemyAreaScanLineSpacing

        ; 确保 Y 坐标不超过扫描区域
        if (currentY > endY) {
            break
        }

        ; 计算当前行需要扫描的步数
        totalSteps := Ceil((endX - startX) / EnemyAreaScanStep)

        ; 偶数行：从左到右
        if (Mod(lineIndex, 2) = 1) {
            Loop totalSteps {
                currentX := startX + (A_Index - 1) * EnemyAreaScanStep
                if (currentX > endX) {
                    break
                }
                MouseMove(currentX, currentY, EnemyAreaMouseMoveSpeed)
                Sleep(1)
                Click()
            }
        } else {
            ; 奇数行：从右到左
            Loop totalSteps {
                currentX := endX - (A_Index - 1) * EnemyAreaScanStep
                if (currentX < startX) {
                    break
                }
                MouseMove(currentX, currentY, EnemyAreaMouseMoveSpeed)
                Sleep(1)
                Click()
            }
        }
    }

    ; 扫描完成后回到起始位置
    MouseMove(startX, startY, EnemyAreaMouseMoveSpeed)
}