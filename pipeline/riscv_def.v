// uncomment the lines below to enable debug mode
`define DEBUG
`timescale 1ps / 1ps
// ----------------------------------------------------------------------------



`define XLEN 32  // instruction width
`define FUNCT7_WIDTH 7
`define RS_WIDTH 5
`define FUNCT3_WIDTH 3
`define OPCODE_WIDTH 7

`define FUNCT7 31:25
`define RS2 24:20
`define RS1 19:15
`define FUNCT3 14:12
`define RD 11:7
`define OPCODE 6:0

`define PC_WIDTH 32

`define REG_ADDR_WIDTH 5
`define REG_DATA_WIDTH 32
`define REG_SIZE 32

`define IMM_WIDTH 32


`define OP_REG 5'b01100	// R-type, register operation
`define OP_JALR 5'b11001 // I-type, jump and link register  //////
`define OP_IMML 5'b00000 // I-type, load
`define OP_IMMOP 5'b00100 // I-type, immediate operation
// `define OP_IMMFENCE 5'b00011 // I-type, fence instruction
// `define OP_IMMENV 5'b11100 // I-type, environment instruction
// `define OP_IMMCSR 5'b11100 // I-type, control and status register instruction
`define OP_STORE 5'b01000	// S-type, store int
`define OP_BRANCH 5'b11000	// B-type, branch (and jalr)
`define OP_LUI 5'b01101	// U-type, load upper immediate  //////
`define OP_AUIPC 5'b00101	// U-type, add upper immediate to pc
`define OP_JAL 5'b11011	// J-type, jump and link
