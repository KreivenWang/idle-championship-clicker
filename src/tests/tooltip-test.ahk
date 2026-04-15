#Requires AutoHotkey v2.0

; 这是一个注释
; 按下 Ctrl + Alt + H 弹出提示框
^!h:: {
    ; MsgBox("环境配置成功！Hello AHK v2!")
    ToolTip("环境配置成功！Hello AHK v2!")
    SetTimer(() => ToolTip(), -2000) ; 2秒后自动隐藏
}