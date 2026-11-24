# lab2_subtractor_74LS138

**Experiment 2 - Full subtractor (74LS138 + 74LS20)**

- Device: Pango Logos **PGL22G** / speed grade **-6** / package **MBG324**
- Top module: `subtractor`
- Project file: `lab2_subtractor_74LS138.pds`

## 端口与引脚

输入 A / B / C0（被减数、减数、低位借位），输出 S（差）、C1（借位）

引脚沿用原来的 ALLJIA.fdc 约束（见 `constr/lab2_subtractor_74LS138.fdc`），需要改动时
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
lab2_subtractor_74LS138/
  lab2_subtractor_74LS138.pds           PDS 工程文件（双击打开）
  rtl/subtractor.v            顶层设计（模块名 subtractor）
  rtl/gate74LS*.v      门电路行为模型，已加入工程
  constr/lab2_subtractor_74LS138.fdc    引脚约束
  sim/                 门电路 testbench（未加入工程，需要时自行 Add File）
```

## 设计要点

差   S  = Σm(1,2,4,7) = NAND(Y1,Y2,Y4,Y7)
借位 C1 = Σm(1,2,3,7) = NAND(Y1,Y2,Y3,Y7)

## 使用方法

1. PDS 启动页的 Recent 列表里点 `lab2_subtractor_74LS138`（或 File → Open Project 选 `lab2_subtractor_74LS138.pds`）。
2. Design Flow 里依次跑 Compile → Synthesize → Device Map → Place & Route → Generate Bitstream。
3. 以后换设计时可以只替换 `rtl/subtractor.v`，只要模块名保持 `subtractor`、端口名保持上表，约束就能复用。
