; 文件名: WindowUtils.ahk
; 功能：封装窗口操作的通用方法

class WindowUtils {
    ; 静态变量，用于存储当前找到的窗口句柄
    static CurrentHwnd := 0

    ; --- 方法 1: 检查并激活窗口 ---
    ; 如果窗口最小化，会自动还原；如果不存在，会尝试运行程序
    static EnsureActive(winTitle, runPath := "") {
        ; 1. 检查窗口是否存在
        if WinExist(winTitle) {
            this.CurrentHwnd := WinExist(winTitle)
            
            ; 2. 检查是否最小化 (-1 代表最小化)
            if WinGetMinMax(this.CurrentHwnd) = -1 {
                WinRestore(this.CurrentHwnd)
            }
            
            ; 3. 激活窗口
            WinActivate(this.CurrentHwnd)
            WinWaitActive(this.CurrentHwnd) ; 等待窗口激活，防止操作过快
            return true
        } else {
            ; 窗口不存在
            if (runPath != "") {
                Run(runPath) ; 尝试启动程序
                ; 等待程序启动并出现窗口 (最多等10秒)
                if WinWait(winTitle, , 10) {
                    this.CurrentHwnd := WinExist(winTitle)
                    return true
                }
            }
            return false ; 既没找到也没启动成功
        }
    }

    ; --- 方法 2: 检查窗口是否仅仅是“存在” (不激活) ---
    static Exists(winTitle) {
        return WinExist(winTitle) ? true : false
    }

    ; --- 方法 3: 获取窗口位置 (用于坐标校准) ---
    static GetPosition(winTitle) {
        WinGetPos &x, &y, &w, &h, winTitle
        return {x: x, y: y, w: w, h: h}
    }
}