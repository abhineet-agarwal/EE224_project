# IITB-CPU: 16-bit Multi-Cycle RISC Processor

A 16-bit multi-cycle RISC CPU designed and implemented in VHDL, based on the IITB-CPU instruction set architecture (derived from the Little Computer Architecture). Synthesised and verified on an Intel FPGA using Quartus Prime.

**Course:** EE224 Digital Design (Autumn 2023), IIT Bombay
**Instructor:** Prof. Virendra Singh

## Architecture

- **Word size:** 16-bit data and address
- **Registers:** 8 general-purpose (R0--R7), with R7 serving as the Program Counter
- **Flags:** Carry (C) and Zero (Z) condition codes
- **Memory:** Word-addressed (each address = 2 bytes)
- **Execution:** Multi-cycle FSM-controlled datapath with point-to-point communication

## Instruction Set

14 instructions across three encoding formats:

| Format | Instructions | Description |
|--------|-------------|-------------|
| **R-type** | `ADD`, `SUB`, `MUL`, `AND`, `ORA`, `IMP` | Register-register arithmetic and logic |
| **I-type** | `ADI`, `LW`, `SW`, `BEQ` | Immediate arithmetic, load/store, branch |
| **J-type** | `LHI`, `LLI`, `JAL`, `JLR` | Immediate loads, jump-and-link |

### Instruction Encoding

```
R-type: [opcode(4)] [RA(3)] [RB(3)] [RC(3)] [unused(1)] [CZ(2)]
I-type: [opcode(4)] [RA(3)] [RC(3)] [immediate(6)]
J-type: [opcode(4)] [RA(3)] [immediate(9)]
```

### Instruction Details

| Mnemonic | Opcode | Operation |
|----------|--------|-----------|
| `ADD` | `0000` | RC = RA + RB |
| `SUB` | `0010` | RC = RA - RB |
| `MUL` | `0011` | RC = RA[3:0] * RB[3:0] |
| `ADI` | `0001` | RB = RA + sign_ext(imm6) |
| `AND` | `0100` | RC = RA AND RB |
| `ORA` | `0101` | RC = RA OR RB |
| `IMP` | `0110` | RC = (NOT RA) OR RB |
| `LHI` | `1000` | RA = imm8 << 8 |
| `LLI` | `1001` | RA = zero_ext(imm8) |
| `LW`  | `1010` | RA = Mem[RB + sign_ext(imm6)] |
| `SW`  | `1011` | Mem[RB + sign_ext(imm6)] = RA |
| `BEQ` | `1100` | if RA == RB then PC = PC + imm6*2 |
| `JAL` | `1101` | RA = PC; PC = PC + imm9*2 |
| `JLR` | `1111` | RA = PC; PC = RB |

## Datapath Components

| File | Component |
|------|-----------|
| `iitb_cpu.vhd` | Top-level entity: FSM controller + datapath integration |
| `alu.vhd` | ALU (add, subtract, multiply, AND, OR, implication) |
| `rf_file.vhd` | 8x16-bit register file |
| `memory_unit.vhd` | Instruction + data memory |
| `sixteen_bit_adder_sub.vhd` | 16-bit adder/subtractor |
| `sixteen_bit_mul.vhd` | 16-bit multiplier (4-bit x 4-bit) |
| `sixteen_bit_and.vhd` | 16-bit bitwise AND |
| `sixteen_bit_or.vhd` | 16-bit bitwise OR |
| `Mux_2.vhd`, `Mux_4.vhd`, `Mux_8.vhd` | 2/4/8-to-1 multiplexers |
| `sign_extend6.vhd`, `sign_extend8.vhd`, `sign_extend9.vhd` | Sign extension units |
| `register.vhd` | Generic 16-bit register |
| `Dflipflop.vhd` | D flip-flop |
| `zero_check.vhd` | Zero flag logic |
| `shifter8.vhd` | 8-bit left shifter (for LHI) |
| `tb.vhd` | Testbench |

## Tools

- **HDL:** VHDL
- **Synthesis & PnR:** Intel Quartus Prime
- **Target FPGA:** Intel/Altera (see `.qsf` for device assignment)
- **Simulation:** RTL simulation via Quartus / ModelSim

## Building & Running

1. Open `iitb_cpu.qpf` in Quartus Prime
2. Compile the project (Processing > Start Compilation)
3. Run RTL simulation with `tb.vhd` as the testbench
4. For FPGA deployment, program the `.sof` file via the Programmer

## Team

| Name | Roll No. |
|------|----------|
| Abhineet Agarwal | 22B1219 |
| Garima Gopalani | 22B3958 |
| Mitul Tandon | 22B0305 |
| Mrunali Barapatre | 22B3966 |

## Reports

- [`EE224 project report.pdf`](EE224%20project%20report.pdf) -- Design report with FSM, datapath diagrams, and debugging notes
- [`FPGA report.pdf`](FPGA%20report.pdf) -- FPGA synthesis and implementation results
- [`EE-224-Project-1-CPU-IITB.pdf`](EE-224-Project-1-CPU-IITB.pdf) -- Project specification (ISA definition)
