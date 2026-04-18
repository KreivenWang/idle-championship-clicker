#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"

/**
 * 敌人区域扫描模块
 * 负责蛇形移动鼠标扫描涂抹敌人所在区域
 */

/**
 * 蛇形逐行移动鼠标扫描涂抹敌人所在区域
 * 从左上角开始，逐行左右扫描，覆盖整个敌人区域
 * @param windowTitle 窗口标题
 * @param startX 扫描区域起始 X（相对窗口）
 * @param startY 扫描区域起始 Y（相对窗口）
 * @param endX 扫描区域结束 X（相对窗口）
 * @param endY 扫描区域结束 Y（相对窗口）
 * @param lineSpacing 每行扫描间距（像素）
 * @param scanStep 蛇形扫描每步移动的像素距离
 * @param mouseSpeed 鼠标移动速度 (0-100)
 */
ScanEnemyArea(windowTitle, startX, startY, endX, endY, lineSpacing, scanStep, mouseSpeed) {
    ; 获取窗口位置，计算绝对坐标
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return
    }

    ; 计算扫描区域的绝对坐标
    absStartX := WinPos.x + startX
    absStartY := WinPos.y + startY
    absEndX := WinPos.x + endX
    absEndY := WinPos.y + endY

    ; 计算扫描行数
    totalLines := Ceil((absEndY - absStartY) / lineSpacing)

    ; 蛇形扫描：逐行左右移动
    Loop totalLines {
        lineIndex := A_Index
        currentY := absStartY + (lineIndex - 1) * lineSpacing

        ; 确保 Y 坐标不超过扫描区域
        if (currentY > absEndY) {
            break
        }

        ; 计算当前行需要扫描的步数
        totalSteps := Ceil((absEndX - absStartX) / scanStep)

        ; 偶数行：从左到右
        if (Mod(lineIndex, 2) = 1) {
            Loop totalSteps {
                currentX := absStartX + (A_Index - 1) * scanStep
                if (currentX > absEndX) {
                    break
                }
                MouseMove(currentX, currentY, mouseSpeed)
                Sleep(1)
                Click()
            }
        } else {
            ; 奇数行：从右到左
            Loop totalSteps {
                currentX := absEndX - (A_Index - 1) * scanStep
                if (currentX < absStartX) {
                    break
                }
                MouseMove(currentX, currentY, mouseSpeed)
                Sleep(1)
                Click()
            }
        }
    }

    ; 扫描完成后回到起始位置
    MouseMove(absStartX, absStartY, mouseSpeed)
}
