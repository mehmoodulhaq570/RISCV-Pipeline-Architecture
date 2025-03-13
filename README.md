# 🚀 RISC-V Pipeline Architecture Implementation  

Welcome to the **RISC-V Pipeline Architecture** repository, implemented in **SystemVerilog**. This project builds upon a basic single-cycle RISC-V processor and introduces a 5-stage pipelined design with **Control and Status Register (CSR)** support, significantly enhancing performance and functionality.  

---

## 🌟 Features  

### 🏗️ Pipeline Stages  
1. **Instruction Fetch (IF):** Fetches the instruction from memory based on the program counter.  
2. **Instruction Decode (ID):** Decodes the fetched instruction and reads the required registers.  
3. **Execute (EX):** Performs arithmetic or logical operations and calculates memory addresses.  
4. **Memory Access (MEM):** Accesses data memory for load and store operations.  
5. **Write Back (WB):** Writes the result back to the register file.  

### 📜 Supported Instruction Types  
- **R-Type:** ADD, SUB, AND, OR, XOR, etc.  
- **I-Type:** ADDI, SLTI, LW, etc.  
- **U-Type:** LUI, AUIPC.  
- **B-Type:** BEQ, BNE, BLT, etc.  
- **J-Type:** JAL, JALR.  

### 📦 Load and Store Instructions  
- **Load:** LW (Load Word), LH/UH (Load Halfword/Unsigned), LB/UB (Load Byte/Unsigned).  
- **Store:** SW (Store Word), SH (Store Halfword), SB (Store Byte).  

### 🔄 Control and Status Register (CSR) Support  
Provides privileged operation functionality for handling system-level tasks and interrupt handling.  

---

## 📋 Prerequisites  
To run and simulate this project, ensure you have:  
- A SystemVerilog-compatible simulator (e.g., ModelSim, QuestaSim, or Vivado).  
- GTKWave for waveform visualization.  

---

## 🤝 Contributing  
Contributions are welcome! If you’d like to improve the design or report issues, follow these steps:  

1. **Fork the repository** to your own GitHub account.  
2. **Create a pull request** with your proposed changes.  
3. **Open an issue** to discuss ideas or report bugs.  

---

## 📧 Contact  
For any queries or collaborations, feel free to reach out:  
- **Name:** Mehmood Ul Haq  
- **Email:** [mehmoodulhaq1040@gmail.com](mailto:mehmoodulhaq1040@gmail.com)  


