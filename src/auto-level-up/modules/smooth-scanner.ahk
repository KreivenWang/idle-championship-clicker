#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"

/**
 * 顺滑坐标扫描模块
 * 实现鼠标顺滑地遍历坐标数组中的每个点
 * 使用场景：按顺序平滑移动鼠标到一系列坐标位置并点击
 */

/**
 * 顺滑遍历坐标数组并点击
 * 鼠标从每个点顺滑地移动到下一个点，并在每个点上执行点击
 * 使用步长分段移动，实现顺滑效果
 * @param windowTitle 窗口标题
 * @param coords 坐标数组，格式：[[x1, y1], [x2, y2], ...]
 * @param mouseSpeed 鼠标移动速度 (0-100)
 * @param moveStep 移动步长（像素），每小步移动的距离
 * @param clickDelay 每个点点击后的延迟（毫秒）
 * @param autoReturn 是否自动返回起始点
 */
SmoothScanCoords(windowTitle, coords, mouseSpeed := 3, moveStep := 50, clickDelay := 50, autoReturn := false) {
    ; 获取窗口位置，计算绝对坐标
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 检查坐标数组是否为空
    if (coords.Length = 0) {
        return
    }

    ; 记录起始位置
    startCoord := coords[1]
    absStartX := WinPos.x + startCoord[1]
    absStartY := WinPos.y + startCoord[2]

    ; 移动到第一个点
    MouseMove(absStartX, absStartY, mouseSpeed)
    Sleep(30)
    Click()
    Sleep(clickDelay)

    ; 从第二个点开始，顺滑移动到下一个点
    Loop coords.Length - 1 {
        Index := A_Index
        prevCoord := coords[Index]
        nextCoord := coords[Index + 1]
        
        ; 计算前一个点的绝对坐标
        prevX := WinPos.x + prevCoord[1]
        prevY := WinPos.y + prevCoord[2]
        
        ; 计算下一个点的绝对坐标
        nextX := WinPos.x + nextCoord[1]
        nextY := WinPos.y + nextCoord[2]
        
        ; 计算两点之间的距离
        distance := Sqrt((nextX - prevX) ** 2 + (nextY - prevY) ** 2)
        
        ; 计算需要分多少步移动
        totalSteps := Ceil(distance / moveStep)
        
        ; 计算每步的增量
        stepX := (nextX - prevX) / totalSteps
        stepY := (nextY - prevY) / totalSteps
        
        ; 循环逐步移动（参考 enemy-scanner 的移动方式）
        Loop totalSteps {
            currentX := prevX + stepX * A_Index
            currentY := prevY + stepY * A_Index
            
            MouseMove(currentX, currentY, mouseSpeed)
            Sleep(1)
            Click()
        }
        
        Sleep(1)
        Click()
        Sleep(clickDelay)
    }

    ; 如果启用了自动返回，回到起始点
    if (autoReturn) {
        MouseMove(absStartX, absStartY, mouseSpeed)
    }
}

/**
 * 生成线性路径的中间点
 * 在两个点之间生成指定数量的中间点，用于更顺滑的移动
 * @param x1 起点 X
 * @param y1 起点 Y
 * @param x2 终点 X
 * @param y2 终点 Y
 * @param pointsCount 中间点数量
 * @return 中间点数组，格式：[[x1, y1], [x2, y2], ...]
 */
GenerateLinearPath(x1, y1, x2, y2, pointsCount := 10) {
    local points := []
    local stepX, stepY, i
    
    ; 计算每步的增量
    stepX := (x2 - x1) / pointsCount
    stepY := (y2 - y1) / pointsCount
    
    ; 生成中间点
    Loop pointsCount {
        i := A_Index
        points.Push([
            Round(x1 + stepX * i),
            Round(y1 + stepY * i)
        ])
    }
    
    return points
}

/**
 * 顺滑遍历坐标数组（带路径插值）
 * 在两个坐标点之间生成中间点，实现更顺滑的移动轨迹
 * @param windowTitle 窗口标题
 * @param coords 坐标数组，格式：[[x1, y1], [x2, y2], ...]
 * @param mouseSpeed 鼠标移动速度 (0-100)
 * @param interpolationPoints 插值点数量（两个坐标点之间的中间点数）
 * @param clickDelay 每个点点击后的延迟（毫秒）
 */
SmoothScanWithInterpolation(windowTitle, coords, mouseSpeed := 10, interpolationPoints := 10, clickDelay := 50) {
    ; 获取窗口位置，计算绝对坐标
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 检查坐标数组是否为空
    if (coords.Length = 0) {
        return
    }

    ; 移动到第一个点
    firstCoord := coords[1]
    MouseMove(WinPos.x + firstCoord[1], WinPos.y + firstCoord[2], mouseSpeed)
    Sleep(30)
    Click()
    Sleep(clickDelay)

    ; 从第二个点开始，生成插值路径并移动
    Loop coords.Length - 1 {
        Index := A_Index
        prevCoord := coords[Index]
        nextCoord := coords[Index + 1]
        
        ; 计算绝对坐标
        prevX := WinPos.x + prevCoord[1]
        prevY := WinPos.y + prevCoord[2]
        nextX := WinPos.x + nextCoord[1]
        nextY := WinPos.y + nextCoord[2]
        
        ; 生成中间点
        pathPoints := GenerateLinearPath(prevX, prevY, nextX, nextY, interpolationPoints)
        
        ; 遍历中间点
        for _, point in pathPoints {
            MouseMove(point[1], point[2], mouseSpeed)
            Sleep(1)
            ; 沿着路经点击
            Click()
        }
        
        Sleep(clickDelay)
    }
}
