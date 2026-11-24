# lab1_and_or_gate

**与或门演示：AND-OR gate demo (switch + LED)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `and_or_gate`
- Project file: `lab1_and_or_gate.pds`

## 逻辑

```
f = (a & b) | (c & d)
```

## 端口与引脚

| Port | Dir | Pin | 说明 |
|------|-----|-----|------|
| a | input | K15 | 开关 |
| b | input | J14 | 开关 |
| c | input | J15 | 开关 |
| d | input | H13 | 开关 |
| f | output | F14 | LED |

## 真值表

| a | b | c | d | f |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | **0** |
| 0 | 0 | 0 | 1 | **0** |
| 0 | 0 | 1 | 0 | **0** |
| 0 | 0 | 1 | 1 | **1** |
| 0 | 1 | 0 | 0 | **0** |
| 0 | 1 | 0 | 1 | **0** |
| 0 | 1 | 1 | 0 | **0** |
| 0 | 1 | 1 | 1 | **1** |
| 1 | 0 | 0 | 0 | **0** |
| 1 | 0 | 0 | 1 | **0** |
| 1 | 0 | 1 | 0 | **0** |
| 1 | 0 | 1 | 1 | **1** |
| 1 | 1 | 0 | 0 | **1** |
| 1 | 1 | 0 | 1 | **1** |
| 1 | 1 | 1 | 0 | **1** |
| 1 | 1 | 1 | 1 | **1** |

ab 两个开关同时为 1，或者 cd 两个开关同时为 1，灯就亮。这是最典型的与或式（两个与项相或）。

## 实现说明

用 **一片 74LS00 的三个门** 按德摩根定律实现与或式：

```
t1 = ~(a & b)
t2 = ~(c & d)
f  = ~(t1 & t2)
```

工程源文件为 `rtl/and_or_gate.v` + `rtl/gate74LS00.v`，两个都已登记在 `.pds` 里。
第 4 个门未使用，输入已在代码中接地。

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
