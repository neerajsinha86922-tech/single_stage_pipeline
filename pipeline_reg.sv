module single_stage_pipeline #(parameter int DATA_WIDTH = 32)
  (
  input  logic                   clk,
  input  logic                   rst_n,
  input  logic                   in_valid,
  input  logic [DATA_WIDTH-1:0]  in_data,
  input  logic                   out_ready,
  output logic                   in_ready,
  output logic                   out_valid,
  output logic [DATA_WIDTH-1:0]  out_data
);

  logic [DATA_WIDTH-1:0] stored_data;
  logic                  has_data;

  assign out_valid = has_data;
  assign out_data  = stored_data;
  assign in_ready  = ~has_data || out_ready;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      has_data   <= 1'b0;
      stored_data <= '0;
    end
    else begin
      case ({in_valid && in_ready, out_ready && out_valid})
        2'b10: begin
          stored_data <= in_data;
          has_data    <= 1'b1;
        end
        2'b01: begin
          has_data <= 1'b0;
        end
        2'b11: begin
          stored_data <= in_data;
          has_data    <= 1'b1;
        end
        default: begin
          has_data <= has_data;
        end
      endcase
    end
  end

endmodule
