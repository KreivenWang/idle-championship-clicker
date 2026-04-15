; 功能：封装通用的快捷键操作

class HotkeyUtil {

    ; 全局变量，用于控制脚本启停
    static IsRunning := true

    ; --- 方法: 检查并返回是否正在运行 ---
    static IsPaused() {
        return !this.IsRunning
    }

    ; --- 方法: 设置 Pause 热键 ---
    static SetupPauseHotkey(label := "") {
        ; 使用 Hotkey 函数动态注册热键
        Hotkey "Pause", (*) => this.TogglePause(label)
    }

    ; --- 方法: 切换暂停状态 ---
    static TogglePause(label := "") {
        this.IsRunning := !this.IsRunning
        if (this.IsRunning) {
            ToolTip("脚本已恢复运行" (label ? " [" label "]" : ""))
        } else {
            ToolTip("脚本已暂停 (按 Pause 继续)" (label ? " [" label "]" : ""))
        }
        SetTimer(() => ToolTip(), -1500)
    }


    ; --- 方法: 设置 ScrollLock 退出脚本 ---
    static SetupScrollLockExit(label := "") {
        ; 按下 ScrollLock 时退出脚本
        Hotkey "ScrollLock", (*) => this.ExitByScrollLock(label)
    }

    ; --- 方法: 处理 ScrollLock 退出 ---
    static ExitByScrollLock(label := "") {
        ToolTip("按下 ScrollLock，脚本退出" (label ? " [" label "]" : ""))
        Sleep(500)
        ExitApp
    }
}