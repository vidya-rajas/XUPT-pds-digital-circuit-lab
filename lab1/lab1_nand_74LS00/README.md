# lab1_nand_74LS00

**74LS00 功能验证（开关手动脉冲 + LED）**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `nand_gate_check`
- Project file: `lab1_nand_74LS00.pds`
- 输入：全是开关　输出：全是 LED　无时钟

## 端口与引脚

| Port | Dir | Pin | 说明 |
|------|-----|-----|------|
| a1 | input | K15 | 开关 1（最左）：门 1 的 A |
| b1 | input | J14 | 开关 2：门 1 的 B |
| a2 | input | J15 | 开关 3：门 2 的 A |
| b2 | input | H13 | 开关 4：门 2 的 B |
| a3 | input | H14 | 开关 5：门 3 的 A |
| b3 | input | G13 | 开关 6（最右）：门 3 的 B |
| y1 | output | J16 | LED 6：门 1 输出 |
| y2 | output | K18 | LED 7：门 2 输出 |
| y3 | output | N15 | LED 8（最右）：门 3 输出 |

板子上开关从左到右：`K15 J14 J15 H13 H14 G13`
LED 从左到右：`F14 F13 F16 G16 H16 J16 K18 N15`

## 真值表

74LS00 是四路二输入与非门，每一路的逻辑都是 `Y = (A·B)'`：

| A | B | Y |
|---|---|---|
| 0 | 0 | **1** |
| 0 | 1 | **1** |
| 1 | 0 | **1** |
| 1 | 1 | **0** |

三个门同时验证：任意一行只要三个灯状态一致（且符合上表），就说明三个门都正常。

## 当脉冲用

把每一组的 `A` 当**手动脉冲**、`B` 当**控制端**：

- `B = 1`：`Y = A'`，拨动 `A` 开关（手动脉冲），对应的灯**跟着反相闪**，
  说明脉冲能通过这个门并被反相 —— 这是"门电路对脉冲的传输"。
- `B = 0`：`Y` 恒为 1，怎么拨 `A` 灯都不动 —— 脉冲被这个门**封锁**了。

所以一行真值表就能同时看出"传输"和"封锁"两种现象。

## 为什么只有 3 个门

74LS00 一片里有 4 个二输入与非门、8 个输入，但板上只有 6 个开关，
所以这里用 6 个开关独立验证前 3 个门，第 4 个门的 `A4/B4` 接 0（输出固定为 1、不接灯）。

如果要把第 4 个门也验证上，把它的 `A4`、`B4` 并联到任意一组的 `a/b` 上
（改 `rtl/nand_gate_check.v` 里 `.A4(1'b0), .B4(1'b0)` 这两句），两个灯应当始终同步变化。

## 实现说明

- 门电路模型用的是第 1 次实验课给的 `gate74LS00.v`（四路与非门，行为级 `assign` 描述），已去注释。
- 顶层只例化一片 `gate74LS00`，没有其它器件。

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。

## 目录说明

```
lab1_nand_74LS00/
  lab1_nand_74LS00.pds
  rtl/nand_gate_check.v            顶层（例化一片 74LS00）
  rtl/gate74LS00.v     四路二输入与非门模型
  constr/*.fdc         引脚约束
```
