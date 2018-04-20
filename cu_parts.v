module maindec
(input [5:0] opcode, output branch, jump, we_reg, alu_src, we_dm, [1:0] dm2reg, reg_dst, [1:0] alu_op);
    reg [10:0] ctrl;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_op} = ctrl;
    always @ (opcode)
    begin
        case (opcode)
            6'b00_0000: ctrl = 11'b0_0_01_1_0_0_00_10; // R-type
            6'b00_1000: ctrl = 11'b0_0_00_1_1_0_00_00; // ADDI
            6'b00_0100: ctrl = 11'b1_0_00_0_0_0_00_01; // BEQ
            6'b00_0010: ctrl = 11'b0_1_00_0_0_0_00_00; // J
            6'b10_1011: ctrl = 11'b0_0_00_0_1_1_00_00; // SW
            6'b10_0011: ctrl = 11'b0_0_00_1_1_0_01_00; // LW
            6'b00_0011: ctrl = 11'b0_1_10_1_0_0_10_00; // JAL

            default:    ctrl = 11'bx_x_xx_x_x_x_xx_xx;
        endcase
    end
endmodule

module auxdec
(input [1:0] alu_op, [5:0] funct, output multu, jr, [1:0] alusel, [2:0] alu_ctrl);
    reg [6:0] ctrl;
    assign {alu_ctrl, multu, jr, alusel} = ctrl;
    always @ (*)
    begin
        case (alu_op)
            2'b00: ctrl = 7'b010_0_0_00; // add
            2'b01: ctrl = 7'b110_0_0_00; // sub
            default: case (funct)
                6'b10_0100: ctrl = 7'b000_0_0_00; // AND
                6'b10_0101: ctrl = 7'b001_0_0_00; // OR
                6'b10_0000: ctrl = 7'b010_0_0_00; // ADD
                6'b10_0010: ctrl = 7'b110_0_0_00; // SUB
                6'b10_1010: ctrl = 7'b111_0_0_00; // SLT
                6'b01_1001: ctrl = 7'b000_1_0_00; // MULTU
                6'b01_0000: ctrl = 7'b000_0_0_01; // MFHI
                6'b01_0010: ctrl = 7'b000_0_0_10; // MFLO
                6'b00_1000: ctrl = 7'b010_0_1_00; // JR
                default:    ctrl = 7'bxxx_x_x_xx;
            endcase
        endcase
    end
endmodule