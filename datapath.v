module datapath(input clk, rst, pc_src, jump, we_reg, alu_src, jr, multu, [1:0] dm2reg, reg_dst, alusel, [2:0] alu_ctrl, [4:0] ra3, [31:0] instr, rd_dm, output zero, [31:0] pc_current, alu_out, wd_dm, rd3);
    wire [4:0]  rf_wa;
    wire [31:0] pc_plus4, pc_pre, pc_next, pc_final, sext_imm, ba, bta, jta, alu_pa, alu_pb, wd_rf, hi, lo, result;
    wire [63:0] prod;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    // --- PC Logic --- //
    dreg       pc_reg     (clk, rst, pc_final, pc_current);
    adder      pc_plus_4  (pc_current, 4, pc_plus4);
    adder      pc_plus_br (pc_plus4, ba, bta);
    mux2 #(32) pc_src_mux (pc_src, pc_plus4, bta, pc_pre);
    mux2 #(32) pc_jmp_mux (jump, pc_pre, jta, pc_next);
    mux2 #(32) pc_jr_mux  (jr, pc_next, alu_pa, pc_final); 
    // --- RF Logic --- //
    mux4 #(5)  rf_wa_mux  (reg_dst, instr[20:16], instr[15:11], 31, 5'b00000, rf_wa);
    regfile    rf         (clk, we_reg, instr[25:21], instr[20:16], ra3, rf_wa, wd_rf, alu_pa, wd_dm, rd3);
    signext    se         (instr[15:0], sext_imm);
    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (alu_src, wd_dm, sext_imm, alu_pb);
    alu        alu        (alu_ctrl, alu_pa, alu_pb, zero, alu_out);
    assign prod = alu_pa * alu_pb;
    flop high (clk, rst, multu, prod[63:32], hi);
    flop low (clk, rst, multu, prod[31:0], lo);
    // --- MEM Logic --- //
    mux4 #(32) alu4mux (alusel, alu_out, hi, lo, 5'b00000, result);
    mux4 #(32) rf_wd_mux  (dm2reg, result, rd_dm, pc_plus4, 32'b0, wd_rf);
endmodule