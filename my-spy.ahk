#Requires AutoHotkey v2.0

; --- 配置快捷键 ---
; 按住 F1 不放，鼠标移动到哪里，就复制哪里的坐标和颜色
F1::
    ; 获取当前鼠标坐标
    MouseGetPos &mx, &my
    
    ; 获取当前鼠标下的像素颜色
    pixelColor := PixelGetColor(mx, my)
    
    ; 格式化为代码中直接可用的格式
    ; 比如：Pos(100, 200), Color: 0x123456
    outputText := "Pos(" mx ", " my "), Color: " pixelColor
    
    ; 复制到剪贴板
    Clipboard := outputText
    
    ; 可选：显示一个短暂的提示（ToolTip），让你确认复制到了
    ToolTip "已复制: " outputText
    SetTimer () => ToolTip(), -1000 ; 1秒后消失
return