# lab1_or_gate 实验使用说明

或门演示：`f = a | b`。纯组合逻辑，不涉及时钟。

- 工程文件：`lab1_or_gate.pds`
- 顶层模块：`or_gate`（源码 `rtl/or_gate.v`）
- 器件：PGL22G / -6 / MBG324，IO 电平 `LVCMOS33`（VCCIO 3.3V）

## 一、上板步骤

1. 打开 PDS → File → Open Project → 选本目录的 `lab1_or_gate.pds`。
2. Design Flow：Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 下载 `generate_bitstream/or_gate.sbit`。

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
| 1 | 1 | **亮** |

一句话检验：**只要有一个开关置 1，灯就亮**；只有两个都为 0 才灭。

## 四、注意

- 或门由一片 74LS00 的三个与非门实现（a、b 各自反相后再与非），第 4 个门接地未用。
- 无时钟、无复位，上电即工作。
