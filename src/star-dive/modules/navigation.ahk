#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\gui-logger.ahk"

/**
 * 导航状态保持模块
 * 负责检测并保持导航按钮为开启状态
 */

/**
 * 检查导航状态并保持开启
 * 如果检测到 navigation-off，则按 R 键切换为 on
 * 如果已经是 navigation-on，则不做任何操作
 * @param windowTitle 窗口标题
 * @param navigationOnImage 导航开启图片路径
 * @param navigationOffImage 导航关闭图片路径
 * @param imageVariance 图像搜索容差
 * @param searchRegion 搜索区域 [left, top, right, bottom]
 * @return boolean 是否执行了操作
 */
EnsureNavigationOn(windowTitle, navigationOnImage, navigationOffImage, imageVariance, searchRegion) {
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

    ; 先搜索 navigation-on 按钮
    result := ImageSearch(&FoundX, &FoundY, absLeft, absTop, absRight, absBottom, "*n" imageVariance " " navigationOnImage)

    if (result = 1 and FoundX != "" and FoundY != "") {
        ; 已经是开启状态，不需要操作
        GuiLogger.Log("导航状态：已开启")
        return false
    }

    ; 搜索 navigation-off 按钮
    result := ImageSearch(&FoundX, &FoundY, absLeft, absTop, absRight, absBottom, "*n" imageVariance " " navigationOffImage)

    if (result = 1 and FoundX != "" and FoundY != "") {
        ; 检测到关闭状态，按 R 键切换
        GuiLogger.Log("检测到导航关闭状态，按 R 键切换")
        Send("{r}")
        Sleep(200)
        GuiLogger.Log("已发送 R 键")
        return true
    }

    ; 都没有检测到
    GuiLogger.Log("未检测到导航按钮状态")
    return false
}