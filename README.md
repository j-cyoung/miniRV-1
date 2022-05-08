# Readme

## 实现功能

实现了 `单周期CPU` 以及 `流水线CPU`，实现指令如下表

| 单周期     |                                                            |
| ---------- | ---------------------------------------------------------- |
| **R-类型** |                                                            |
| add        | (rd) ← (rs1) + (rs2)                                       |
| sub        | (rd) ← (rs1) - (rs2)                                       |
| and        | (rd) ← (rs1) &  (rs2)                                      |
| or         | (rd) ← (rs1) \| (rs2)                                      |
| xor        | (rd) ← (rs1) ^ (rs2)                                       |
| sll        | (rd) ← (rs1) <<  (rs2)                                     |
| srl        | (rd) ← (rs1) >>  (rs2), 逻辑右移                           |
| sra        | (rd) ← (rs1) >>  (rs2), 算术右移                           |
| slt        | (rd) ← ((rs1) <  (rs2)), 有符号比较                        |
| sltu       | (rd) ← ((rs1) <  (rs2)), 无符号比较                        |
| **I-类型** |                                                            |
| addi       | (rd) ← (rs1) +  sext(imm)                                  |
| andi       | (rd) ← (rs1) &  sext(imm)                                  |
| ori        | (rd) ← (rs1) \|  sext(imm)                                 |
| xori       | (rd) ← (rs1) ^  sext(imm)                                  |
| slli       | (rd) ← (rs1) <<  shamt                                     |
| srli       | (rd) ← (rs1) >>  shamt, 逻辑右移                           |
| srai       | (rd) ← (rs1) >>  shamt, 算术右移                           |
| slti       | (rd) ← ((rs1) <  sext(imm)), 有符号比较                    |
| sltiu      | (rd) ← ((rs1) <  sext(imm)), 无符号比较                    |
| lb         | (rd) ←  sext(Mem[(rs1) + sext(offset)][7:0])               |
| lh         | (rd) ←  sext(Mem[(rs1) + sext(offset)][15:0])              |
| lw         | (rd) ← sext(Mem[(rs1)  + sext(offset)][31:0])              |
| jalr       | t ← (pc) + 4; (pc) ← ((rs1) + sext(offset)) & ~1; (rd) ← t |
| **S-类型** |                                                            |
| sb         | Mem[(rs1) + sext(offset)] ← (rs2)[7:0]                     |
| sh         | Mem[(rs1) + sext(offset)] ← (rs2)[15:0]                    |
| sw         | Mem[(rs1) + sext(offset)] ← (rs2)[31:0]                    |

| 多周期     |                                                            |
| ---------- | ---------------------------------------------------------- |
| **R-类型** |                                                            |
| add        | (rd) ← (rs1) + (rs2)                                       |
| sub        | (rd) ← (rs1) - (rs2)                                       |
| and        | (rd) ← (rs1) &  (rs2)                                      |
| or         | (rd) ← (rs1) \| (rs2)                                      |
| xor        | (rd) ← (rs1) ^ (rs2)                                       |
| sll        | (rd) ← (rs1) <<  (rs2)                                     |
| srl        | (rd) ← (rs1) >>  (rs2), 逻辑右移                           |
| sra        | (rd) ← (rs1) >>  (rs2), 算术右移                           |
| slt        | (rd) ← ((rs1) <  (rs2)), 有符号比较                        |
| sltu       | (rd) ← ((rs1) <  (rs2)), 无符号比较                        |
| I-类型     |                                                            |
| addi       | (rd) ← (rs1) +  sext(imm)                                  |
| andi       | (rd) ← (rs1) &  sext(imm)                                  |
| ori        | (rd) ← (rs1) \|  sext(imm)                                 |
| xori       | (rd) ← (rs1) ^  sext(imm)                                  |
| slli       | (rd) ← (rs1) <<  shamt                                     |
| srli       | (rd) ← (rs1) >>  shamt, 逻辑右移                           |
| srai       | (rd) ← (rs1) >>  shamt, 算术右移                           |
| slti       | (rd) ← ((rs1) <  sext(imm)), 有符号比较                    |
| sltiu      | (rd) ← ((rs1) <  sext(imm)), 无符号比较                    |
| lb         | (rd) ←  sext(Mem[(rs1) + sext(offset)][7:0])               |
| lh         | (rd) ←  sext(Mem[(rs1) + sext(offset)][15:0])              |
| lw         | (rd) ← sext(Mem[(rs1)  + sext(offset)][31:0])              |
| jalr       | t ← (pc) + 4; (pc) ← ((rs1) + sext(offset)) & ~1; (rd) ← t |
| **S-类型** |                                                            |
| sb         | Mem[(rs1) + sext(offset)] ← (rs2)[7:0]                     |
| sh         | Mem[(rs1) + sext(offset)] ← (rs2)[15:0]                    |
| sw         | Mem[(rs1) + sext(offset)] ← (rs2)[31:0]                    |
| **B-类型** |                                                            |
| beq        | if ((rs1) = (rs2)) (pc) ← (pc) + sext(offset)              |
| bne        | if ((rs1) ≠ (rs2)) (pc) ← (pc) + sext(offset)              |
| blt        | if ((rs1) < (rs2)) (pc) ← (pc) + sext(offset), 有符号比较  |
| bltu       | if ((rs1) < (rs2)) (pc) ← (pc) + sext(offset), 无符号比较  |
| bge        | if ((rs1) ≥ (rs2)) (pc) ← (pc) + sext(offset), 有符号比较  |
| bgeu       | if ((rs1) ≥ (rs2)) (pc) ← (pc) + sext(offset), 无符号比较  |
| **U-类型** |                                                            |
| lui        | (rd) ← sext(imm[31:12]  << 12)                             |
| auipc      | (rd) ← (PC) +  sext(imm[31:12] << 12)                      |
| **J-类型** |                                                            |
| jal        | (rd) ← (pc) + 4; (pc) ← (pc) + sext(offset)                |

## 设计特色

1. 分支预测功能

采用静态分支预测，默认不进行跳转。同时将分支检测提前至译指令阶段，因此当需要进行跳转时，仅需要插入一次空周期即可完成跳转。

2. 实现扩展指令

除24条基本指令之外，另外实现了11条扩展指令：slt、sltu、slti、sltiu、lb、lh、sb、sh、bltu、bgeu、auipc

3. 流水线实现了外设功能

成功运行试验二中小彩灯的汇编代码

4. 增加原器件复用

所有关于加法、减法、比较的操作，包括要求无符号运算和有符号运算，均复用加法器模块。加法器模块通过将31位操作数扩展至32位操作数，以及取反等操作，可以避免溢出并在运算的同时得到比较信号。

5. 增加mask模块

在存储模块中新增mask模块，作为dmem IP核与外部电路的接口模块，可以成功进行存取半字、存取字节、无符号读出操作

## 资源使用与数据功耗图

![single CPU  (30MHz)](https://gitee.com/JiangChenyang/typora_md_images/raw/master//single%20CPU%20%20(30MHz).png)

![pipline CPU (50MHz)](https://gitee.com/JiangChenyang/typora_md_images/raw/master//pipline%20CPU%20(50MHz).png)

