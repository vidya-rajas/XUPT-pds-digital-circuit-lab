# lab1_xor_gate 实验使用说明

异或门演示：`f = a ^ b`。纯组合逻辑，不涉及时钟。

- 工程文件：`lab1_xor_gate.pds`
- 顶层模块：`xor_gate`（源码 `rtl/xor_gate.v`）
- 器件：PGL22G / -6 / MBG324，IO 电平 `LVCMOS33`（VCCIO 3.3V）

## 一、上板步骤

1. 打开 PDS → File → Open Project → 选本目录的 `lab1_xor_gate.pds`。
2. Design Flow：Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 下载 `generate_bitstream/xor_gate.sbit`。

## 二、开关与灯

| 板载 | 引脚 | 信号 | 含义 |
|------|------|------|------|
| 开关 SW1（最左） | `K15` | `a` | 输入 a |
| 开关 SW2 | `J14` | `b` | 输入 b |
| LED1（最左） | `F14` | `f` | 输出，高电平点亮 |

## 三、操作与现象

| a（SW1） | b（SW2） | f（LED1） |
|:---:|:---:|:---:|
| 0 | 0 | 灭 |
| 0 | 1 | **亮** |
| 1 | 0 | **亮** |
| 1 | 1 | 灭 |

一句话检验：**两个开关不一样时灯亮，一样时灭**。这是与门/或门都没有的特征，可用来区分是否烧对了工程。

## 四、注意

- 异或由一片 74LS00 的四个与非门实现，四个门全部用完，没有空余。
- 无时钟、无复位，上电即工作。
