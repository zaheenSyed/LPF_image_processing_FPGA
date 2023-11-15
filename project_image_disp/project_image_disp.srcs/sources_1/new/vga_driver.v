module vga_driver(
    input new_clk_25,
    input reset,
    output hsync,
    output vsync,
    output [9:0] xpos,
    output [9:0] ypos
    );
    
// Based on VGA standards found at vesa.org for 640x480 resolution
    // Total horizontal width of screen = 800 pixels, partitioned  into sections
    localparam HD = 640;             // horizontal display area width in pixels
    localparam HF = 16;              // horizontal front porch width in pixels
    localparam HB = 48;              // horizontal back porch width in pixels
    localparam HR = 96;              // horizontal retrace width in pixels
    localparam HMAX = 800; // max value of horizontal counter = 799
    // Total vertical length of screen = 525 pixels, partitioned into sections
    localparam VD = 480;             // vertical display area length in pixels 
    localparam VF = 10;              // vertical front porch length in pixels  
    localparam VB = 29;              // vertical back porch length in pixels   
    localparam VR = 2;               // vertical retrace length in pixels  
    localparam VMAX = 521; // max value of vertical counter = 524   
    
    reg [9:0] row_pixel=0;
    reg [9:0] col_pixel=0;
    
    always @(posedge new_clk_25 or posedge reset) begin
        if (reset) begin
           col_pixel=0;
           row_pixel=0; 
           end
        else begin
        
            if ((row_pixel == (HMAX-1)) && (col_pixel < (VMAX-1))) begin
            col_pixel=col_pixel+1;
            row_pixel=0;
            end
            else if ((row_pixel==(HMAX-1)) && (col_pixel==(VMAX-1))) begin
            col_pixel=0;
            row_pixel=0;
            end
            else begin
            row_pixel = row_pixel+1;
            end
       end
    end
    
//assign hsync=((row_pixel >= (HD+HF)) && (row_pixel < (HD+HB+HR)))?0:1;
//assign vsync=(col_pixel >= (VD+VF) && col_pixel < (VD+VB+VR))? 0:1;

assign hsync=(row_pixel<HR)?0:1;
assign vsync=(col_pixel<VR)?0:1;

assign xpos=row_pixel;
assign ypos=col_pixel;

endmodule
