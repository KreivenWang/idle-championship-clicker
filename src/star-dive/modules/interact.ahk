#Requires AutoHotkey v2.0

#Include "..\..\lib\window-util.ahk"
#Include "..\..\lib\gui-logger.ahk"
#Include "..\..\lib\find-text.ahk"

/**
 * 自动交互模块
 * 负责检测并按下 F 键触发交互
 */

/**
 * F 按钮 FindText 文本模式
 */
FButton := "|<>*60$36.zzzzzyzzzzzyz0000zw0000Ds00007szzzz7lzzzzXlz00zXlz00TXlz00TXlz00TXlz00zXlz1zzXlz1zzXlz1zzXlz1zzXlz00zXlz00zXlz00zXlz00zXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlzzzzXszzzz7s00007w0000DT0000yDzzzzw7zzzzsU"

/**
 * 对话顶部标记 FindText 文本模式
 */
ConversationTopMark := "|<>*183$74.zzzzz0Tzzzzzzzzzz07zzzzzzzzzz01zxzzzzzzzzU7zzzzzzzzzzkTzzzzzzzzzzkDzzzzzzzzzzw7zzzzzzzzzzy7zzzzzzzzzzz3zzzzzzzzzzzVzyzzzzzzzzzszzrzzzzzzzzwDzwzzzzzzzzz7zzDzzzzzzzzVzzHzzzzzzzzsTzkjzzzzzzzyDzw7zzzzzzzz3zy07zzzzzzzkzy03zzzzz000Tw007zU000007zk03zs003zzvzvUDzyDzzzzzzzo1zz3zzzzzzzz2zzlzzzzzzzzozzwTzzzzzzzzDzy7zzzzzzzznzzXzzzzzzzzxzzkzzzzzzzzyzzwTzzzzzzzzzzy7zzzzzzzzzzz3zzzzzzzzzzzVzzzzzzzzzzzkzzzzzzzzzzzsTzzzzzzzzzzsDzzzzzzzzzzk7zzzzzzzzzy07zzzzzzzzzzU3zzzzzzzzzzsDzzzzy"


ConversationButton:="|<>*85$78.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzwQzzzzzzzzzzzxyzzzzzzzzzzztbTzzzzzzzzzzrbjzzzzzzzzzzjbrzzzzzzzzzzDbvzzzzzzzzzyz3xzzzzzzzzzxz3zzzzzzzzzztz3zzzzzzzzzzrz3zjzzzzzzzzjy1zzzzzzzzzzDw1zzzzzzzzzyTk0TxzzzzzzzwQ000wzzzzzzzsE000QTzzzyDlwM000wzzzzw7UyTk0DxzDlzw30TTw0zzy7Vzw10Djy1zrs30zy0E7rz3zzk20zz0E3nz3zzk00zzUA1xz3yz081zzk60yz3zy0E3zzs20STbzw0U7zzw1UDjbrs30Tzzy0k7rbzk20Tzzz0E3rzzUA1zzzzU81xyz0M3zzzzk40zDy0E7zzzzs20T3w1UDzzzzw10Dbs30Tzzzzw0U7zk60zzzzzy0E7zUA1zzzzzz083z0M3zzzzzzU41y0k7zzzzzzk20w1UDzzzzzzs10Q30Tzzzzzzw0UA60zzzzzzzy0E6A1zzzzzzzz083k3zzzzzzzzU41k7zzzzzzzzk20kDzzzzzzzzs10MTzzzzzzzzw0UBzzzzzzzzzy0E7zzzzzzzzzz087zzzzzzzzzzU4Dzzzzzzzzzzk2Tzzzzzzzzzzs1zzzzzzzzzzzw1zzzzzzzzzzzy3zzzzzzzzzzzz7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"


/**
 * 检测并触发交互
 * 如果在指定区域内检测到 F 按钮，则按 F 键
 * @return boolean 是否执行了交互
 */
TryInteract() {
    local FoundX := 0, FoundY := 0

    ; 使用 FindText 搜索 F 按钮
    if (FindText(&FoundX, &FoundY, InteractAreaLeft, InteractAreaTop, InteractAreaRight, InteractAreaBottom, 0, 0, FButton)) {
        ; 检测到 F 按钮，按 F 键
        GuiLogger.Log("检测到 F 按钮，按 F 键交互")
        Send("{f}")
        Sleep(200)
        GuiLogger.Log("已发送 F 键")
    } 

    ; 搜索对话按钮
    if (FindText(&FoundX, &FoundY, InteractAreaLeft, InteractAreaTop, InteractAreaRight, InteractAreaBottom, 0, 0, ConversationButton)) {
        GuiLogger.Log("检测到对话顶部星星，按 Space 键交互")
        Send("{space}")
        Sleep(200)
        Send("{1}")
        Sleep(200)
        Send("{2}")
        Sleep(200)
        Send("{3}")
        Sleep(200)
        GuiLogger.Log("已发送 Space 和 123 键")
    }

    return false
}