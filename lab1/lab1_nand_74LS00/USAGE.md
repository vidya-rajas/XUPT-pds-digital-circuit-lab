# lab1_nand_74LS00 实验使用说明

74LS00 芯片功能验证：一片四与非门，本工程用其中 3 个，输出分别接 3 颗 LED。

- 工程文件：`lab1_nand_74LS00.pds`
- 顶层模块：`nand_gate_check`（源码 `rtl/nand_gate_check.v`，门模型 `rtl/gate74LS00.v`）
- 器件：PGL22G / -6 / MBG324，IO 电平 `LVCMOS33`（VCCIO 3.3V）

## 一、上板步骤

1. 打开 PDS → File → Open Project → 选本目录的 `lab1_nand_74LS00.pds`。
2. Design Flow：Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 下载 `generate_bitstream/nand_gate_check.sbit`。

## 二、开关与灯

三个与非门各用两个开关，输出各占一颗灯：

| 门 | 输入 a | 输入 b | 输出 y | 灯位 |
|---|---|---|---|---|
| 门 1 | `a1` = `K15`（SW1 最左） | `b1` = `J14`（SW2） | `y1` = `J16` | LED6 |
| 门 2 | `a2` = `J15`（SW3） | `b2` = `H13`（SW4） | `y2` = `K18` | LED7 |
| 门 3 | `a3` = `H14`（SW5） | `b3` = `G13`（SW6 最右） | `y3` = `N15` | LED8 |

本工程用满全部 6 个开关，三颗灯从左到右分别是门 1、门 2、门 3。芯片第 4 个门未使用，其输入已在代码里接地。

## 三、操作与现象

每一组两个开关喂一个门，`y = ~(a & b)`：

| a | b | y（该门对应的灯） |
|:---:|:---:|:---:|
| 0 | 0 | **亮** |
| 0 | 1 | **亮** |
| 1 | 0 | **亮** |
| 1 | 1 | 灭 |

**与非门的特征：只有两个输入都是 1，灯才灭**，其余三种情况都亮。三组之间互不影响，可以同时验证。

## 四、验证清单

- [ ] 三颗灯都亮（六个开关全置 0）
- [ ] 拨动 SW1、SW2 中任意一个，LED6 仍亮
- [ ] SW1 与 SW2 同时置 1，LED6 灭
- [ ] 对 SW3/SW4 → LED7、SW5/SW6 → LED8 重复上述三步

## 五、注意

- 门模型 `gate74LS00.v` 是行为级描述，端口名 `A1/B1/Y1` 对应芯片内第 1 个门。
- 无时钟、无复位，上电即工作。
