module PATTERN(
clk,
rst,
in_valid,
out_valid,
in_addr,
out_addr,
in_data,
out_data
);

parameter cycle = 10.0;

//////////////////////////////////////////////

output reg               clk;
output reg               rst;
output reg               in_valid;
input                    out_valid;
input             [15:0] in_addr;
input             [15:0] out_addr;
output reg signed [8:0]  in_data;
input      signed [8:0]  out_data;

//////////////////////////////////////////////
integer i, j, latency, total_latency;
integer fptr,frtr1,frtr2,cnt,error,error_loose;
parameter data_count = 1; // num of dataset

reg signed [8:0] in_Real_save [0:65535];
reg signed [8:0] ans_Real_save[0:65535];
reg signed [8:0] out_Real_save[0:65535];


always #(cycle/2.0) clk = ~clk;


initial begin
    clk = 0;
    rst = 0;
    in_valid = 0;
    in_data = 12'b0;
    
    total_latency = 0;
    latency = 0;
    error =0;
    error_loose=0;
    
    //LOAD  input data
    $display("\n\n ==== In_save ===============");
    frtr1 = $fopen("img1.txt","r");
    for(j=0;j<data_count;j=j+1) begin
        $display("\n == input %1d Real ==",j+1);
        for(i=65536*j;i<65536*j+65536;i=i+1)  begin 
            cnt=$fscanf(frtr1, "%d",in_Real_save[i]); 
            // $display("%d ", in_Real_save[i]);
        end
    end
    $fclose(frtr1);
    
    //LOAD Correct ans
    $display("\n\n ==== Ans_save ===============");
    frtr2 = $fopen("gold1.txt","r");
    for(j=0;j<data_count;j=j+1) begin
        $display("\n == ans %1d Real ==",j+1);
        for(i=65536*j;i<65536*j+65536;i=i+1)  begin 
            cnt=$fscanf(frtr2, "%d",ans_Real_save[i]); 
            // $display("%d ", ans_Real_save[i]);
        end
    end
    $fclose(frtr2);
    
    
    @(negedge clk) rst = 1;
    @(negedge clk) rst = 0;
    
    @(negedge clk); 
    
    //CHECK out_valid==0
    if(out_valid == 0); 
    else begin
        $display("--------------------------------------------------------------");
        $display("                   #( ‵□′)───C＜─___-)|||                    ");
        $display("             out_valid should be 0 after reset.               ");
        $display("--------------------------------------------------------------");
        $finish;
    end
    
    
    
    
    //Run #6 Patterns, $finish when any error occur
    for(j=0;j<data_count;j=j+1) begin
        
        //CHANGE inout, Then drop to 28'bZ
        @(negedge clk)  in_valid = 1;
        in_data = in_Real_save[(65536*j)];
        total_latency = total_latency + 1;
        for(i=(65536*j+1);i<(65536*j+65536);i=i+1) begin
            @(negedge clk) total_latency = total_latency + 1;
            in_data = in_Real_save[(i)];
        end
        
        @(negedge clk)  in_valid = 0; //inout_data = 28'bz;
        
        if(out_valid)
        begin
            $display("--------------------------------------------------------------");
            $display("                   #( ‵□′)───C＜─___-)|||                    ");
            $display("    out_valid and in_valid should not be 1 at the same time");
            $display("--------------------------------------------------------------");
            $finish;
        end
        
        
        latency = 0;
        while(!out_valid) begin
            
            @(negedge clk) latency = latency + 1;
            if(latency == 2000) 
            begin
                $display("--------------------------------------------------------------");
                $display("                   #( ‵□′)───C＜─___-)|||                    ");
                $display("         j= %d         Latency too long.                       ",j);
                $display("--------------------------------------------------------------");                        
                $finish;
            end
        end
        
        if(out_valid) total_latency = total_latency + latency;
        for(i=(65536*j);i<(65536*j+65536);i=i+1) begin
            if(out_valid) begin
                @(negedge clk) total_latency = total_latency; 
                // Latency: the time from beginning of input to beginning of output
                // @(negedge clk) total_latency = total_latency + 1;
                out_Real_save[i] = out_data;
            end
        end
        
        
        for(i=(65536*j);i<(65536*j+65536);i=i+1) begin
            if(out_Real_save[i] != ans_Real_save[i]) begin
                error=error+1;
                if(out_Real_save[i] - ans_Real_save[i]>1||out_Real_save[i] - ans_Real_save[i]<-1) error_loose=error_loose+1;
                $display("--------------------------------------------------------------");
                $display("                   #( ‵□′)───C＜─___-)|||                    ");
                $display("                      WRONG Real OUTPUT.                      ");
                $display("                        j= %d  #%d                            ",j,i-65536*j);
                $display(" Your output is %d, but the answer is %d", out_Real_save[i], ans_Real_save[i]);
                $display("--------------------------------------------------------------");
                //$finish;
            end
        end
        
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        
    end
    
    
    
    //IF NO ERROR
    fptr = $fopen("img1_out_me.txt");
    
    for(j=0; j<data_count; j=j+1)   begin
        $display("==== Out_save[%1d] ====== \n",j);
        $fdisplay(fptr, "==== Out_save[%1d] ====== \n",j);
        
        $display("[ Re ] || [  Correct  ] ");
        for(i=(65536*j); i<(65536*j+65536); i=i+1)   begin
			$fdisplay(fptr, "%d ", out_Real_save[i]);
			$display ( "%d || %d", out_Real_save[i], ans_Real_save[i]);
		end
		$fdisplay(fptr, "\n");
		$display ("\n");
	end
	$fclose(fptr);
    
    
    $display("\033[1;33m********************************\033[m");
    $display("\033[1;33mWell Done \033[m");
    $display("\033[1;33m********************************\033[m");
    $display(" \n ");
    if (error >5) begin
        $display("\033[1;35m********************************\033[m");
        $display("\033[1;35m      ╭╮         \033[m");
        $display("\033[1;35m      ││           \033[m");
        $display("\033[1;35m█—————┘╰—╮          \033[m");
        $display("\033[1;35m█      ——╯        \033[m");
        $display("\033[1;35m█   　 ——╣   You have passed this pattern!!\033[m");
        $display("\033[1;35m█ˍˍˍˍˍ ——╯          \033[m");
        $display("\033[1;35m█     ╰——╯         \033[m");
        $display("\033[1;35m                   \033[m");
        $display("\033[1;35m********************************\033[m");
    end
    else begin
        $display("\033[1;35m !!!!!! Too Much ERROR !!!!!! \033[m");
    end
    $display(" \n ");
    $display("\033[1;32m********************************\033[m");
    $display("\033[1;32mYour total latency is = %d cycles. \033[m",total_latency );
    $display("\033[1;32m********************************\033[m");
    // $display(" \n ");
    $display("\033[1;36m********************************\033[m");
    $display("\033[1;36mYour total Error is = %d over 64 points. \033[m",error );
    $display("\033[1;36m********************************\033[m");
    $display("\033[1;36mYour Looes Error is = %d over 64 points. \033[m",error_loose );
    $display("\033[1;36m********************************\033[m");
    $display("Congratulations!!!. \n\n");
    
    $finish;
end

//==== sequential part ===================
/* always@(posedge clk) begin
   inout_data <= in_data;
end */


endmodule
    
