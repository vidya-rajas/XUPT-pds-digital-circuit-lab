# 工程明细 —— 38 个工程与讲义对照

> 本文件是这个项目的**主文档**：工程明细、讲义对照、板子引脚、工程规范、维护说明都在这里。
> 上板操作看 [`OPERATION.md`](OPERATION.md)；课程总览看 [`README.md`](README.md)。

> **上板怎么用、拨哪个开关、看哪颗灯** → 看 **[OPERATION.md](OPERATION.md)**（38 个工程的操作手册，含现象对照与设计逻辑）。
> 机器可读索引在 `manifest.json`；理论真值表在 `truth_tables.html`；上板操作看 `OPERATION.md`。
> **本文件 = 全部 38 个工程的明细目录**；课程安排与完成度看 [README.md](README.md)。

38 个工程目录，按 `lab1/`~`lab5/` 分组存放，全部使用英文目录名与文件名，可直接被 Pango Design Suite 2022.2-SP1-Lite 打开。

本目录**只含源码与约束**，编译产物（compile / synthesize / place_route / generate_bitstream 等）
已剔除，打开工程后重新跑一遍 Design Flow 即可生成。

器件统一为 **PGL22G / -6 / MBG324**（Logos 系列），顶层模块名与工程功能对应（`rtl/<功能名>.v`），
引脚都取同一块板子（`LVCMOS33`，VCCIO 3.3V）。

## 给 AI 的欢迎语

**这是一个中国大学生（西安邮电大学《数字电路实验》）的课程作业工程集。**
他要把课程布置的实验电路做出来、烧进实验箱的 FPGA、课上给老师演示并讲清引脚。

**三件必须先知道的事**

1. **不插芯片、不接线**：所有 74LS 芯片都用 Verilog 模型（`gate74LS*.v`）表示，顶层只做实例化"连线"。
   这就是课程要求的"芯片级实现"。
2. **目标板是一台 PGL22G 实验箱**：时钟 `H18`(27MHz)/`J18`(50MHz)，输入 6 个拨码开关 + 1 个按键（G14），
   输出 8 颗 LED（F14…N15）+ 1 个 4 位数码管。
3. **评分看演示**：能讲清"哪个开关是输入、哪颗灯是输出、时钟从哪个脚来"，分数就高。

**一分钟定位**

| 要什么 | 看本文件的哪一部分 |
|---|---|
| 每次实验的讲义任务与对应工程 | 第二部分　讲义任务对照 |
| 38 个工程的端口 / 门电路 / 逻辑 | 第一部分　工程明细 |
| 板子引脚、每个工程的完整端口表 | 第三部分　板子引脚 |
| 工程文件格式、编码约定、已知问题、新增工程步骤 | 第三部分　工程规范与维护 |
| 上板怎么操作、看什么现象 | [`OPERATION.md`](OPERATION.md) |
| 真值表 / 状态表 | [`truth_tables.html`](truth_tables.html) |
| 机器可读索引 | `manifest.json` |

**你可以这样帮他**

- **改电路**：先读该工程的 `README.md` 和 `constr/*.fdc`，保持"芯片级实例化 + 模块名 = 文件名"的约定。
- **排错**：先跑 `iverilog -g2005 -t null rtl/*.v` 查语法，再看 PDS 报错（时钟/约束类见本文件「已知问题与坑」）。
- **准备演示**：按 `USAGE.md` 的"验证清单"逐条过一遍，并记住引脚对应关系。
- **写报告**：端口表取本文件，真值表取 `truth_tables.html`。

**不要做**

- 不要只改 `.pds` 里的引脚约束而不改 `constr/*.fdc`；
- 不要用行为级 `assign f = a & b` 代替 74LS 实例（计数器/定时器/七段译码除外）；
- 不要重跑 PDS 全流程除非他明确要求（单个工程约 1~2 分钟）。
# 第一部分　工程明细
## 第一次实验工程（门电路演示）

