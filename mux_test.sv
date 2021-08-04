`timescale 1ns/100ps

module mux_4to1_test;

 localparam WIDTH=4;

   logic [WIDTH-1:0] out;
   logic [WIDTH-1:0] in_a;
   logic [WIDTH-1:0] in_b;
   logic [WIDTH-1:0] in_c;
   logic [WIDTH-1:0] in_d;
   logic             sel_a;
   logic             sel_b;
   logic             sel_c;
   logic             sel_d;

   logic  clk=1'b1;

   `define PERIOD 10ns/1ns

   always begin
     #(`PERIOD/2)  clk= ~clk;
   end


 mux_4to1_Assertion UUT(.out(out), .in_a(in_a), .in_b(in_b), .in_c(in_c), .in_d(in_d), .sel_a(sel_a), .sel_b(sel_b), .sel_c(sel_c), 
                        .sel_d(sel_d), .clk(clk));

 initial 
 begin
     $timeformat(-9,0,"ns");
     $monitor("%t sel_a=%0b sel_b=%0b sel_c=%0b sel_d=%0b in_a=%0h in_b=%0h in_c=%0h in_d=%0h out=%0h",
      $time, sel_a, sel_b, sel_c, sel_d, in_a, in_b, in_c, in_d,  out);
 end



task  outexpect(input logic [WIDTH-1:0] expectvalue);
   if(out !== expectvalue)
   begin
   $display("COUNTER TEST FAILED");
   $display("expect=%0h, actual=%0h", expectvalue, out);
   $finish;
   end
endtask

initial begin
in_a='hA; in_b='hB; in_c='hC; in_d='hD;
end


initial begin
    @(negedge clk)// reset clock
  sel_a = 1'b1; sel_b = 1'b0; sel_c = 1'b0; sel_d = 1'b0; @(negedge clk) outexpect('hA);
  sel_a = 1'b0; sel_b = 1'b1; sel_c = 1'b0; sel_d = 1'b0; @(negedge clk) outexpect('hB);
  sel_a = 1'b0; sel_b = 1'b0; sel_c = 1'b1; sel_d = 1'b0; @(negedge clk) outexpect('hC);
  sel_a = 1'b0; sel_b = 1'b0; sel_c = 1'b0; sel_d = 1'b1; @(negedge clk) outexpect('hD);
$display("COUNTER TEST PASSED");
$finish;
end

endmodule