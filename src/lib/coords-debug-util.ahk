#Requires AutoHotkey v2.0

/**
 * 坐标调试工具库
 * 用于在游戏窗口上绘制累加数字标记指定坐标位置
 * 使用场景：调试时确认坐标配置是否正确
 */

/**
 * 在指定窗口的一系列坐标位置上绘制累加数字高亮标识
 * @param windowTitle 窗口标题
 * @param coords 坐标数组，格式：[[x1, y1], [x2, y2], ...]
 * @param fontSize 字体大小（像素），默认 20
 */
DrawCoordMarkers(windowTitle, coords, fontSize := 10) {
    ; 获取窗口位置
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 遍历所有坐标，画累加数字
    for Index, Coord in coords {
        ; 计算屏幕绝对坐标
        x := WinPos.x + Coord[1]
        y := WinPos.y + Coord[2]

        ; 画累加数字标识（序号从 1 开始）
        DrawNumberLabel(x, y, Index, fontSize)
    }
}

/**
 * 在指定位置画一个数字标签
 * @param centerX 中心 X 坐标（屏幕绝对坐标）
 * @param centerY 中心 Y 坐标（屏幕绝对坐标）
 * @param number 要显示的数字
 * @param fontSize 字体大小（像素）
 */
DrawNumberLabel(centerX, centerY, number, fontSize := 10) {
    ; 创建一个 GUI 显示数字
    numGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    ; numGui.BackColor := "000000"  ; 黑色背景
    ; 创建文本控件，设置居中对齐和宽度
    txt := numGui.AddText("Center w" (fontSize*1.5) " h" fontSize*1.5 " c00FF00", number)
    txt.SetFont("s" fontSize " w700 c000000", "Arial")  ; w700 表示粗体
    numGui.Show("NoActivate x" (centerX - fontSize) " y" (centerY - fontSize/2))
    
    ; 保存 GUI 引用
    RedDotGUIs.Push(numGui)
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
 * 在指定区域画一个红色矩形框
 * @param left 左上角 X 坐标（屏幕绝对坐标）
 * @param top 左上角 Y 坐标（屏幕绝对坐标）
 * @param right 右下角 X 坐标（屏幕绝对坐标）
 * @param bottom 右下角 Y 坐标（屏幕绝对坐标）
 */
DrawRedRect(left, top, right, bottom) {
    global RedDotGUIs
    
    local width := right - left
    local height := bottom - top
    local borderWidth := 2
    
    ; 上边
    topGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    topGui.BackColor := "FF0000"
    topGui.Show("w" width " h" borderWidth " NoActivate x" left " y" top)
    RedDotGUIs.Push(topGui)
    
    ; 下边
    bottomGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    bottomGui.BackColor := "FF0000"
    bottomGui.Show("w" width " h" borderWidth " NoActivate x" left " y" (bottom - borderWidth))
    RedDotGUIs.Push(bottomGui)
    
    ; 左边
    leftGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    leftGui.BackColor := "FF0000"
    leftGui.Show("w" borderWidth " h" height " NoActivate x" left " y" top)
    RedDotGUIs.Push(leftGui)
    
    ; 右边
    rightGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    rightGui.BackColor := "FF0000"
    rightGui.Show("w" borderWidth " h" height " NoActivate x" (right - borderWidth) " y" top)
    RedDotGUIs.Push(rightGui)
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