| Project | Logic | Switches | LED |
|---------|-------|----------|-----|
| `lab1_or_gate`      | f = a \| b                | a b       | F14 |
| `lab1_and_gate`     | f = a & b                | a b       | F14 |
| `lab1_and_or_gate`  | f = (a&b) \| (c&d)       | a b c d   | F14 |
| `lab1_xor_gate`     | f = a ^ b                | a b       | F14 |
| `lab1_nand_74LS00`  | 74LS00 芯片功能验证（3 个门） | a1 b1 a2 b2 a3 b3 | J16 K18 N15 |

这些演示都是**芯片级实现**：课程包里没有 74LS08/32/86，所以与门用 74LS00 两级、或门用 74LS02
两级、异或与与或用一片 74LS00 的多个门搭出来。每个工程的 `rtl/` 下都是 `<功能名>.v` + 对应的
`gate74LS*.v`，两个文件都已登记在 `.pds` 里。所有工程的输入一律只有开关，输出一律只有 LED。

## 第二次实验工程

| Project | Design | Gates | Ports |
|---------|--------|-------|-------|
| `lab2_parity_74LS139`        | 3 位奇偶校验 | 74LS139 + 74LS20 + 74LS04 | A B C0 → S C1 |
| `lab2_subtractor_74LS138`    | 全减器 | 74LS138 + 74LS20 | A B C0 → S C1 |
| `lab2_bcd_detector_74LS151`  | 8421BCD 非法码检测 | 74LS151 | D C B A → F |
| `lab2_multiplier_2x2_74LS283`     | 2 位二进制乘法器 | 74LS283 × 2 | a1 a0 b1 b0 → p3 p2 p1 p0 |

## 第三次实验工程

| Project | Design | Gates | Ports |
|---------|--------|-------|-------|
| `lab3_serial_comparator_74LS112` | 串行数值比较器（图 2-36） | 74LS112 + 74LS02 + 74LS20 | a b cp rst → g l e |
| `lab3_johnson_counter_74LS74`    | 4 位扭环计数器（额外，非讲义内容） | 74LS74 ×2 + 74LS02 | clk rst → q3 q2 q1 q0 |

比较器的 CP 用开关 J15 手动给；扭环计数器用全局时钟 H18（27MHz）分频到 1Hz；预置版则用手动时钟开关 J14。
电平：所有工程统一 `LVCMOS33 / VCCIO 3.3`（2026-11 定）。

## 第四次实验工程

| Project | Design | Gates | Ports |
|---------|--------|-------|-------|
| `lab4_counter_mod8_74LS161` | 反馈置数法模 8 计数器（起始 5，自动走） | 74LS161 + 74LS20 + 74LS00 | clk rst → q3 q2 q1 q0 |
| `lab4_counter_mod8_74LS161_start0` ~ `start15` | 同上，**16 种起始值副本**（起点 0~15 各一份），总览见 [变体表](lab4/lab4_counter_mod8/VARIANTS.md) | 74LS161 + 74LS20 + 74LS00 | clk rst → q3 q2 q1 q0 |
| `lab4_counter_mod36_74LS161_163` | 十进制模 36 计数器（自动走） | 74LS163 + 74LS161 + 74LS20 + 74LS00 | clk → t1 t0 u3 u2 u1 u0 |
| `lab4_ring_counter_mod8_74LS194` | 扭环计数器模 8（自启动，50MHz→1Hz） | 74LS194 + 74LS00 + 74LS20 | clk clr_n → qa qb qc qd |

前三个工程对应第 4 次实验的三道题；另加 16 个模 8 计数器的**起始值副本**（起点 0~15），用于对比不同起点的循环，索引见 [变体表](lab4/lab4_counter_mod8/VARIANTS.md)，时钟都由板载 50MHz（J18）分频得到（模 8 与扭环用 1Hz，模 36 用约 3Hz），**自动走位**。
## 第五次实验工程

