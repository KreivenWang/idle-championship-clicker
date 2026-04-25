# FindText 库文档

## 概述

FindText 是一个强大的 AutoHotkey v2.0 图像识别库，可以将屏幕图像捕获为文本字符串，然后在屏幕上查找该图像。它支持多种查找模式，包括图像查找、多颜色查找、颜色查找和形状查找。

- **作者**: FeiYue
- **版本**: 10.2
- **更新日期**: 2026-02-22
- **项目地址**: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=116471
- **最低要求**: AutoHotkey v2.0.2+

## 快速开始

### 1. 引入库

将 `find-text.ahk` 保存到 AHK 的 `Lib` 子目录，然后在脚本开头添加：

```autohotkey
#Include <FindText>
```

或者直接复制 `find-text.ahk` 到你的脚本目录：

```autohotkey
#Include find-text.ahk
```

### 2. 基本使用

```autohotkey
; 获取 FindText 对象
ft := FindText()

; 查找图像
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text)
if (ok) {
    ; 找到图像，X 和 Y 是找到图像的中心坐标
    Click, %X%, %Y%
}
```

## 核心函数

### FindText()

主查找函数，用于在屏幕上查找图像。

#### 函数签名

```autohotkey
returnArray := FindText(
    &OutputX,        ; 存储返回的 X 坐标的变量引用
    &OutputY,        ; 存储返回的 Y 坐标的变量引用
    X1 := 0,         ; 搜索区域左上角 X 坐标
    Y1 := 0,         ; 搜索区域左上角 Y 坐标
    X2 := 0,         ; 搜索区域右下角 X 坐标
    Y2 := 0,         ; 搜索区域右下角 Y 坐标
    err1 := 0,       ; 前景容错百分比 (0.1=10%)
    err0 := 0,       ; 背景容错百分比 (0.1=10%)
    Text := "",      ; 图像文本字符串，多个用 '|' 分隔
    ScreenShot := 1, ; 是否截图 (0=使用上次截图)
    FindAll := 1,    ; 是否查找所有结果 (0=只找一个)
    JoinText := 0,   ; 是否组合查找 (1 或数组)
    offsetX := 20,   ; 组合查找时最大 X 偏移
    offsetY := 10,   ; 组合查找时最大 Y 偏移
    dir := 0,        ; 搜索方向 (0-8)
    zoomW := 1,      ; 图像宽度缩放比例 (1.0=100%)
    zoomH := 1       ; 图像高度缩放比例 (1.0=100%)
)
```

#### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `&OutputX` | 引用 | 必填 | 返回结果的 X 坐标。可设为 `'wait'`、`'wait1'`（等待出现）或 `'wait0'`（等待消失） |
| `&OutputY` | 引用 | 必填 | 返回结果的 Y 坐标。等待模式下为超时时间（秒），可加稳定时间：`"3,0.5"` |
| `X1, Y1` | 整数 | 0 | 搜索区域左上角坐标。全为 0 时搜索全屏幕 |
| `X2, Y2` | 整数 | 0 | 搜索区域右下角坐标 |
| `err1` | 浮点数 | 0 | 前景（图像主体）容错率，0.1 表示 10% |
| `err0` | 浮点数 | 0 | 背景容错率，0.1 表示 10% |
| `Text` | 字符串 | 必填 | 图像文本字符串，由捕获工具生成 |
| `ScreenShot` | 整数 | 1 | 是否重新截图，0 表示使用上次截图 |
| `FindAll` | 整数 | 1 | 是否查找所有匹配，0 表示找到第一个就返回 |
| `JoinText` | 整数/数组 | 0 | 组合查找模式，1 表示启用，或传入数组指定查找顺序 |
| `offsetX` | 整数 | 20 | 组合查找时相邻图像最大 X 偏移 |
| `offsetY` | 整数 | 10 | 组合查找时相邻图像最大 Y 偏移 |
| `dir` | 整数 | 0 | 搜索方向：0=中心优先，1=上，2=下，3=左，4=右，5=左上，6=右上，7=左下，8=右下 |
| `zoomW` | 浮点数 | 1 | 图像宽度缩放比例 |
| `zoomH` | 浮点数 | 1 | 图像高度缩放比例 |

