# RISC-V Pipelined CPU Implementation

A fully functional 5-stage pipelined RISC-V CPU implementation with hazard detection, data forwarding, and load-store instruction support. Developed in SystemVerilog for Xilinx FPGAs using Vivado.

**Authors:** Madeline Schneider, Sarah Singh  
**Course:** CMPE 140 - Computer Architecture and Design

---

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Module Descriptions](#module-descriptions)
- [Prerequisites](#prerequisites)
- [Setup and Installation](#setup-and-installation)
- [Building the Project](#building-the-project)
- [Running Simulations](#running-simulations)
- [Test Programs](#test-programs)
- [Results](#results)
- [Project Structure](#project-structure)
- [Future Enhancements](#future-enhancements)

---

## Overview

This project implements a 32-bit RISC-V processor with a classic 5-stage pipeline architecture. The CPU supports R-type, I-type, S-type, and B-type instructions, including arithmetic operations, load-store operations, and branching. Key features include sophisticated hazard detection, data forwarding, and precise byte-enable control for memory operations.

The design successfully synthesizes and meets timing requirements on Xilinx FPGAs, demonstrating practical hardware implementation skills.

---

## Architecture

### Pipeline Stages

1. **Instruction Fetch (IF)**: Retrieves instructions from ROM based on the program counter
2. **Instruction Decode (ID)**: Decodes instructions, reads registers, and generates control signals
3. **Execute (EX)**: Performs ALU operations and calculates branch/memory addresses
4. **Memory Access (MEM)**: Handles load and store operations with byte-level granularity
5. **Write Back (WB)**: Writes results back to the register file

### Key Design Features

- **Hazard Detection**: Identifies data hazards and generates pipeline stalls when necessary
- **Data Forwarding**: Implements bypass paths to resolve hazards without stalling when possible
- **Byte-Enable Control**: Supports byte (LB/SB) and halfword (LH/SH) memory operations with a 4-bit byte-enable signal
- **Branch Handling**: Implements branch prediction and flushing for control hazards

---

## Features

### Supported Instructions

#### R-Type Instructions
- `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`, `SLTU`

#### I-Type Instructions
- **Arithmetic**: `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLTIU`, `SLLI`, `SRLI`, `SRAI`
- **Load**: `LW` (load word), `LH` (load halfword), `LB` (load byte)
- **Load Unsigned**: `LHU`, `LBU`

#### S-Type Instructions
- `SW` (store word), `SH` (store halfword), `SB` (store byte)

#### B-Type Instructions
- `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`

### Hardware Optimizations

- **Forwarding Unit**: Reduces pipeline stalls by forwarding data from later stages to earlier stages
- **Stall Handler**: Detects load-use hazards and inserts necessary pipeline bubbles
- **Memory Byte Masking**: Implements precise byte-enable control for sub-word memory operations

---

## Module Descriptions

| Module | File | Description |
|--------|------|-------------|
| **CPU Top** | `cpu.sv` | Top-level module integrating all pipeline stages |
| **Fetch** | `fetch.sv` | Program counter and instruction fetch logic |
| **Decode** | `decode.sv` | Instruction decoder and control signal generation |
| **ALU** | `alu.sv` | Arithmetic Logic Unit supporting all computational operations |
| **Registers** | `registers.sv` | 32-register register file with dual read ports |
| **Memory Access** | `mem_access.sv` | Load-store unit with byte-enable generation |
| **Write Back** | `write_back.sv` | Multiplexes between ALU results and memory data |
| **Forwarding Unit** | `forwarding.sv` | Detects and resolves data hazards through forwarding |
| **Stall Handler** | `stall_handler.sv` | Detects load-use hazards and generates stall signals |
| **Pipeline Registers** | `pipeline_registers_pkg.sv` | Defines inter-stage register structures |
| **ROM** | `rom.sv` | Instruction memory |
| **RAM** | `ram.sv` | Data memory with byte-enable support |

---

## Prerequisites

### Required Software
- **Xilinx Vivado** (2019.1 or later) - [Download](https://www.xilinx.com/support/download.html)
- **Python 3.x** - For binary-to-text conversion utilities
- **Git** - For version control

### Required Knowledge
- SystemVerilog/Verilog HDL
- RISC-V ISA basics
- Digital design and computer architecture fundamentals

---

## Setup and Installation

### 1. Clone the Repository

```bash
git clone https://github.com/PhazonicRidley/CMPE-140-CPU
cd CMPE-140-CPU
```

### 2. Open the Project in Vivado

```bash
# Launch Vivado
vivado CPU.xpr
```

Alternatively, open Vivado and select `File > Open Project`, then navigate to `CPU.xpr`.

### 3. Verify Project Settings

- **Target Device**: Ensure your target FPGA device is correctly configured
- **Simulation Settings**: Verify that the testbench is set to `pipeline_tb.sv`

---

## Building the Project

### Synthesis

1. In Vivado, click **Run Synthesis** in the Flow Navigator
2. Wait for synthesis to complete (typically 2-5 minutes)
3. Review the synthesis report for resource utilization and timing

**Expected Results:**
- Synthesis should complete without critical warnings
- Resource utilization should be modest (typically < 5% on modern FPGAs)

### Implementation

1. After successful synthesis, click **Run Implementation**
2. Wait for place and route to complete
3. Review timing reports to ensure timing constraints are met

**Expected Results:**
- Implementation should complete successfully
- All timing constraints should be met (no negative slack)
- Design should route without congestion issues

---

## Running Simulations

### Setting Up a Simulation

1. In Vivado, select **Flow > Run Simulation > Run Behavioral Simulation**
2. The waveform viewer will open automatically
3. Add signals of interest to the waveform viewer

### Available Test Programs

The project includes several test programs located in `CPU.srcs/sim_1/new/`:

| Test File | Description |
|-----------|-------------|
| `r_type.dat` | Tests all R-type arithmetic and logical instructions |
| `i_type.dat` | Tests I-type immediate instructions |
| `load_store.dat` | Tests basic load and store operations |
| `load_store_hazard.dat` | Tests load-use hazard detection and stalling |
| `addi_hazards.dat` | Tests data hazards with ADDI instructions |
| `addi_nohazard.dat` | Baseline test without hazards |

### Running a Specific Test

1. Open `pipeline_tb.sv`
2. Modify the ROM initialization to load your desired test file:
   ```systemverilog
   $readmemb("test_file_name.dat", rom.memory);
   ```
3. Run the simulation
4. Observe the waveform to verify correct behavior

### What to Look For

- **Pipeline Progression**: Instructions should flow through all 5 stages
- **Hazard Handling**: Stalls should be inserted for load-use hazards
- **Forwarding**: Data should bypass from EX/MEM and MEM/WB stages when appropriate
- **Memory Operations**: Byte-enable signals should correctly reflect byte/halfword/word accesses
- **Register Values**: Final register values should match expected results

---

## Test Programs

### Creating Custom Test Programs

Test programs are stored in `.dat` files with binary instruction encoding (32 bits per line).

**Example Assembly to Binary Conversion:**

```assembly
# example.asm
ADDI x1, x0, 5      # Load immediate 5 into x1
ADDI x2, x0, 10     # Load immediate 10 into x2
ADD  x3, x1, x2     # x3 = x1 + x2 = 15
SW   x3, 0(x0)      # Store x3 to memory address 0
```

Use the RISC-V assembler or Python utilities to convert to binary format.

### Using the Binary Converter

```bash
python bin2txt.py input.bin output.dat
```

---

## Results

### Synthesis Results

The design successfully synthesizes with the following characteristics:
- **LUTs Used**: Minimal resource utilization (< 5% on target FPGA)
- **Flip-Flops**: Efficient pipeline register usage
- **Max Frequency**: Meets timing at target clock frequency

### Simulation Verification

All test programs execute correctly with:
- ✅ Correct ALU operations for all supported instructions
- ✅ Proper hazard detection and pipeline stalling
- ✅ Functional data forwarding reducing unnecessary stalls
- ✅ Accurate load-store operations with byte-level granularity
- ✅ Correct byte-enable signal generation for sub-word accesses

### Load-Store Implementation

A key achievement of this project is the byte-enable (`byte_en`) port implementation:
- **4-bit signal** where each bit enables one byte of a 32-bit word
- **Examples**:
  - `4'b1111`: Store/load full word (SW/LW)
  - `4'b0011`: Store/load lower halfword (SH/LH)
  - `4'b0001`: Store/load lowest byte (SB/LB)
  - `4'b0101`: Store/load bytes 0 and 2 (non-contiguous access)

This implementation ensures:
- Stores execute before loads to the same address (proper data initialization)
- All hazards between load-store operations are correctly handled
- Memory operations maintain data integrity at byte granularity

---

## Project Structure

```
CMPE-140-CPU/
├── CPU.xpr                          # Vivado project file
├── CPU.srcs/
│   ├── sources_1/new/               # RTL source files
│   │   ├── cpu.sv                   # Top-level CPU
│   │   ├── fetch.sv                 # Instruction fetch stage
│   │   ├── decode.sv                # Decode stage
│   │   ├── alu.sv                   # Execute stage (ALU)
│   │   ├── mem_access.sv            # Memory access stage
│   │   ├── write_back.sv            # Write back stage
│   │   ├── registers.sv             # Register file
│   │   ├── forwarding.sv            # Forwarding unit
│   │   ├── stall_handler.sv         # Hazard detection
│   │   ├── pipeline_registers_pkg.sv # Pipeline register definitions
│   │   ├── rom.sv                   # Instruction memory
│   │   └── ram.sv                   # Data memory
│   └── sim_1/new/                   # Testbenches and test programs
│       ├── pipeline_tb.sv           # Main testbench
│       ├── r_type.dat               # R-type test program
│       ├── load_store.dat           # Load-store test program
│       └── ...                      # Additional test files
├── bin2txt.py                       # Binary to text converter
└── README.md                        # This file
```

---

## Technical Details

### Byte-Enable Logic

The `byte_en` signal is generated in the `mem_access` module based on the instruction's `func3` field and address alignment:

```systemverilog
// func3 encoding: {MSB indicates sign extension, lower 2 bits indicate size}
// 000: LB/SB (byte), 001: LH/SH (halfword), 010: LW/SW (word)
```

The byte-enable mask shifts based on the lower address bits to correctly align byte and halfword accesses within the 32-bit word.

### Hazard Detection Strategy

1. **Load-Use Hazards**: Detected by comparing destination registers in MEM stage with source registers in ID stage
2. **Data Hazards**: Resolved through forwarding when possible, stalling only when necessary
3. **Control Hazards**: Branch target calculated in EX stage, with pipeline flush on branch taken



