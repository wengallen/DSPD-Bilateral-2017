clc;clear all;
%% Initial
bflt_img1 = uint8(zeros(256));
ref1 = uint8(zeros(256));
img1_ref = double(imread('img1_v2_w_05_S_03_0.1.png'));

%% 8*8小格子 先直後橫
fid=fopen('out_v1.txt','r'); %輸入數字檔 檔名
for L=1:256
    for K=1:256
        temp = fscanf(fid,'%s',1);
        if(temp == 'x') 
            temp=0;
        else
            temp = str2double(temp);
        end;
        bflt_img1(L,K) = temp;
    end;
end;
fclose(fid);

filepath=['img1_out.jpg']; %輸出圖片檔 檔名
imwrite(bflt_img1,filepath);

for L=6:251
    for K=6:251
        ref1(L,K) = img1_ref(L,K);
    end;
end;

bflt_img1 = double(bflt_img1);
ref1      = double(ref1);

SNR =  20*log10( sum(sum((bflt_img1*255).^2)) / sum(sum( (bflt_img1*255-ref1*255).^2  ))  );
disp(SNR);
