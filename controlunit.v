module controlunit
(input zero, [5:0] opcode, funct, output pc_src, jump, we_reg, alu_src, jr, multu, we_dm, [1:0] dm2reg, reg_dst, alusel, [2:0] alu_ctrl);
    wire [1:0] alu_op;
    assign pc_src = branch & zero;
    maindec md (opcode, branch, jump, we_reg, alu_src, we_dm, dm2reg, reg_dst, alu_op);
    auxdec  ad (alu_op, funct, multu, jr, alusel, alu_ctrl);
endmodule