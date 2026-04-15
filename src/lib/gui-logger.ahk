; 文件名: gui-logger.ahk
; 功能: GUI 日志窗口类

class GuiLogger {
    static Gui := 0
    static LogText := 0
    static StatusText := 0

    ; --- 方法: 初始化日志窗口 ---
    static Init(title := "日志窗口", width := 500, height := 300) {
        this.Gui := Gui("", title)
        this.Gui.MarginX := 10
        this.Gui.MarginY := 10
        this.Gui.SetFont("s10", "Consolas")

        this.LogText := this.Gui.Add("Edit", "w" width " h" height " ReadOnly VScroll", "")
        this.StatusText := this.Gui.Add("Text", "w" width, "状态: 运行中")

        this.Gui.OnEvent("Close", (*) => ExitApp)
        this.Gui.Show()

        this.Log("日志窗口已初始化")
    }

    ; --- 方法: 写入日志 ---
    static Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        logLine := timestamp " - " msg

        ; 追加到编辑框
        this.LogText.Value .= logLine "`n"

        ; 自动滚动到底部
        SendMessage(0xB1, -1, -1, this.LogText)  ; EM_SETSEL
        SendMessage(0xB7, 0, 0, this.LogText)    ; EM_SCROLLCARET
    }

    ; --- 方法: 更新状态 ---
    static UpdateStatus(msg) {
        this.StatusText.Text := "状态: " msg
    }
}