| Project | Design | Gates | Ports |
|---------|--------|-------|-------|
| `lab5_5.12.1_multifunc_alu` | 多功能运算电路（A/B 选加/减/乘，C/D 运算） | 74LS283 ×5 | a b c1 c0 d1 d0 → 数码管 + LED1~LED4 |
| `lab5_5.12.2_tug_of_war` | 拔河游戏机（7 灯 + 键盘消抖 + 双向计数 + 数码管） | 全行为级 | btn_a btn_b btn_rst → 7 LED + 数码管 |
| `lab5_5.12.3_cyclic_light` | 8 路循环彩灯（三段 30 步，查表法） | 全行为级 | clk → LED1~LED8 |
| `lab5_5.12.4_freq_meter` | 4 位数字频率计（闸门 1ms/10ms/100ms/1s，自动小数点） | 全行为级 | sig g1 g0 → 数码管 |
| `lab5_5.12.5_digital_clock` | 24 小时数字钟（显示切换 分:秒 / 时:分） | 全行为级 | run sel set_h set_m → 数码管 + 报时灯 |
| `lab5_5.12.6_call_6way` | 6 路呼叫器（锁存 + 60s 倒计时 + 报警） | 全行为级 | k1~k6 ack → 6 LED + 报警灯 + 数码管 |
| `lab5_5.12.7_traffic_light` | 交通灯控制器（4 态机 + 双侧倒计时） | 全行为级 | ts1 ts0 → 6 灯 + 数码管 |
| `lab5_5.12.8_quiz_buzzer` | 6 路抢答器（10s 倒计时 + 互锁） | 全行为级 | k1~k6 host → 4 LED + 数码管 |

5.12.1 的结果用一位数码管显示绝对值，负数由 LED4 指示；LED1/LED2/LED3 分别表示加/减/乘。
5.12.2 用 7 颗灯做拔河（中间开局），数码管交替显示双方按键次数和当前位置；按满 30 次或一方到边即停。

---

# 第二部分　讲义任务对照

## 第一次实验 —— 数字实验箱及门电路

**器件**：74LS04、74LS00、74LS20

| 讲义任务 | 工程 | 功能 |
|---|---|---|
| 基础 ①b　74LS00 与非门逻辑功能验证 | `lab1_nand_74LS00` | 三路独立与非门，6 个开关分别做输入，3 颗灯看输出 |
| 基础 ①c　与非门对脉冲信号的控制作用 | `lab1_nand_74LS00` 第 3 路 | 一路接"脉冲"、一路接"控制"，控制为 0 时脉冲被封锁 |
| 基础 ②a　用与非门实现或门 F=A+B | `lab1_or_gate` | 74LS00 三个门做德摩根 |
| 基础 ②b　用与非门实现与门 F=A·B | `lab1_and_gate` | 与非 + 反相（两级） |
| 基础 ②c　用与非门实现与或门 F=AB+CD | `lab1_and_or_gate` | 三个与非门，两组与项再与非 |
| 基础 ②d　用与非门实现异或门 F=A⊕B | `lab1_xor_gate` | 四个与非门的经典接法 |

**要点**：课程包里没有 74LS08/32/86，所以与、或、异或、与或全部用 74LS00 搭出来；
每个工程的 `rtl/` 下是 `<功能名>.v`（顶层）+ `gate74LS00.v`（芯片模型）。

---

## 第二次实验 —— 组合逻辑电路的设计

**器件 A**：74LS00、74LS20、74LS148、**74LS138、74LS139**
**器件 B**：**74LS151、74LS283**

### 2.1.3 编码器与译码器

| 讲义任务 | 工程 | 功能 |
|---|---|---|
| 基础 ②　用 74LS138 实现一位全减器 | `lab2_subtractor_74LS138` | A、B、C0 三个输入，输出差 S 与借位 C1 |
| 基础 ③　用 74LS139 实现三输入奇校验码 | `lab2_parity_74LS139` | 三个输入中 1 的个数为偶数时输出 1；两灯互补 |

