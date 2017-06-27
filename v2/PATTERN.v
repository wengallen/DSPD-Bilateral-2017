module PATTERN(
clk,
rst,
in_valid,
out_valid,
in_addr,
out_addr,
in_data,
out_data,
finish
);

parameter cycle = 10.0;

//////////////////////////////////////////////

output reg        clk;
output reg        rst;
output reg        in_valid;
input             out_valid;
input      [15:0] in_addr;
input      [15:0] out_addr;
output reg [7:0]  in_data;
input      [7:0]  out_data;
input             finish;

//////////////////////////////////////////////
integer i, j, latency, total_latency;
integer fptr,frtr1,frtr2,cnt,error,crti_error,amount;
parameter data_count = 1; // num of dataset

reg [7:0] in_save [0:65535];
reg [7:0] ans_save[0:65535];
reg [7:0] out_save[0:65535];


always #(cycle/2.0) clk = ~clk;


initial begin
    clk = 0;
    rst = 0;
    in_valid = 0;
    in_data = 12'b0;
    
    total_latency = 0;
    latency = 0;
    error = 0;
    crti_error = 0;
    amount = 0;
    
    //LOAD  input data
    $display("\n\n ==== Input saved ===============");
    frtr1 = $fopen("img1.txt","r");
    for(j=0;j<data_count;j=j+1) begin
        for(i=65536*j;i<65536*j+65536;i=i+1)  begin 
            cnt=$fscanf(frtr1, "%d",in_save[i]); 
        end
    end
    $fclose(frtr1);
    
    //LOAD Correct ans
    $display("\n ==== Golden saved ===============");
    frtr2 = $fopen("gold1_v1.txt","r");
    for(j=0;j<data_count;j=j+1) begin
        for(i=65536*j;i<65536*j+65536;i=i+1)  begin 
            cnt=$fscanf(frtr2, "%d",ans_save[i]); 
        end
    end
    $fclose(frtr2);
    
    
    @(negedge clk) rst = 1;
    @(negedge clk) rst = 1;
    @(negedge clk) rst = 1;
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
    // for(j=0;j<data_count;j=j+1) begin
        
        //CHANGE inout, Then drop to 28'bZ
        @(negedge clk)  in_valid = 1;
        in_data = in_save[in_addr];
        total_latency = total_latency + 1;
        
        while(!finish && total_latency<9000) begin
            @(negedge clk) total_latency = total_latency + 1;
            in_data = in_save[in_addr];
            if(out_valid) begin
                out_save[out_addr] = out_data;
            end
            
            if(total_latency%1000 ==0) $display(" total_latency = %d. ",total_latency);
        end
        
        @(negedge clk)  in_valid = 0; 
        
        if(out_valid)
        begin
            $display("--------------------------------------------------------------");
            $display("                   #( ‵□′)───C＜─___-)|||                    ");
            $display("    out_valid and in_valid should not be 1 at the same time");
            $display("--------------------------------------------------------------");
            $finish;
        end
        
        
        latency = 0;
        /*
        // Wait for output valid
        while(!out_valid) begin
            @(negedge clk) latency = latency + 1;
            if(latency == 2000) begin
                $display("--------------------------------------------------------------");
                $display("                   #( ‵□′)───C＜─___-)|||                     ");
                $display("                     Latency too long.                       ");
                $display("--------------------------------------------------------------");                        
                $finish;
            end
        end
        */
        
        /*
        // Save output Data
        if(out_valid) total_latency = total_latency + latency;
        for(i=0;i<65536;i=i+1) begin
            if(out_valid) begin
                @(negedge clk) total_latency = total_latency; 
                // Latency: the time from beginning of input to beginning of output
                // @(negedge clk) total_latency = total_latency + 1;
                out_save[out_addr] = out_data;
            end
        end
        */
        
        //Check with Golden Data
        for(i=0;i<65536;i=i+1) begin
            if( i>1279 && i<64256 && i%256 >4 && i%256<251 ) begin
                amount = amount +1;
                if(out_save[i] != ans_save[i]) begin
                // if(out_save[i] != in_save[i]) begin
                    error=error+1;
                    if((out_save[i]-ans_save[i]>2 && out_save[i]>ans_save[i])|| (ans_save[i]-out_save[i]>2 && ans_save[i]>out_save[i])) 
                    begin
                    crti_error = crti_error+1;
                    end 
                    // $display("--------------------------------------------------------------");
                    // $display("                   #( ‵□′)───C＜─___-)|||                    ");
                    $display("                      WRONG OUTPUT. #%4h                      ",i);
                    $display(" Your output is %3d, but the answer is %3d", out_save[i], ans_save[i]);
                    // $display(" Your output is %3d, but the answer is %3d", out_save[i], in_save[i]);
                    $display("--------------------------------------------------------------");
                    //$finish;
                    // end
                end
            end
        end
        
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        
    // end
    
    
    
    //IF NO ERROR
    fptr = $fopen("out.txt");
    
    // for(j=0; j<data_count; j=j+1)   begin
        // $display("==== Out_save ====== \n");
        // $display("[ Result ] || [  Correct  ] ");
        // $fdisplay(fptr, "==== Out_save ====== \n");
        
        for(i=0; i<65536; i=i+1)   begin
			$fdisplay(fptr, "%d ", out_save[i]);
			// $display ( "%5d || %5d", out_save[i], ans_save[i]);
		end
		$fdisplay(fptr, "\n");
		// $display ("\n");
	// end
	$fclose(fptr);
    
    
    $display("\033[1;33m********************************\033[m");
    $display("\033[1;33mWell Done \033[m");
    $display("\033[1;33m********************************\033[m");
    $display(" \n ");
    if (error < 5) begin
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
    $display("\033[1;32m*******************************************\033[m");
    $display("\033[1;32mYour total latency is = %8d cycles. \033[m",total_latency );
    $display("\033[1;32m*******************************************\033[m");
    $display("\033[1;36m*******************************************\033[m");
    $display("\033[1;36mYour    total Error is   = %8d over %8d . \033[m",error,amount );
    $display("\033[1;36m*******************************************\033[m");
    $display("\033[1;36m*******************************************\033[m");
    $display("\033[1;36mYour critical Error is   = %8d over %8d . \033[m",crti_error,amount );
    $display("\033[1;36m*******************************************\033[m");
    $display("Congratulations!!!. \n\n");
    
    $finish;
end

endmodule
    