#### 返回值

成功时返回数组，每个元素是一个对象，包含以下属性：

```autohotkey
{
    1: X,          ; 左上角 X 坐标
    2: Y,          ; 左上角 Y 坐标
    3: W,          ; 图像宽度
    4: H,          ; 图像高度
    x: X + W//2,   ; 中心 X 坐标
    y: Y + H//2,   ; 中心 Y 坐标
    id: "注释文本"  ; 图像注释（<> 中的内容）
}
```

失败时返回 `0`。

#### 等待模式

`OutputX` 可设置为等待模式：

- `"wait"` 或 `"wait1"`：等待图像出现
- `"wait0"`：等待图像消失
- `OutputY`：超时时间（秒），小于 0 表示无限等待
- 可添加稳定时间：`"超时时间, 稳定时间"`

```autohotkey
; 等待 3 秒直到图像出现
ok := FindText(&X:="wait", &Y:=3, 0, 0, 0, 0, 0, 0, Text)

; 无限等待直到图像消失
ok := FindText(&X:="wait0", &Y:=-1, 0, 0, 0, 0, 0, 0, Text)
```

### FindTextClass.New()

创建新的 FindText 实例。

```autohotkey
ft := FindTextClass.New()
```

### FindTextClass.help()

显示帮助信息。

```autohotkey
FindText().help()
```

## 查找模式

### 1. 标准图像查找

最基本的查找模式，使用捕获工具生成的文本字符串。

```autohotkey
Text := "|<注释>##DRDGDB$..."  ; 由捕获工具生成
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text)
```

### 2. 多颜色查找 (<FindMultiColor>)

查找多个颜色点及其相对位置。

```autohotkey
; 格式：|<>##DRDGDB$0/0/RRGGBB1-DRDGDB1/RRGGBB2,xn/yn/-RRGGBB3/RRGGBB4,...
Text := "|<>##101010$0/0/FF0000-050505/00FF00,10/20/-0000FF"
```

- `##` 后面的 `DRDGDB` 是默认颜色容差
- `0/0/` 表示起始点坐标
- `-` 表示排除该颜色

### 3. 颜色查找 (<FindColor>)

多颜色查找的特例，只有一个点。

```autohotkey
Text := "|<>##101010$0/0/FF0000"
```

### 4. 形状查找 (<FindShape>)

类似于多颜色查找，但使用是否与第一个点颜色相似来代替具体颜色。

```autohotkey
; 格式：|<>##DRDGDB$0/0/1,x1/y1/0,x2/y2/1,...
Text := "|<>##101010$0/0/1,10/10/0,20/20/1"
```

- `1` 表示与第一个点颜色相似
- `0` 表示与第一个点颜色不相似

### 5. 图片查找 (<FindPic>)

直接查找图片文件。

```autohotkey
; 格式：|<>##DRDGDB/RRGGBB1-DRDGDB1/RRGGBB2...$图片路径
Text := "|<>##101010/FFFFFF$D:\image.bmp"
```

- 支持 `HBITMAP:*` 句柄
- `##` 后面的颜色为透明色

## 颜色表示

所有颜色使用 RGB 格式：

- `RRGGBB`：十六进制颜色值，如 `FF0000`（红色）
- 可使用颜色名称：`Black`、`White`、`Red`、`Green`、`Blue`、`Yellow`
- `DRDGDB`：颜色容差，可使用相似度浮点数如 `1.0`（100%）

## 高级功能

### 组合查找 (JoinText)

查找多个图像的排列组合：

```autohotkey
; 按顺序查找多个图像
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text1 "|" Text2 "|" Text3
    , 1, 1, 1, 20, 10)

; 使用数组指定查找顺序
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text1 "|" Text2 "|" Text3
    , 1, 1, ["abc", "xyz"], 20, 10)
```

### 绑定窗口 (BindWindow)

绑定到后台窗口，实现后台图像查找。

```autohotkey
FindText().BindWindow(hwnd, mode)
```

**绑定模式**：

