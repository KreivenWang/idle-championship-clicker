; 功能：封装通用的颜色处理方法

class ColorUtil {

    ; 简单的颜色容差比较函数
    static ColorsMatch(c1, c2, variance) {
        r1 := (c1 >> 16) & 0xFF
        g1 := (c1 >> 8) & 0xFF
        b1 := c1 & 0xFF

        r2 := (c2 >> 16) & 0xFF
        g2 := (c2 >> 8) & 0xFF
        b2 := c2 & 0xFF

        return (Abs(r1 - r2) <= variance && Abs(g1 - g2) <= variance && Abs(b1 - b2) <= variance)
    }
}