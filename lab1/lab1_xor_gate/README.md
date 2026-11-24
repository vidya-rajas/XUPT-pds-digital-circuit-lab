# lab1_xor_gate

**异或门演示：XOR gate demo (switch + LED)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `xor_gate`
- Project file: `lab1_xor_gate.pds`

## 逻辑

```
f = a ^ b
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
| 1 | 1 | **0** |

两个开关状态不同（一个 0 一个 1）时灯亮，相同时灯灭。

## 实现说明

异或用 **一片 74LS00 的四个门** 按经典与非接法实现：

```
n1 = ~(a & b)
n2 = ~(a & n1)
n3 = ~(b & n1)
f  = ~(n2 & n3)
```

工程源文件为 `rtl/xor_gate.v` + `rtl/gate74LS00.v`，两个都已登记在 `.pds` 里。
四个门全部用完，没有空余。

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
