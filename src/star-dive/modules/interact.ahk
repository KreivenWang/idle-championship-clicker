#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\gui-logger.ahk"
#Include "..\..\lib\find-text.ahk"
#Include "..\..\lib\coords-debug-util.ahk"
#Include "config.ahk"

/**
 * 自动交互模块
 * 负责检测并按下对应按键触发交互
 */

/**
 * 检测并触发交互
 * 遍历所有交互项，检测到特征文本后执行对应操作
 * @return boolean 是否执行了交互
 */
TryInteract() {
    global InteractItems
    local FoundX := 0, FoundY := 0
    local WinPos := WindowUtils.GetPosition(GameWindowTitle)

    if !IsObject(WinPos) {
        return false
    }

    for item in InteractItems {
        local left := item.AnchorX - item.RangeX
        local top := item.AnchorY - item.RangeY
        local right := item.AnchorX + item.RangeX
        local bottom := item.AnchorY + item.RangeY

        ; 绘制调试矩形
        ; DrawRedRect(
        ;     WinPos.x + left, WinPos.y + top,
        ;     WinPos.x + right, WinPos.y + bottom
        ; )

        if (FindText(&FoundX, &FoundY, left, top, right, bottom, 0, 0, item.Text)) {
            GuiLogger.Log(item.LogMsg)
            for action in item.Action {
                if (action.HasOwnProp("Click") && action.Click) {
                    ; 点击位置偏移 25 像素
                    MouseMove(FoundX + 25, FoundY, 0) 
                    Sleep(5)
                    Click()
                } else if (action.HasOwnProp("Key")) {
                    Send(action.Key)
                }
                if (action.HasOwnProp("Delay") && action.Delay > 0) {
                    Sleep(action.Delay)
                }
            }
        }
    }

    return false
}