### 2.1.4 数据选择器与全加器

| 讲义任务 | 工程 | 功能 |
|---|---|---|
| 基础 ①　用 74LS151 检测 8421BCD 非法码 | `lab2_bcd_detector_74LS151` | 输入 0~9 输出 0，10~15 输出 1 |
| 基础 ④　用 74LS283＋门实现 2 位二进制相乘 | `lab2_multiplier_2x2_74LS283` | 两片 283 加部分积，结果 4 位 |

**要点**：减法器要注意 A/B 不能接反（`A=1,B=0` 与 `A=0,B=1` 结果必须不同）；
BCD 检测里 1000、1001 是合法码，灯必须灭。

---

## 第三次实验 —— 触发器及 SSI 计数器

**器件**：74LS00、74LS20、**74LS74**、**74LS112**（＋74LS02）

| 讲义任务 | 工程 | 功能 |
|---|---|---|
| 触发器 ④　74LS112＋74LS02 串行数值比较器 | `lab3_serial_comparator_74LS112` | 逐位比较，输出 A>B、A=B、A<B 三种结果，结果**锁存** |
| 计数器 ②　D＋门：四位扭环计数器且能自启动 | `lab3_johnson_counter_74LS74` | 8 个状态循环，`clkout` 灯以 1Hz 闪示节拍 |

**要点**：串行比较器的 CP 用开关 J15 手动给（下降沿锁存），结果会保持到复位；
扭环计数器的 D 端接法决定移位方向，本设计是 0000→0001→0011→0111→1111→1110→1100→1000。

---

## 第四次实验 —— 计数器和移位寄存器

**计数器器件**：**74LS161、74LS163**、74LS290、74LS04＋门
**移位寄存器器件**：74LS00、74LS20、**74LS194、74LS195**

| 讲义任务 | 工程 | 功能 |
|---|---|---|
| 计数器 a　模 8 计数器 | `lab4/lab4_counter_mod8/`（161 置数法，起点 5；另 16 个起始值变体） | 5→12 循环，8 个状态 |
| 计数器 b　161＋163 实现模 36 加法计数器 | `lab4_counter_mod36_74LS161_163` | 十进制 00~35，个位模 10、十位模 4 |
| 移位 c　194 自启动扭环计数器 | `lab4_ring_counter_mod8_74LS194` | 8 个状态循环，含非法态 0100 自启动 |

**要点**：161 是**异步**清零、163 是**同步**清零（计到 N−1 再清），所以模 36 的个位用 163 做模 10；
级联时用低位 CO 驱动高位使能。模 8 采用**反馈置数法**（检测末态再把初值装入），
与"反馈清零法"是同一目的的两条路。

---

## 大实验（实验 5）—— 综合设计

讲义 5.12 节共 8 题，本仓库全部实现：

| 题号 | 题目 | 工程 |
|:--:|---|---|
| 5.12.1 | 多功能运算电路（A/B 选加/减/乘，C/D 运算） | `lab5_5.12.1_multifunc_alu` |
| 5.12.2 | 拔河游戏机（7 灯 + 按键消抖 + 双向计数） | `lab5_5.12.2_tug_of_war` |
| 5.12.3 | 循环彩灯（三段 30 步查表） | `lab5_5.12.3_cyclic_light` |
| 5.12.4 | 数字频率计（闸门 1ms/10ms/100ms/1s） | `lab5_5.12.4_freq_meter` |
| 5.12.5 | 数字时钟（24 小时制，4 位分时显示） | `lab5_5.12.5_digital_clock` |
| 5.12.6 | 多路呼叫器（6 路 + 倒计时 + 报警） | `lab5_5.12.6_call_6way` |
| 5.12.7 | 交通灯控制器（4 态机 + 双侧倒计时） | `lab5_5.12.7_traffic_light` |
| 5.12.8 | 多路抢答器（6 路 + 10 秒倒计时） | `lab5_5.12.8_quiz_buzzer` |

