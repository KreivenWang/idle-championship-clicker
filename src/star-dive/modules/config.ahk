#Requires AutoHotkey v2.0

/**
 * Star Dive 配置模块
 * 包含所有可配置的参数和坐标
 */

; ==========================================
; 游戏窗口配置
; ==========================================

/**
 * 游戏窗口标题
 * 如果不确定，可以留空 ""，脚本会默认操作当前激活的窗口
 */
GameWindowTitle := "STAR DIVE"

; ==========================================
; 导航按钮配置
; ==========================================

/**
 * 导航按钮检测中心坐标
 */
NavigationButtonCenterX := 2436
NavigationButtonCenterY := 1148

/**
 * 导航按钮检测范围（中心点周围半径）
 */
NavigationButtonRadius := 100

/**
 * 导航按钮图片路径
 */
NavigationOnImage := "docs\navigation-on.png"
NavigationOffImage := "docs\navigation-off.png"

/**
 * 图像搜索容差
 */
NavigationImageVariance := 50

; ==========================================
; 交互配置
; ==========================================

/**
 * 交互项列表
 * 每个交互项包含：
 *   - Text: FindText 特征文本
 *   - AnchorX, AnchorY: 坐标锚点
 *   - RangeX, RangeY: 搜索矩形范围半径
 *   - Action: 检测到后执行的操作（按键序列或鼠标点击）
 *     - Key: 按键（如 "{f}", "{space}"）
 *     - Click: 是否点击鼠标（true/false）
 *     - Delay: 操作后延迟（毫秒）
 */
InteractItems := [{
    Text: "|<>*60$36.zzzzzyzzzzzyz0000zw0000Ds00007szzzz7lzzzzXlz00zXlz00TXlz00TXlz00TXlz00zXlz1zzXlz1zzXlz1zzXlz1zzXlz00zXlz00zXlz00zXlz00zXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlz1zzXlzzzzXszzzz7s00007w0000DT0000yDzzzzw7zzzzsU",
    left: 1280 - 150000,
    top: 1090 - 150000,
    right: 1280 + 150000,
    bottom: 1090 + 150000,
    Action: [{ Key: "{f}", Delay: 10 }
    ],
    LogMsg: "交互：F"
}, {
    Text: "|<>*100$46.zzzwzzzzzzznzzzzzzyrzzzzzzrjzzzzzynTzzzzzrCzzzzzywxzzzzzrnvzzzzyzDrzzzzrsTjzzzyy0TTzzzm00CzzbbC01nzwADzVzSSEERy7vkkUUvwzS2711rnvkEy23jDS67w47Qvkkzs8CzS67zkERvkkzzUUsS67zz11nkkzzy23y47zzw47Ukzzzs8A47zzzkEEUzzzzUUY7zzzz11Uzzzzy227zzzzw44zzzzzs8DzzzzzkEzzzzzzUbzzzzzz1zzzzzzy7zzzzzzwzzzy",
    left: 2266 - 150000,
    top: 128 - 150000,
    right: 2266 + 150000,
    bottom: 128 + 150000,
    Action: [{ Key: "{space}", Delay: 10 }, { Key: "{1}", Delay: 10 }, { Key: "{2}", Delay: 10 }, { Key: "{3}", Delay: 10 }],
    LogMsg: "对话：点击箭头并按 123 键交互"
}, {
    Text: "|<>FECF64-323232$148.zzUTzzzzzzzzzwTzsTzyDz7zzzy1zzzU0700Dz0zz0zzsDsDzzzs7zzy00800Ty1zw3zz0z0DzzzUTzzs00U01zs7zUTzs7y0Dzzy1zzzU02007zkDy3zz0zw0Tzzs7zzy00800S000007k7zw1z00000DsTUUS1s00000S0zzsDw00000zVy21s7U00001k7s000k00003y7s87US000007UtU00100000Ds00US1s00000S70000400000zU021s7zzzzzzws0000Tzzzzzy0087UTzzzzsTz0U001znzwTzs00US1y00C71zw3zUTzsDzkTzVy21s7s00sA7zUTy1zzUzy1zy7s87UTU03UkTw3zs7zy1zs7zsTUUS1y00C31z0DzUTzw7zUTzU021s7sTUsA7s0zy1zzkTy3zy0087UTVy3UkT03zs7zz0zsDzs00US1y00C31w0D000Dy3z0zzU021s7s00sA7s0w000zsDw3zy08M7UTU03UkTW3k003zUzkTzsTDUS1y00C31zMD000Dy3z1zzVky1s7sTUsA7zUw000zs7s7zy71s7UTVy3UkTy3zs7zzkTUzzsQ3US1y00C31zsDzUTzz1y3zzVsC007s00sA7zUzy1zzw7kDzy60M40zU03UkTy3zs7zzlz1zzs00UE3y00C31zsDzUTzzzw7zy00210TsTUzw7zUzy1zk00001k00863zVy3zkTy3zs7z0000030000Tzy7sDz1zsA000000000C0D01zzsM0y07zUk000000000sDwM7zzVk3w0Ty30000000007bzvUTzy70Tk1zsA0003zzzzzzzzy1zzsQ1zUTzUzzzzzzzzzzzzzwDzzzzzzzzz3zzzzU",
    left: 1240,
    top: 1325,
    right: 1325,
    bottom: 1405,
    Action: [{ Click: true, Delay: 100 }, { Key: "{space}" },],
    LogMsg: "立即前往, 1s, 确认"
}, {
    Text: "|<>#449-0.68$73.01zzzzzzzzk007zzzzzzzzz00Dk00000007s0D000000000S0D3zzzzzzzy7UC7zzzzzzzzksCDzzzzzzzzyC6DzzzzzzzzzX7Ds7zzzzzzztn7s1zzzzzzzwNbsMTzzzzzzzBrwCDzzzzzzzbny7w0w3kD0zttzUS0A0k30Dwwzs334AMkXXySTz0VVw8M01zDDzsFkU4Dk0zbbwC8s1W7sLznvz64AEVX0ADngzU2080E10DtaTs30C0A1kDsnbzzXzzzzzzwslzzlzzzzzzwMQTzzzzzzzzwQ73zzzzzzzzsQ1sTzzzzzzzkw0T000000000w07s00000003w00zzzzzzzzzs003zzzzzzzzU0U",
    left: 1280 - 150000,
    top: 1090 - 150000,
    right: 1280 + 150000,
    bottom: 1090 + 150000,
    Action: [{ Key: "{space}" },],
    LogMsg: "确认/前往：space"
}
]

; ==========================================
; 扫描频率配置
; ==========================================

/**
 * 检测频率（毫秒）
 * 每多少毫秒扫描一次屏幕
 */
ScanInterval := 1000

; ==========================================
; 坐标计算辅助函数
; ==========================================

/**
 * 获取导航按钮检测区域
 * @return Array [left, top, right, bottom]
 */
GetNavigationSearchRegion() {
    local left := NavigationButtonCenterX - NavigationButtonRadius
    local top := NavigationButtonCenterY - NavigationButtonRadius
    local right := NavigationButtonCenterX + NavigationButtonRadius
    local bottom := NavigationButtonCenterY + NavigationButtonRadius
    return [left, top, right, bottom]
}