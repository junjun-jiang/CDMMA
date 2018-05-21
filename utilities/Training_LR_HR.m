
%%% Yale 库原始大小为 192*168
function [HR_Test testlabels HR_Train trainlabels LR_Test LR_Train] = Training_LR_HR();

imrow = 32;
imcol = 28;
Train_Num = 32;
factor = 4;

LR_Train  = [];
HR_Train  = [];
LR_Test  = [];
HR_Test  = [];
testlabels   = [];
trainlabels  = [];

Originalfaces = [];
labels = [];


img_dir = 'CroppedYale';       % directory for the image database                       
rt_img_dir = img_dir;

disp('Reading the training set...');
subfolders = dir(rt_img_dir);

for ii = 1:length(subfolders),
    subname = subfolders(ii).name;
    
    if (mod(ii,5) == 0)
        fprintf('Processing  %d/%d...\n',ii,length(subfolders));
    end
    
    if ~strcmp(subname, '.') & ~strcmp(subname, '..')       
        frames = dir(fullfile(rt_img_dir, subname, '*.pgm'));        
        c_num = length(frames);  
%         c_num = 20;
        a=randperm(c_num);        
        for jj = 1:c_num            
            imgpath = fullfile(rt_img_dir, subname, frames(a(jj)).name);            
            I = imread(imgpath);
            IU = imresize(I,[imrow imcol],'bicubic');
            if ndims(I) == 3,
                I = im2double(rgb2gray(I));
            else
                I = im2double(I);
            end;
          
            I = imresize(I,[imrow imcol],'bicubic');
            I2 = imresize(I,[imrow/factor imcol/factor],'bicubic');  
    
            if jj > Train_Num
                HR_Test = [HR_Test reshape(I,imrow*imcol,1)];
                LR_Test = [LR_Test reshape(I2,imrow*imcol/(factor*factor),1)];
                testlabels = [testlabels ii-2];
                Originalfaces = [Originalfaces reshape(IU,imrow*imcol,1)];
                labels = [labels ii-2];
            else
                HR_Train = [HR_Train reshape(I,imrow*imcol,1)];
                LR_Train = [LR_Train reshape(I2,imrow*imcol/(factor*factor),1)];
                trainlabels = [trainlabels ii-2];     
                Originalfaces = [Originalfaces reshape(IU,imrow*imcol,1)];
                labels = [labels ii-2];
            end                       
        end;    
    end;
end;
% save('ExtYaleB_DAT.mat','HR_Test','testlabels','HR_Train','trainlabels','LR_Test','LR_Train');
save('ExtYaleB_Originalfaces.mat','Originalfaces','labels');
disp('done.');