每题的引脚、操作步骤、验证清单见工程目录下的 `README.md` / `USAGE.md`。

---

## 讲义与工程的对应原则

1. **讲义给的是电路功能，工程给的是实现**：同一个功能可以用不同芯片组合实现，本仓库优先按讲义指定的芯片型号搭。
2. **讲义里的芯片引脚/功能表就是 `gate74LS*.v` 的依据**：模型必须与数据手册一致（例如 161 的 CO 只在 ENT=1 且 Q=1111 时为高）。
3. **讲义里的"接线"对应代码里的实例化**：`gate74LS138 U1 (.A(A), .B(B), .C(C), ...);`
4. **演示时讲引脚**：哪个开关是输入、哪颗灯是输出、时钟从哪个脚来 —— 这是评分关键。

---

# 第三部分　工程规范与维护

## 工程文件格式

PDS 的 `.pds` 是 **Lisp 风格的文本**，不是二进制。结构如下（简化）：

```lisp
(_flow fab_demo "2022.2-SP1-Lite"
    (_version "1.0.9")
    (_task tsk_setup
        (_widget wgt_select_arch
            (_input (_part (_family Logos)(_device PGL22G)
                           (_speedgrade -6)(_package MBG324))))
        (_widget wgt_my_design_src
            (_input
                (_file "rtl/parity_checker.v" + "parity_checker" (_format verilog) (_timespec "…"))
                (_file "rtl/gate74LS20.v" (_format verilog) (_timespec "…"))))
        (_widget wgt_import_logic_con_file
            (_input (_file "constr/xxx.fdc" (_format fdc) (_timespec "…"))))
        …)
    (_task tsk_compile …)
    …)
```

要点：
- `_**_timespec` 是文件时间戳，随便写都行，PDS 会自己刷新。
- `_file` 的路径都**相对 `.pds` 所在目录**。
- `+ "<名>"` 是"顶层模块名"的标注，必须和源码里的 `module` 名、`.v` 文件名三者一致。
- `_gci_state 0` = 该步骤"未运行"，`2` = "已完成"。**新工程一律写 0**。
- 手工改完 `.pds` 后 PDS 能正常读；不要动 `_flow` / `_version` 这两行。

---

## 板子引脚

```
开关       从左到右：K15  J14  J15  H13  H14  G13
LED        从左到右：F14  F13  F16  G16  H16  J16  K18  N15
瞬时按键    G14   （按下为高电平）
全局时钟    27MHz = H18      50MHz = J18
```

- LED 为**高电平点亮**（真值表里 1 = 亮）。
- 电平约定：本套工程统一写 `LVCMOS33 / VCCIO 3.3`（2026-11 定，见 7.2）。
  但另一份工程记录里 G14 用的是 `LVTTL33 / 3.3` —— 见第 7 节"已知问题"。

---

### 各工程的完整端口 → 引脚