| 模式 | 说明 |
|------|------|
| 0 | 解绑窗口 |
| 1 | 使用 GetDCEx() 获取后台窗口图像 |
| 1+ | 使用 GetDCEx() 并支持透明 |
| 2 | 使用 PrintWindow() 获取后台窗口图像 |
| 2+ | 使用 PrintWindow() 并支持透明 |
| 3 | 使用 PrintWindow(,,3) 获取后台窗口图像 |

### 截图 (ScreenShot)

手动截取屏幕区域。

```autohotkey
FindText().ScreenShot(x1, y1, x2, y2)
```

## GUI 界面

FindText 提供图形界面用于捕获图像和测试查找：

```autohotkey
; 显示 GUI 界面
FindText().Gui("Show")

; 直接运行脚本（未编译时）
if (!A_IsCompiled && A_LineFile = A_ScriptFullPath)
    FindText().Gui("Show")
```

### GUI 功能

- **捕获图像**：将屏幕区域转换为文本字符串
- **测试查找**：测试生成的文本字符串是否能正确查找
- **颜色调整**：调整灰度、颜色容差等参数
- **保存/加载**：保存和加载截图

## 实用示例

### 示例 1：基本查找

```autohotkey
#Include <FindText>

; 查找并点击
if (ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text)) {
    Click, %X%, %Y%
}
```

### 示例 2：等待图像出现

```autohotkey
#Include <FindText>

; 等待 5 秒直到按钮出现，然后点击
if (ok := FindText(&X:="wait", &Y:=5, 0, 0, 0, 0, 0, 0, ButtonText)) {
    Click, %X%, %Y%
} else {
    MsgBox "按钮未在 5 秒内出现"
}
```

### 示例 3：查找所有匹配

```autohotkey
#Include <FindText>

; 查找屏幕上所有匹配的图像
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text, 1, 1)
if (ok) {
    For i, result in ok {
        MsgBox "找到第 " i " 个，位置: (" result.x ", " result.y ")"
    }
}
```

### 示例 4：组合查找

```autohotkey
#Include <FindText>

; 查找多个图像的组合
Text := Text1 "|" Text2 "|" Text3
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text, 1, 1, 1, 20, 10)
```

### 示例 5：后台窗口查找

```autohotkey
#Include <FindText>

; 绑定到游戏窗口
WinGetID hwnd, "ahk_exe IdleDragons.exe"
FindText().BindWindow(hwnd, 2)  ; 使用 PrintWindow 模式

; 在后台查找
ok := FindText(&X, &Y, 0, 0, 0, 0, 0, 0, Text)
```

## 注意事项

1. **坐标系统**：所有坐标相对于屏幕，颜色使用 RGB 格式
2. **容错率**：设置 `err1<0` 或 `err0<0` 可启用左右扩张算法，忽略文本行的轻微错位
3. **性能**：查找全屏幕时，建议设置合理的搜索区域以提高性能
4. **中文支持**：确保脚本文件使用 UTF-8 编码，避免中文注释乱码
5. **DPI 缩放**：高 DPI 设置可能影响查找精度，建议关闭 DPI 缩放或使用相对坐标

## 常见问题

### Q: 如何提高查找精度？

A: 降低容错率（`err1` 和 `err0`），或使用更精确的捕获区域。

### Q: 查找速度慢怎么办？

A: 
- 缩小搜索区域（设置 `X1, Y1, X2, Y2`）
- 使用 `ScreenShot=0` 复用上次截图
- 设置 `FindAll=0` 只找一个结果

### Q: 如何调试查找问题？

A: 使用 GUI 界面的测试功能，或显示截图进行调试：

```autohotkey
FindText().ScreenShot()
; 查看截图或保存截图分析
```

## 版本历史

- **10.2** (2026-02-22) - 当前版本
- 支持 AutoHotkey v2.0.2+
- 多种查找模式：图像、多颜色、颜色、形状、图片
- 支持后台窗口绑定
- 支持组合查找
- 支持等待模式

## 许可证

本库由 FeiYue 开发，遵循原项目的许可协议。详情请访问：
https://www.autohotkey.com/boards/viewtopic.php?f=83&t=116471
