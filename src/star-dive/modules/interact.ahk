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
 * 检测并触发单个交互项
 * 检测指定交互项的特征文本后执行对应操作
 * @param item Object 交互项配置
 * @return boolean 是否执行了交互
 */
TryInteractSingle(item) {
    local FoundX := 0, FoundY := 0
    local WinPos := WindowUtils.GetPosition(GameWindowTitle)

    if !IsObject(WinPos) {
        return false
    }

    ; local left := item.AnchorX - item.RangeX
    ; local top := item.AnchorY - item.RangeY
    ; local right := item.AnchorX + item.RangeX
    ; local bottom := item.AnchorY + item.RangeY

    ; 绘制调试矩形
    ; DrawRedRect(
    ;     WinPos.x + left, WinPos.y + top,
    ;     WinPos.x + right, WinPos.y + bottom
    ; )

    if (ok := FindText(&FoundX, &FoundY, item.left, item.top, item.right, item.bottom, 0, 0, item.Text)) {
        Try For i, v in ok  ; ok value can be get from ok:=FindText().ok
            if (i <= 2)
                FindText().MouseTip(ok[i].x, ok[i].y)
        GuiLogger.Log(item.LogMsg  " at " FoundX ", " FoundY)
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
        return true
    }

    return false
}

/**
 * 检测并触发交互（遍历所有交互项）
 * @return boolean 是否执行了交互
 */
TryInteract() {
    global InteractItems

    for item in InteractItems {
        if (TryInteractSingle(item)) {
            return true
        }
    }

    return false
}