```
lab2_parity_74LS139        B=H14  A=G13  C0=H13          → S=K18   C1=N15
lab2_subtractor_74LS138    B=H14  A=G13  C0=H13          → S=K18   C1=N15
lab2_bcd_detector_74LS151  D=J15  C=H13  B=H14  A=G13    → F=N15
lab2_multiplier_2x2_74LS283 a1=G13 a0=H14 b1=H13 b0=J15   → p3=H16  p2=J16  p1=K18  p0=N15
lab1_or_gate               a=K15  b=J14                   → f=F14
lab1_and_gate              a=K15  b=J14                   → f=F14
lab1_and_or_gate           a=K15  b=J14  c=J15  d=H13     → f=F14
lab1_xor_gate              a=K15  b=J14                   → f=F14
lab1_nand_74LS00           a1=K15 b1=J14 a2=J15 b2=H13 a3=H14 b3=G13 → y1=J16 y2=K18 y3=N15
lab3_serial_comparator_74LS112  a=K15 b=J14 cp=J15 rst=H13 → g=N15 l=K18 e=J16 cpled=F14
lab3_johnson_counter_74LS74 exclk=H18 rst=K15             → q3=H16 q2=J16 q1=K18 q0=N15 clkout=F14
lab4_counter_mod8_74LS161        clk=J18 rst=J14 → q3=H16 q2=J16 q1=K18 q0=N15
lab4_counter_mod8_74LS161_startN   clk=J18 rst=J14 → q3=H16 q2=J16 q1=K18 q0=N15  (N=0..15)
lab4_counter_mod36_74LS161_163  clk=J18 rst=J14 → t1=F14 t0=F13 u3=F16 u2=G16 u1=H16 u0=J16
lab4_ring_counter_mod8_74LS194   clk=J18 clr_n=K15 → qa=G16 qb=H16 qc=J16 qd=K18
lab5_5.12.1_multifunc_alu  a=K15 b=J14 c1=J15 c0=H13 d1=H14 d0=G13 → LED1-4=F14/F13/F16/G16 + 数码管
lab5_5.12.2_tug_of_war  clk=J18 btn_a=K15 btn_b=J14 btn_rst=J15 → led0-6=F14/F13/F16/G16/H16/J16/K18 + 数码管
lab5_5.12.3_cyclic_light  clk=J18 → led0-7=F14/F13/F16/G16/H16/J16/K18/N15
lab5_5.12.4_freq_meter  clk=J18 sig=H14 g1=K15 g0=J14 → 数码管
lab5_5.12.5_digital_clock  clk=J18 run=K15 sel=J14 set_h=J15 set_m=H13 → 数码管 chime=K18
lab5_5.12.6_call_6way  clk=J18 k1-6=K15/J14/J15/H13/H14/G13 ack=G14 → led1-6=F14/F13/F16/G16/H16/J16 alarm=K18 + 数码管
lab5_5.12.7_traffic_light  clk=J18 ts1=K15 ts0=J14 → mr/my/mg=F14/F13/F16 sr/sy/sg=G16/H16/J16 + 数码管
lab5_5.12.8_quiz_buzzer  clk=J18 k1-6=K15/J14/J15/H13/H14/G13 host=G14 → led1-4=F14/F13/F16/G16 + 数码管
```

---

## 编码约定

1. **顶层模块名 = `.v` 文件名 = 功能名**，三者必须一致，且和 `.pds` 里 `+ "<名>"` 的标注一致。
   早期所有工程都叫 `ADD`（课程模板遗留），2026-11-24 已统一改成功能名；再改名要**同时改四处**：
   文件名、`module` 名、`.pds` 的 `_file` 路径、`.pds` 的 `+ "<名>"` 标记。
2. **源码必须是纯 ASCII、LF 换行**；除每个文件头部 5 行 SPDX 版权注释外，不再加其它注释，中文说明写在 `README.md`。
3. **门电路模型**（`gate74LS*.v`）是从课程资料里拿的**行为级模型**，已去注释。
   注意它们是"软件模型"——仿真时自由度很高，但**综合后 CLK 端口会变成真实的时钟网络**，
   受第 7 节的物理限制。
4. **组合逻辑也一律用门电路模型实例化**（`lab1_*` 就是这样），不要再写 `assign f = a & b` 这种行为级描述。

---

## 已知问题与坑

### 开关当时钟会报 Place-0084

现象（任何"开关直接给时钟"的工程都会遇到）：
```
E: Place-0084: GLOBAL_CLOCK: the driver cp_ibuf/opit_1 fixed at IOL_151_201 is unreasonable.
                Sub-optimal placement for a clock source and a clock buffer.
```

