# lab1_or_gate

**或门演示：OR gate demo (switch + LED)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `or_gate`
- Project file: `lab1_or_gate.pds`

## 逻辑

```
f = a | b
```

## 端口与引脚

| Port | Dir | Pin | 说明 |
|------|-----|-----|------|
| a | input | K15 | 开关 |
| b | input | J14 | 开关 |
| f | output | F14 | LED |

## 真值表

| a | b | f |
|---|---|---|
| 0 | 0 | **0** |
| 0 | 1 | **1** |
| 1 | 0 | **1** |
| 1 | 1 | **1** |

两个开关任意一个拨到 1，灯就亮；只有都拨到 0 时灯灭。

## 实现说明

课程包中没有 74LS32（或门）模型，因此用 **74LS00 与非门** 按德摩根定律搭出或门：

```
na = ~(a & a)      a 反相
nb = ~(b & b)      b 反相
f  = ~(na & nb)    = a | b
```

工程源文件为 `rtl/or_gate.v` + `rtl/gate74LS00.v`，两个都已登记在 `.pds` 里。
第 4 个门未使用，输入已在代码中接地。

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
