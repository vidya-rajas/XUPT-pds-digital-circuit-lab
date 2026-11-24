# lab1_and_gate 实验使用说明

与门演示：`f = a & b`。纯组合逻辑，只用开关和 LED，不涉及时钟。

- 工程文件：`lab1_and_gate.pds`
- 顶层模块：`and_gate`（源码 `rtl/and_gate.v`，只有这一个文件）
- 器件：PGL22G / -6 / MBG324，IO 电平 `LVCMOS33`（VCCIO 3.3V）

## 一、上板步骤

1. 打开 PDS → File → Open Project → 选本目录的 `lab1_and_gate.pds`。
2. 左侧 Design Flow 依次点：Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 下载 `generate_bitstream/and_gate.sbit` 到板子。
4. 下载后若 LED 无反应，先确认开关拨到位，再核对 bank 供电电压（见 `PROJECT.md`「电平标准统一为 3.3V」）。

## 二、开关与灯

| 板载 | 引脚 | 信号 | 含义 |
|------|------|------|------|
| 开关 SW1（最左） | `K15` | `a` | 输入 a |
| 开关 SW2 | `J14` | `b` | 输入 b |
| LED1（最左） | `F14` | `f` | 输出，高电平点亮 |

其余开关、LED 在本工程里**没有约束**，拨动无效。

## 三、操作与现象

只拨 SW1 和 SW2，看最左边那颗 LED（F14）：

| a（SW1） | b（SW2） | f（LED1） |
|:---:|:---:|:---:|
| 0 | 0 | 灭 |
| 0 | 1 | 灭 |
| 1 | 0 | 灭 |
| 1 | 1 | **亮** |

一句话检验：**只有两个开关都置 1，灯才亮**。若出现"任一开关为 1 就亮"，说明烧错了工程（那是 `lab1_or_gate`）。

## 四、注意

- 与门由 74LS00 的两个门搭成：先 `~(a&b)`，再把结果反相。芯片第 3、4 个门接地未用。
- 组合逻辑无时钟、无复位，上电即生效，不需要按任何按键。