原因：`cp` 被当作时钟用，却落在普通 I/O 上。PDS 不允许普通 I/O 直接当全局时钟源。

处理：在该工程 fdc 末尾加一行，放宽时钟布线：
```
define_attribute {n:cp} {PAP_CLOCK_DEDICATED_ROUTE} {FALSE}
```

加完之后 `E:` 会降级成 `C:` 提示，P&R 能正常跑完（`lab3_serial_comparator` 已实测到生成比特流）。

现在只有 `lab3_serial_comparator_74LS112`（`cp`=J15）用开关当时钟，所以只有它需要这一行；
lab4 三个工程已改成板载晶振分频，`clk` 接 `J18` 真时钟脚，不需要这个补丁。

> 新增工程只要用开关当时钟，就必须补这一行，否则 P&R 直接报错停下。
### 电平标准统一为 3.3V

课程原始 fdc（`ALLJIA.fdc`）写的是 `LVCMOS12 / VCCIO 1.2`，参考实现 `text4.1` 写的是
`LVCMOS33 / VCCIO 3.3`，两者冲突过一段时间。

**2026-11-24 起全库统一为 `LVCMOS33 / VCCIO 3.3`**（依据：`text4.1` 是跑出过比特流的参考工程）。
22 个工程的 fdc 已全部改齐，`manifest.json` 同步。

> **改电平时必须同时改驱动能力**：`LVCMOS12` 允许 `PAP_IO_DRIVE {2}`，但 `LVCMOS33`
> 只接受 `{4, 8, 12, 16, 24}`。从 1.2 改到 3.3 时如果忘了改 DRIVE，Device Map 会报
> `ConstraintEditor-0050: PAP_IO_DRIVE value 2 is illegal`。全库已统一为 `{4}`。

如果以后实测发现某个 bank 其实是 1.2V，把对应 fdc 里的 `{3.3}` 改回 `{1.2}`、
`LVCMOS33` 改回 `LVCMOS12`、`DRIVE {4}` 改回 `{2}` 即可。
### 74LS283 模型是自写的

课程资料里没有 `gate74LS283.v`（只有 00/02/04/20/138/139/148/151/74/112）。
现在这份是按数据手册端口名（`A1~A4 / B1~B4 / C0 / S1~S4 / C4`）手写的，
用 `assign sum = A + B + C0` 实现。行为正确（16 种输入已用 Python 模型核对），但**不是老师给的版本**。

### 其他小坑

- 器件速度等级按 **-6** 设置（依据：原主自己旧比特流头部是 `Logos-PGL22G--6-MBG324`）。
  如果板子其实是 -5，改 `.pds` 里的 `(_speedgrade -6)` → `-5`。

---

## 新增工程

PDS 没有方便的"模板复制"命令，最稳的做法是**照抄一个同类工程**：

```bash
cp -r lab1_or_gate my_new_gate
cd my_new_gate
mv lab1_or_gate.pds my_new_gate.pds
rm -rf compile synthesize device_map place_route generate_bitstream *.log
```

然后改三处：
1. `rtl/<功能名>.v` —— 写你的设计，**模块名与文件名一致**；
2. `constr/my_new_gate.fdc` —— 端口名换成你的，引脚用第 3 节表里的；
3. `my_new_gate.pds` —— 改 `wgt_my_design_src` 里的 `_file` 列表（增删源文件）、
   `wgt_import_logic_con_file` 里的 fdc 文件名。

最后确认：**Verilog 顶层端口集合 == fdc 里的端口集合**（多一个少一个都会在 Device Map 报错）。

---

## 目录约定

```
labN/<project>/
  <project>.pds      PDS 工程文件
  rtl/               设计源码（`<功能名>.v` 为顶层，`gate74LS*.v` 为门电路模型；仅文件头有版权注释）
  constr/            引脚约束 fdc
  sim/               门电路 testbench（未加入工程）
  README.md          该工程的端口表与设计要点
```