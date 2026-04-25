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
    AnchorX: 1280,
    AnchorY: 1090,
    RangeX: 150000,
    RangeY: 150000,
    Action: [{ Key: "{f}", Delay: 200 }
    ],
    LogMsg: "检测到 F 按钮，按 F 键交互"
}, {
    Text:"|<>*210$44.zzztzzzzzzyTzzzzzzbzzzzzzUTzzzzzU1zzwxzz3zzz7Dztzzj8tzyTznX7Dzbzllstzzzssz7DzzwQTstzzyCDz7Dzz77zstzzXXzz7Dzllzzstzsszzz7DwQzzzstyCTzzz7DDDzzzstzbzzzz7DXzzzzsttzzzzz7Dzzzzzsszzzzzz7Dzzzzzszzzzzzz7zzzzzztzzzs",
    AnchorX: 1280,
    AnchorY: 1367,
    RangeX: 200,
    RangeY: 200,
    Action: [{ Click: true, Delay: 200 }, { Key: "{1}", Delay: 200 }, { Key: "{2}", Delay: 200 }, { Key: "{3}", Delay: 200 }
    ],
    LogMsg: "检测到对话顶部星星，点击箭头并按 123 键交互"
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