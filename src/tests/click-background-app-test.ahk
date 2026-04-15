#Requires AutoHotkey v2.0

; ==========================================
; ⚙️ 配置区域
; ==========================================

GameWindowTitle := "Idle Champions"  ; 游戏窗口标题
GameWindowClass := "UnityWndClass"    ; Unity 游戏窗口类名
TestX := 280                          ; 测试点击 X 坐标
TestY := 1384                         ; 测试点击 Y 坐标
ClickCount := 0                       ; 点击计数器
FailCount := 0                        ; 失败计数器

; ==========================================
; 🚀 主逻辑
; ==========================================

;!!! Idle Champions 是 Unity 引擎游戏，可能不支持标准的 ControlClick
; 多种方式查找窗口
GameWin := WinExist("ahk_exe IdleDragons.exe")
if !GameWin {
    GameWin := WinExist("ahk_class UnityWndClass")
}
if !GameWin {
    GameWin := WinExist(GameWindowTitle)
}

if !GameWin {
    MsgBox "未找到游戏窗口`n请确保游戏已启动！", "错误", 16
    ExitApp
}

; 获取窗口信息
WinGetTitle := WinGetTitle(GameWin)
WinGetClass := WinGetClass(GameWin)
WinGetPos := WinGetPos(GameWin)

; 创建测试 GUI
TestGUI := Gui("", "后台点击测试")
TestGUI.MarginX := 20
TestGUI.MarginY := 20

TestGUI.Add("Text", "w350", "窗口标题: " WinGetTitle)
TestGUI.Add("Text", "w350 y+5", "窗口类: " WinGetClass)
TestGUI.Add("Text", "w350 y+5", "窗口位置: " WinGetPos.X ", " WinGetPos.Y " (大小: " WinGetPos.W "x" WinGetPos.H ")")
TestGUI.Add("Text", "w350 y+5", "测试坐标: " TestX ", " TestY " (相对于窗口左上角)")
ClickCountText := TestGUI.Add("Text", "w350 y+5", "成功: 0 | 失败: 0")

; 添加不同的点击方式按钮
TestGUI.Add("Text", "w350 y+15", "--- 选择点击方式 ---")

Method1Btn := TestGUI.Add("Button", "w150 y+10", "方式1: ControlClick")
Method2Btn := TestGUI.Add("Button", "w150 x+10 yp", "方式2: PostMessage")
Method3Btn := TestGUI.Add("Button", "w150 x+10 yp", "方式3: 前台点击")

StopBtn := TestGUI.Add("Button", "w100 y+20", "停止")
ExitBtn := TestGUI.Add("Button", "w100 x+10 yp", "退出")

g_IsRunning := false
g_ClickMethod := 1  ; 1=ControlClick, 2=PostMessage, 3=前台点击

Method1Btn.OnEvent("Click", (*) => StartTest(1))
Method2Btn.OnEvent("Click", (*) => StartTest(2))
Method3Btn.OnEvent("Click", (*) => StartTest(3))
StopBtn.OnEvent("Click", (*) => StopClicking())
ExitBtn.OnEvent("Click", (*) => ExitApp)

TestGUI.Show()

; 开始测试
StartTest(method) {
    global g_IsRunning, g_ClickMethod
    g_ClickMethod := method
    g_IsRunning := true
    
    methodNames := ["ControlClick", "PostMessage", "前台点击"]
    ClickCountText.Text := "使用方式: " methodNames[method] " | 成功: 0 | 失败: 0"
    
    SetTimer(ClickLoop, 1000)
}

StopClicking() {
    global g_IsRunning
    g_IsRunning := false
    SetTimer(ClickLoop, 0)
    ClickCountText.Text := "已停止 | 成功: " ClickCount " | 失败: " FailCount
}

; 点击循环
ClickLoop() {
    global g_IsRunning, g_ClickMethod
    
    if (!g_IsRunning)
        return
    
    if (g_ClickMethod = 1)
        ClickButton_ControlClick(TestX, TestY)
    else if (g_ClickMethod = 2)
        ClickButton_PostMessage(TestX, TestY)
    else if (g_ClickMethod = 3)
        ClickButton_Foreground(TestX, TestY)
}

; 方式1: ControlClick
ClickButton_ControlClick(x, y) {
    global ClickCount, FailCount
    
    ; 尝试不使用 Pos 选项（默认使用窗口坐标）
    Result := ControlClick("x" x " y" y, GameWin, , , 1, "NA")
    
    if (Result)
        ClickCount++
    else
        FailCount++
    
    ClickCountText.Text := "方式: ControlClick | 成功: " ClickCount " | 失败: " FailCount
}

; 方式2: PostMessage (WM_LBUTTONDOWN + WM_LBUTTONUP)
ClickButton_PostMessage(x, y) {
    global ClickCount, FailCount
    
    ; WM_LBUTTONDOWN = 0x0201
    ; WM_LBUTTONUP = 0x0202
    ; MK_LBUTTON = 0x0001 (表示鼠标左键按下状态)
    lParam := (y << 16) | (x & 0xFFFF)
    
    try {
        PostMessage(0x0201, 1, lParam, , GameWin)  ; 按下
        PostMessage(0x0202, 0, lParam, , GameWin)  ; 释放
        ClickCount++
    } catch as Error {
        FailCount++
    }
    
    ClickCountText.Text := "方式: PostMessage | 成功: " ClickCount " | 失败: " FailCount
}

; 方式3: 前台点击 (需要激活窗口)
ClickButton_Foreground(x, y) {
    global ClickCount, FailCount
    
    try {
        WinActivate(GameWin)
        Sleep(200)
        
        ; 获取窗口位置，计算屏幕绝对坐标
        WinPos := WinGetPos(GameWin)
        screenX := WinPos.X + x
        screenY := WinPos.Y + y
        
        Click(screenX, screenY)
        ClickCount++
    } catch as Error {
        FailCount++
    }
    
    ClickCountText.Text := "方式: 前台点击 | 成功: " ClickCount " | 失败: " FailCount
}

; GUI 关闭时退出
TestGUI.OnEvent("Close", (*) => ExitApp)