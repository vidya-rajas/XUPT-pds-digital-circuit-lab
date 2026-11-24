# lab2_bcd_detector_74LS151

**Experiment 2 - 8421 BCD illegal-code detector (74LS151)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `bcd_detector`
- Project file: `lab2_bcd_detector_74LS151.pds`

## 端口与引脚

输入 D C B A（8421BCD 码），输出 F（1 = 非法码，0 = 合法码）

引脚沿用原来的 ALLJIA.fdc 约束（见 `constr/lab2_bcd_detector_74LS151.fdc`），需要改动时
可在 User Constraint Editor 里改，或直接编辑这个 fdc 文件。

| Port | Dir | Pin | IO Standard |
|------|-----|-----|-------------|
| A | input | G13 | LVCMOS33 |
| B | input | H14 | LVCMOS33 |
| C | input | H13 | LVCMOS33 |
| D | input | J15 | LVCMOS33 |
| F | output | N15 | LVCMOS33 |

## 目录说明

```
lab2_bcd_detector_74LS151/
  lab2_bcd_detector_74LS151.pds           PDS 工程文件（双击打开）
  rtl/bcd_detector.v            顶层设计（模块名 bcd_detector）
  rtl/gate74LS*.v      门电路行为模型，已加入工程
  constr/lab2_bcd_detector_74LS151.fdc    引脚约束
  sim/                 门电路 testbench（未加入工程，需要时自行 Add File）
```

## 设计要点

数据端 D7..D0 = 1110_0000，地址端 C=D, B=C, A=B，STROBE 接 0。
F = 1 表示非法码（10~15），F = 0 表示合法码（0~9）。

## 使用方法

1. PDS 启动页的 Recent 列表里点 `lab2_bcd_detector_74LS151`（或 File → Open Project 选 `lab2_bcd_detector_74LS151.pds`）。
2. Design Flow 里依次跑 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 以后换设计时可以只替换 `rtl/bcd_detector.v`，只要模块名保持 `bcd_detector`、端口名保持上表，约束就能复用。
