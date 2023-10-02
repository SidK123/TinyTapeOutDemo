module tt_um_calculator_chip (
    output logic [7:0] NumOut,
    input logic [7:0] NumIn,
    input logic [1:0] OpIn,
    input logic Enter,
    input logic Reset,

    input logic clock
);

    enum logic [2:0] {START, CALCULATE1, CALCULATE2, CALCULATE3, CALCULATE4, WAIT} currState, nextState1;
    logic [7:0] state, nextState;

    assign NumOut = state;

    always_ff @(posedge clock, posedge Reset) begin
      if(Reset) begin
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