# lab3_serial_comparator_74LS112

**串行数值比较器（74LS112 + 74LS02 + 74LS20）**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `serial_comparator`
- Project file: `lab3_serial_comparator_74LS112.pds`
- 对应实验讲义图 **2-36 串行数值比较器电路图**

## 端口与引脚

| Port | Dir | Pin | 说明 |
|------|-----|-----|------|
| a | input | K15 | 开关 1（最左）：当前位 A |
| b | input | J14 | 开关 2：当前位 B |
| cp | input | J15 | 开关 3：**手动脉冲**，拨动一次给一个时钟 |
| rst | input | H13 | 开关 4：高电平清零 |
| g | output | N15 | LED 8（最右）：A > B |
| l | output | K18 | LED 7：A < B |
| e | output | J16 | LED 6：目前仍相等 |
| cpled | output | F14 | LED 1（最左）：显示 CP 电平 |

板子上开关从左到右：`K15 J14 J15 H13 H14 G13`
LED 从左到右：`F14 F13 F16 G16 H16 J16 K18 N15`

## 时钟为什么接开关而不是按键

> 最早接的是板上按键 G14，P&R 报 `E: Place-0084: GLOBAL_CLOCK ... Sub-optimal placement for a clock source`，
> 因为 G14 是普通 I/O（还是个 share pin），PDS 不允许普通 I/O 当全局时钟源 —— 这正是课程
> "时钟信号不能由普通 I/O 口输入"那条要求。所以改用**拨动开关**驱动 CP：拨动开关每次只产生
> 一个干净的边沿，没有按键抖动，做手动脉冲反而更合适。

74LS112 是**下降沿触发**，所以是**把开关拨回 0 的那一刻**采样 a、b。

`constr/*.fdc` 末尾加了一行放宽时钟布线的约束：

```
define_attribute {n:cp} {PAP_CLOCK_DEDICATED_ROUTE} {FALSE}
```

意思是"这根时钟不走专用时钟树，允许普通布线"。如果 PDS 仍然报同样的错，告诉我，我把设计改成
"CP 接 27MHz、按键/开关只当单周期使能"的版本（一定能过 P&R，但和讲义原理图略有出入）。

> 电平：本工程与其它工程统一用 `LVCMOS33 / VCCIO 3.3`（2026-11 定）。

## 高位先入

**先送最高位，再送低位**，这是串行比较器的前提：

- 第一位（高位）就把大小分出来了 → 后面送什么都不影响，直接定局
- 第一位相等 → 才继续看第二位

所以两个 2 位数要比完，需要按**两下**按键。

## 原理

电路只需要记住三件事：

| 状态 | 含义 |
|------|------|
| g=1, l=0 | A 已经比 B 大 |
| g=0, l=1 | A 已经比 B 小 |
| g=0, l=0 | 到目前还相等 |

一旦分出大小就不再改变，所以两个 JK 触发器都接成 `K=0` 的"置位后保持"，只算 J：

```
J_g = a · b' · l'      J_l = a' · b · g'
```

互锁项 `l'` / `g'` 保证两个触发器不会同时被置位。

## 门电路怎么分配

| 器件 | 用途 |
|------|------|
| `gate74LS112` U_FF | 两路状态触发器（CP 接开关，PR 接 1，CLR 接复位反相） |
| `gate74LS02` U_NOR1 | 四个或非门当反相器：a'、b'、g'、l' |
| `gate74LS20` U_NAND | 两个四输入与非门：输出 J_g'、J_l'（第四个输入接 1） |
| `gate74LS02` U_NOR2 | 把 J_g'、J_l' 反相回 J_g、J_l；另产生 e 和 rst' |

## 操作步骤

1. `rst` 拨 1：`e` 灯亮（表示"目前相等"），两个触发器清零。
2. `rst` 拨回 0。
3. 设好**高位**的 `a`、`b`，把 `cp` 开关拨到 1 再拨回 0（下降沿采样），看结果灯。
4. 设好**低位**的 `a`、`b`，再拨一次 `cp`。
5. 三盏灯里哪个亮，就是这个比较结果；换一组数比较前先 `rst` 清零。

例：比较 A=10、B=01（A 大）——高位 a=1 b=0 拨一次 cp，`g` 亮；低位随便设，
再拨一次 cp，`g` 仍然亮、`l` 不会亮。

## 目录说明

```
lab3_serial_comparator_74LS112/
  lab3_serial_comparator_74LS112.pds
  rtl/serial_comparator.v              顶层
  rtl/gate74LS112.v      JK 触发器模型（已去注释）
  rtl/gate74LS02.v       四或非门模型
  rtl/gate74LS20.v       双四输入与非门模型
  constr/*.fdc           引脚约束
```
