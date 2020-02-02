[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

% import input images
clc;
clear all;
close all;
C = input('Enter Cover image: ', 's');
S = input('Enter Secret image: ', 's');
C = imread(C);         % cover image
S = imread(S);         % Secret image
 figure,imshow(C),title('Cover Image');
C = double(C);
figure,imshow(S),title('secret Image');
S = double(S);
[M N] = size(S);
bs = 2;
bn = M/bs;
t=bs*ones(1,bn);
Sa = mat2cell(S,t,t);
% -----------------------------------------------
for i = 1:bn
    for j = 1:bn
        [s_v,s_e] = eig(Sa{i,j});
        Q{i,j} = s_v;
        F = Q{i,j};
Q_in{i,j} = inv(F);
T = (Q_in{i,j}*Sa{i,j});
A = T*Q{i,j};
df = max(max(A));
Temp{i,j} = df;
Ai{i,j} = A/Temp{i,j};
    end
end
% -----------------------------------------------
% Combining cells into matrix
p1 = 1;
p2 =1;
for i = 1:bn
    for j = 1:bn
        x = p1:p1+(bs-1);
        y = p2:p2+(bs-1);
        S_0(x,y) = Ai{i,j};
          
        p2 = p2+bs;
    end
    p1=p1+bs;
    p2=1;
end
St1 = C+S_0;
figure,imshow(uint8(St1)),title('stego1 Image');
St2 = C-S_0;
figure,imshow(uint8(St2)),title('stego2 Image');
[MSE,PSNR,AD,SC,NCC,MD,LMSE,NAE]=iq_measures(C,St1,'disp');
[MSE,PSNR,AD,SC,NCC,MD,LMSE,NAE]=iq_measures(C,St2,'disp');


% % % % % % % % % % % % % % % % % % % % % % % % % % % %
%  Recovering procedure %

C= (St1+St2)/2;
figure,imshow(uint8(C)),title('Recovered cover');
S_0 = St1-C;
% S_0 = C-St2;

S_0a = mat2cell(S_0, t,t);
for i = 1:bn
    for j = 1:bn
        Rs{i,j} = S_0a{i,j}*Temp{i,j};
   rc{i,j} = Q{i,j}*Rs{i,j};
s_r{i,j} = rc{i,j}*Q_in{i,j};
    end
end
% Combining cells into matrix
p1 = 1;
p2 =1;
for i = 1:bn
    for j = 1:bn
        x = p1:p1+(bs-1);
        y = p2:p2+(bs-1);
        S_r(x,y) = s_r{i,j};
        p2 = p2+bs;
    end
    p1=p1+bs;
    p2=1;
end

figure,imshow(uint8(S_r));title('Recovered secret');
%[MSE,PSNR,AD,SC,NK,MD,LMSE,NAE]=iq_measures(S_r,S,'disp');
% [MSE,PSNR,AD,SC,NK,MD,LMSE,NAE]=iq_measures(C,St1,'disp');
