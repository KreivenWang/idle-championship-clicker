#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\color-util.ahk"
#Include "..\..\lib\gui-logger.ahk"
#Include "..\..\lib\coords-debug-util.ahk"
#Include "select-button.ahk"
#Include "smooth-scanner.ahk"

/**
 * 主流程模块
 * 负责自动升级的核心逻辑：检测颜色、点击按钮、顺滑扫描敌人区域
 */

/**
 * 检查并点击按钮的主流程
 * @param windowTitle 窗口标题
 * @param targetColors 目标颜色数组
 * @param colorVariance 颜色容差
 * @param buttonCoords 按钮坐标数组
 * @param selectButtonImage 选择按钮图片路径
 * @param selectImageVariance 选择按钮图片容差
 * @param scanCoords 扫描区域坐标数组（6 个点）
 * @param scanMouseSpeed 扫描时鼠标移动速度
 * @param scanMoveStep 扫描时移动步长（像素）
 * @param scanClickDelay 扫描时点击延迟
 */
CheckButtons(windowTitle, targetColors, colorVariance, buttonCoords, selectButtonImage, selectImageVariance, scanCoords, scanMouseSpeed, scanMoveStep, scanClickDelay) {
    ; 尝试先点击"选择"按钮
    if (TryClickSelectButton(windowTitle, selectButtonImage, selectImageVariance)) {
        Sleep(50)
    }

    ; 从后往前遍历坐标
    totalCount := buttonCoords.Length
    Loop totalCount {
        Index := totalCount - A_Index + 1  ; 从后往前
        Coord := buttonCoords[Index]

        ; 获取窗口位置，计算屏幕绝对坐标
        WinPos := WindowUtils.GetPosition(windowTitle)
        x := WinPos.x + Coord[1]
        y := WinPos.y + Coord[2]

        ; 先移动鼠标到目标位置
        MouseMove(x, y, 0)

        ; 稍微等待鼠标移动完成
        Sleep(50)

        ; 获取该坐标的像素颜色
        currentColor := PixelGetColor(x, y, "RGB")

        ; 判断颜色是否匹配 (遍历所有目标颜色)
        matched := false
        for targetColor in targetColors {
            if (ColorUtil.ColorsMatch(currentColor, targetColor, colorVariance)) {
                matched := true
                break
            }
        }

        if (matched) {
            ; 颜色匹配！执行点击 5 次
            Loop 5 {
                Click()
                Sleep(20)
            }
            GuiLogger.Log("点击了按钮 5 次 #" Index " 坐标：" x "," y " 颜色：" Format("{:#x}", currentColor))
            GuiLogger.UpdateStatus("已点击按钮 5 次 #" Index)

            ; 点击后稍微停顿一下
            Sleep(50)
        }
    }

    ; 使用顺滑扫描器遍历 6 个坐标点涂抹敌人所在区域
    SmoothScanCoords(windowTitle, scanCoords, scanMouseSpeed, scanMoveStep, scanClickDelay, false)
}

/**
 * 初始化调试标记
 * 在启动时绘制按钮坐标和扫描区域坐标的红色标记
 * @param windowTitle 窗口标题
 * @param buttonCoords 按钮坐标数组
 * @param scanCoords 扫描区域坐标数组
 * @param enableDebug 是否启用调试标记
 * @param markerRadius 按钮标记半径
 * @param vertexMarkerRadius 扫描点标记半径
 */
InitDebugMarkers(windowTitle, buttonCoords, scanCoords, enableDebug, markerRadius, vertexMarkerRadius) {
    if (!enableDebug) {
        return
    }

    ; 绘制按钮坐标位置
    DrawCoordMarkers(windowTitle, buttonCoords, markerRadius)
    GuiLogger.Log("已绘制 " buttonCoords.Length " 个按钮坐标的红色标识（调试用）")

    ; 绘制扫描区域的坐标点
    DrawCoordMarkers(windowTitle, scanCoords, vertexMarkerRadius)
    GuiLogger.Log("已绘制扫描区域 " scanCoords.Length " 个坐标点的红色标识（调试用）")
}
