#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\gui-logger.ahk"

/**
 * 自动交互模块
 * 负责检测并按下 F 键触发交互
 */

/**
 * 检测并触发交互
 * 如果在指定区域内检测到 F 按钮图片，则按 F 键
 * @param windowTitle 窗口标题
 * @param interactImage F 按钮图片路径
 * @param imageVariance 图像搜索容差
 * @param searchRegion 搜索区域 [left, top, right, bottom]
 * @return boolean 是否执行了交互
 */
TryInteract(windowTitle, interactImage, imageVariance, searchRegion) {
    local FoundX := 0, FoundY := 0

    ; 获取窗口位置
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return false
    }

    ; 计算屏幕绝对坐标的搜索区域
    local absLeft := WinPos.x + searchRegion[1]
    local absTop := WinPos.y + searchRegion[2]
    local absRight := WinPos.x + searchRegion[3]
    local absBottom := WinPos.y + searchRegion[4]

    ; 搜索 F 按钮图片
    result := ImageSearch(&FoundX, &FoundY, absLeft, absTop, absRight, absBottom, "*n" imageVariance " " interactImage)

    if (result = 1 and FoundX != "" and FoundY != "") {
        ; 检测到 F 按钮，按 F 键
        GuiLogger.Log("检测到 F 按钮，按 F 键交互")
        Send("{f}")
        Sleep(200)
        GuiLogger.Log("已发送 F 键")
        return true
    }

    return false
}