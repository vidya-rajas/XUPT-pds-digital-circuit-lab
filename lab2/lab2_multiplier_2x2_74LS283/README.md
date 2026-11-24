# lab2_multiplier_2x2_74LS283

**2 位二进制数乘法器（74LS283 × 2）**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `multiplier_2x2`
- Project file: `lab2_multiplier_2x2_74LS283.pds`

## 端口与引脚

4 个开关输入两个 2 位数，4 个 LED 显示 4 位乘积。

| Port | 含义 | Dir | Pin |
|------|------|-----|-----|
| a1 | 第一个数高位 | input | G13 |
| a0 | 第一个数低位 | input | H14 |
| b1 | 第二个数高位 | input | H13 |
| b0 | 第二个数低位 | input | J15 |
| p3 | 乘积 bit3（MSB） | output | H16 |
| p2 | 乘积 bit2 | output | J16 |
| p1 | 乘积 bit1 | output | K18 |
| p0 | 乘积 bit0（LSB） | output | N15 |

引脚与之前几个实验是同一块板子的同一批开关 / LED（G13、H14、H13、J15 是 SW，
N15、K18、J16、H16 是 LED0~LED3），约束沿用 LVCMOS33 / VCCIO 3.3V。

## 设计思路

两个 2 位数 a = a1·2 + a0，b = b1·2 + b0，展开乘积：

```
P = a·b = a1b1·4 + (a1b0 + a0b1)·2 + a0b0
```

- **p0 = a0·b0** —— 与门直接得到，权重 1
- 两个部分积 **x = a1b0、y = a0b1** 权重都是 2，用第一片 74LS283 相加：
  和 S1 就是 **p1**（权重 2），和的 S2（权重 4）记作 c
- **z = a1b1** 权重是 4，和 c 一起用第二片 74LS283 相加：
  和 S1 就是 **p2**，和 S2 就是 **p3**

> 两位部分积相加最大是 1+1 = 2（二进制 10），高位落在**和输出的 S2**上，
> **不是进位 C4**（C4 权重 16，这里永远为 0）。同理第二片也只取 S1/S2。

两片 283 的高三位输入全部接 0，只用到最低位；C0 接 0。

## 真值表

| a | b | 乘积 | p3 p2 p1 p0 |
|---|---|------|-------------|
| 0 | 0 | 0 | 0 0 0 0 |
| 1 | 1 | 1 | 0 0 0 1 |
| 2 | 2 | 4 | 0 1 0 0 |
| 2 | 3 | 6 | 0 1 1 0 |
| 3 | 2 | 6 | 0 1 1 0 |
| 3 | 3 | 9 | 1 0 0 1 |

其余组合同理，16 种输入全部已验证与 a×b 一致。

## 目录说明

```
lab2_multiplier_2x2_74LS283/
  lab2_multiplier_2x2_74LS283.pds   工程文件
  rtl/multiplier_2x2.v                    顶层（模块名 multiplier_2x2）
  rtl/gate74LS283.v            74LS283 四位全加器模型
  constr/*.fdc                 引脚约束
  sim/                         预留（暂无 testbench）
```

## 使用方法

PDS 启动页 Recent 里点本工程，或 File → Open Project 选 `.pds`，
然后 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
