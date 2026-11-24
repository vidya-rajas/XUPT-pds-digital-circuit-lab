# lab1_and_or_gate 实验使用说明

与或门演示：`f = (a & b) | (c & d)`。纯组合逻辑，不涉及时钟。

- 工程文件：`lab1_and_or_gate.pds`
- 顶层模块：`and_or_gate`（源码 `rtl/and_or_gate.v`）
- 器件：PGL22G / -6 / MBG324，IO 电平 `LVCMOS33`（VCCIO 3.3V）

## 一、上板步骤

1. 打开 PDS → File → Open Project → 选本目录的 `lab1_and_or_gate.pds`。
2. Design Flow：Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 下载 `generate_bitstream/and_or_gate.sbit`。

## 二、开关与灯

四个开关分成两组，组内必须"与"、组间"或"。

| 板载 | 引脚 | 信号 | 含义 |
|------|------|------|------|
| 开关 SW1（最左） | `K15` | `a` | 第一组 |
| 开关 SW2 | `J14` | `b` | 第一组 |
| 开关 SW3 | `J15` | `c` | 第二组 |
| 开关 SW4 | `H13` | `d` | 第二组 |
| LED1（最左） | `F14` | `f` | 输出，高电平点亮 |

## 三、操作与现象

`a·b` 和 `c·d` 任一组成立，灯就亮；两组都不成立才灭。

| a | b | c | d | f |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 灭 |
| 1 | 1 | 0 | 0 | **亮** |
| 0 | 0 | 1 | 1 | **亮** |
| 1 | 1 | 1 | 1 | **亮** |
| 1 | 0 | 0 | 1 | 灭 |

最后一行是最容易看错的：**要每组两个都置 1**，只有 c 和 d 各一个是不够的。

## 四、注意

- 与或用一片 74LS00 的三个与非门实现（德摩根定律），第 4 个门接地未用。
- 无时钟、无复位，上电即工作。
