#Requires AutoHotkey v2.0
DllCall("SetProcessDPIAware")

F12:: {
    CoordMode "Mouse", "Screen"  ; 确保鼠标坐标是相对于整个屏幕的
    MouseGetPos(&mouseX, &mouseY)
    MsgBox "当前鼠标位置: X=" mouseX ", Y=" mouseY ". 请将鼠标移到绿色按钮的左上角，然后按 F11 查看坐标。"
}