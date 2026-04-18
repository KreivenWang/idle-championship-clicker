#Requires AutoHotkey v2.0

/**
 * 坐标调试工具库
 * 用于在游戏窗口上绘制红色圆圈标记指定坐标位置
 * 使用场景：调试时确认坐标配置是否正确
 */

/**
 * 在指定窗口的一系列坐标位置上绘制红色圆圈高亮标识
 * @param windowTitle 窗口标题
 * @param coords 坐标数组，格式：[[x1, y1], [x2, y2], ...]
 * @param radius 圆圈半径（像素），默认 15
 */
DrawCoordMarkers(windowTitle, coords, radius := 15) {
    ; 获取窗口位置
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 遍历所有坐标，画红色圆圈
    for Index, Coord in coords {
        ; 计算屏幕绝对坐标
        x := WinPos.x + Coord[1]
        y := WinPos.y + Coord[2]

        ; 画红色圆圈标识
        DrawRedCircle(x, y, radius)
    }
}

/**
 * 在指定位置画一个红色圆圈
 * @param centerX 圆心 X 坐标（屏幕绝对坐标）
 * @param centerY 圆心 Y 坐标（屏幕绝对坐标）
 * @param radius 圆的半径（像素）
 */
DrawRedCircle(centerX, centerY, radius) {
    ; 画一个空心圆，通过计算圆周上的点
    steps := 36  ; 圆周的点数
    angleStep := 360 / steps

    Loop steps {
        angle := A_Index * angleStep
        rad := angle * (3.14159265359 / 180)  ; 转换为弧度
        x := Round(centerX + radius * Cos(rad))
        y := Round(centerY + radius * Sin(rad))

        ; 画一个小红点
        DrawRedDot(x, y, 3)
    }
}

/**
 * 全局变量：存储所有红色标记点 GUI
 */
RedDotGUIs := []

/**
 * 在指定位置画一个红色小点
 * @param x X 坐标（屏幕绝对坐标）
 * @param y Y 坐标（屏幕绝对坐标）
 * @param size 点的大小（半径，像素）
 */
DrawRedDot(x, y, size) {
    global RedDotGUIs
    
    ; 创建一个小 GUI 作为红点
    dotGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    dotGui.BackColor := "FF0000"  ; 红色
    dotGui.Show("w" (size * 2) " h" (size * 2) " NoActivate x" (x - size) " y" (y - size))
    
    ; 保存 GUI 引用
    RedDotGUIs.Push(dotGui)
}

/**
 * 清理所有红色标记点
 * 调用此函数会销毁所有绘制的红点
 */
CleanupCoordMarkers() {
    global RedDotGUIs
    
    for gui in RedDotGUIs {
        if (gui) {
            gui.Destroy()
        }
    }
    RedDotGUIs := []
}
