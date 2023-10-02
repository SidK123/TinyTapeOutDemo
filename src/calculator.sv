module tt_um_calculator_chip (
    output logic [7:0] NumOut,
    input logic [7:0] NumIn,
    input logic [1:0] OpIn,
    input logic Enter,
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    enum logic [2:0] {START, CALCULATE1, CALCULATE2, CALCULATE3, CALCULATE4, WAIT} currState, nextState1;
    logic [7:0] state, nextState;

    assign NumOut = state;

    always_ff @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
        currState <= START;
        state <= 8'b0;
      end
      else begin
        currState <= nextState1;
        state <= nextState;
      end
    end

    always_comb begin 
      case(currState)
        START: begin
          if(Enter && (OpIn == 2'b00)) begin
            nextState1 = WAIT;
            nextState = NumIn + state;
          end
          else if(Enter && (OpIn == 2'b01)) begin
            nextState1 = WAIT;
            nextState = NumIn - state;
          end
          else if(Enter && (OpIn == 2'b10)) begin
            nextState1 = WAIT;
            nextState = NumIn | state;
          end
          else if(Enter && (OpIn == 2'b11)) begin
            nextState1 = WAIT;
            nextState = (NumIn == state) ? 8'd1 : 8'd0;
          end
          else begin
            nextState1 = START;
            nextState = state;
          end
        end
        WAIT: begin
          if(~Enter) begin
            nextState1 = START;
          	nextState = state;
          end
          else begin
            nextState1 = WAIT;
          	nextState = state;
          end
        end
      endcase
    end

endmodule
