function [LR_fea] = get_training_set(Orignalfaces)
% the LR images can be generated from the HR images by down-sampling
imrow_HR = 32;
imcol_HR = 28;
factor = 4;

imrow_LR = imrow_HR/factor;
imcol_LR = imcol_HR/factor;

HR_fea = [];
LR_fea = [];
BI_fea = [];

[nfea nsmp] = size(Orignalfaces);
for i = 1:nsmp
    I = reshape(Orignalfaces(:,i),imrow_HR,imcol_HR);
    Il = imresize(I,[imrow_LR imcol_LR],'bicubic');
    LR_fea = [LR_fea reshape(Il,imrow_LR*imcol_LR,1)];   
end
