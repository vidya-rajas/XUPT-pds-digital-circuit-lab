# lab1_and_gate

**与门演示：AND gate demo (switch + LED)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `and_gate`
- Project file: `lab1_and_gate.pds`

## 逻辑

```
f = a & b
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
| 0 | 1 | **0** |
| 1 | 0 | **0** |
| 1 | 1 | **1** |

两个开关都拨到 1 灯才亮，其余情况灯灭。

## 实现说明

课程包中没有 74LS08（与门）模型，因此用 **74LS00 与非门** 搭出与门：

```
n1 = ~(a & b)      第 1 个门
f  = ~(n1 & n1)    第 2 个门，把 n1 反相
```

工程源文件为 `rtl/and_gate.v` + `rtl/gate74LS00.v`，两个都已登记在 `.pds` 里。
芯片第 3、4 个门未使用，输入已在代码中接地。

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
