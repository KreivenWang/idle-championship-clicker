#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\gui-logger.ahk"

/**
 * 点击选择按钮模块
 * 负责检测并点击游戏中的"选择"按钮
 */

/**
 * 尝试点击选择按钮
 * @param windowTitle 窗口标题
 * @param selectButtonImage 选择按钮图片路径
 * @param selectImageVariance 图像搜索容差
 * @return boolean 是否成功点击
 */
TryClickSelectButton(windowTitle, selectButtonImage, selectImageVariance) {
    local FoundX := 0, FoundY := 0

    ; 检查是否配置了图片路径
    if (selectButtonImage = "") {
        return false
    }

    ; 获取窗口位置
    WinPos := WindowUtils.GetPosition(windowTitle)
    if !IsObject(WinPos) {
        return false
    }

    ; 在整个窗口范围内搜索图片
    result := ImageSearch(&FoundX, &FoundY, WinPos.x, WinPos.y, WinPos.x + WinPos.w, WinPos.y + WinPos.h, "*n" selectImageVariance " " selectButtonImage)

    ; 如果找到图片，点击它
    if (result = 1 and FoundX != "" and FoundY != "") {
        MouseMove(FoundX + 10, FoundY + 10, 0)
        Sleep(50)
        Click()
        GuiLogger.Log("检测到并点击了选择按钮：" selectButtonImage)
        GuiLogger.UpdateStatus("已点击选择按钮")
        return true
    }

    GuiLogger.Log("未检测到选择按钮：" selectButtonImage)
    return false
}
