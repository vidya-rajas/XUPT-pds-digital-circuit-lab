# lab2_parity_74LS139

**Experiment 2 - 3-bit parity checker (74LS139 + 74LS20 + 74LS04)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `parity_checker`
- Project file: `lab2_parity_74LS139.pds`

## 端口与引脚

输入 A / B / C0（三位数据），输出 S（奇校验）、C1（偶校验）

引脚沿用原来的 ALLJIA.fdc 约束（见 `constr/lab2_parity_74LS139.fdc`），需要改动时
可在 User Constraint Editor 里改，或直接编辑这个 fdc 文件。

| Port | Dir | Pin | IO Standard |
|------|-----|-----|-------------|
| A | input | G13 | LVCMOS33 |
| B | input | H14 | LVCMOS33 |
| C0 | input | H13 | LVCMOS33 |
| S | output | K18 | LVCMOS33 |
| C1 | output | N15 | LVCMOS33 |

## 目录说明

```
lab2_parity_74LS139/
  lab2_parity_74LS139.pds           PDS 工程文件（双击打开）
  rtl/parity_checker.v            顶层设计（模块名 parity_checker）
  rtl/gate74LS*.v      门电路行为模型，已加入工程
  constr/lab2_parity_74LS139.fdc    引脚约束
  sim/                 门电路 testbench（未加入工程，需要时自行 Add File）
```

## 设计要点

奇校验 S  = Σm(1,2,4,7) = NAND(Y1_1, Y1_2, Y2_0, Y2_3)
偶校验 C1 = Σm(0,3,5,6) = NAND(Y1_0, Y1_3, Y2_1, Y2_2)

两个译码器的使能必须互补：G1 = C0，G2 = /C0。若把 G1 接死 0，
译码器 1 在 C0=1 时仍会输出 0，会让另一组与非门误判，导致两个校验灯同时亮。

## 使用方法

1. PDS 启动页的 Recent 列表里点 `lab2_parity_74LS139`（或 File → Open Project 选 `lab2_parity_74LS139.pds`）。
2. Design Flow 里依次跑 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 以后换设计时可以只替换 `rtl/parity_checker.v`，只要模块名保持 `parity_checker`、端口名保持上表，约束就能复用。
