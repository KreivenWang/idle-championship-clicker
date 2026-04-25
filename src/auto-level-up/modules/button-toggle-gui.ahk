#Requires AutoHotkey v2.0

/**
 * 按钮开关 GUI 模块
 * 为每个按钮坐标创建一个 checkbox，让用户可以实时控制是否点击该坐标
 */

/**
 * 全局变量：存储所有 checkbox 控件
 */
Global ButtonCheckboxes := []

/**
 * 创建按钮开关 GUI 界面
 * @param buttonCoords 按钮坐标数组（引用传递）
 * @param title GUI 窗口标题
 * @return Gui 对象
 */
CreateButtonToggleGUI(&buttonCoords, title := "按钮开关控制") {
    global ButtonCheckboxes
    
    ; 创建 GUI
    toggleGui := Gui("+AlwaysOnTop", title)
    
    ; 添加说明文本
    toggleGui.AddText("", "勾选表示启用该按钮的自动点击，取消勾选则跳过该按钮")
    toggleGui.AddText("", "----------------------------------------")
    
    ; 为每个按钮坐标创建 checkbox
    for Index, Coord in buttonCoords {
        ; 根据 Coord[3] 判断是否选中
        checked := (Coord.Length >= 3 && Coord[3]) ? " Checked" : ""
        ; 创建 checkbox（显示为 #0-#12）
        cb := toggleGui.AddCheckbox("w200" checked, "按钮 #" Index - 1)
        ; 绑定事件，当 checkbox 状态改变时更新 buttonCoords
        cb.OnEvent("Click", ButtonCheckboxChanged)
        ButtonCheckboxes.Push({gui: cb, index: Index, coords: buttonCoords})
    }
    
    ; 添加操作按钮
    toggleGui.AddButton("w100", "全选").OnEvent("Click", SelectAllButtons)
    toggleGui.AddButton("w100", "取消全选").OnEvent("Click", DeselectAllButtons)
    
    ; 显示 GUI
    toggleGui.Show("AutoSize")
    
    return toggleGui
}

/**
 * checkbox 状态改变事件处理
 */
ButtonCheckboxChanged(ctrl, info) {
    global ButtonCheckboxes
    
    ; 查找对应的按钮索引
    for item in ButtonCheckboxes {
        if (item.gui = ctrl) {
            index := item.index
            coords := item.coords
            ; 更新 buttonCoords 中的 flag
            if (coords[index].Length >= 3) {
                coords[index][3] := ctrl.Value
            }
            break
        }
    }
}

/**
 * 全选按钮
 */
SelectAllButtons(*) {
    global ButtonCheckboxes
    
    for item in ButtonCheckboxes {
        item.gui.Value := true
        ; 更新 buttonCoords 中的 flag
        if (item.coords[item.index].Length >= 3) {
            item.coords[item.index][3] := true
        }
    }
}

/**
 * 取消全选按钮
 */
DeselectAllButtons(*) {
    global ButtonCheckboxes
    
    for item in ButtonCheckboxes {
        item.gui.Value := false
        ; 更新 buttonCoords 中的 flag
        if (item.coords[item.index].Length >= 3) {
            item.coords[item.index][3] := false
        }
    }
}

/**
 * 检查指定索引的按钮是否启用
 * @param index 按钮索引（从 1 开始）
 * @return true=启用，false=禁用
 */
IsButtonEnabled(index) {
    global ButtonCheckboxes
    
    if (index < 1 || index > ButtonCheckboxes.Length) {
        return false
    }
    
    ; 返回 checkbox 的选中状态
    return ButtonCheckboxes[index].gui.Value
}
