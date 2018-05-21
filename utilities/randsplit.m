

function [HR_Train LR_Train LR_Test trainlabels testlabels] = randsplit(HR_fea,LR_fea,labels,Train_Num);


Test_Num = 0;

Class_NUM = max(labels);
Index_Train = [];
Index_Test  = [];
Start = 0;
for i = 1:Class_NUM
    c_num      = length(find(labels==i));
    rand_n     = randperm(c_num);
    rand_train = rand_n(1:Train_Num);  
    if Test_Num ~= 0
        rand_test  = rand_n(Train_Num+1:Train_Num+Test_Num);
    else
        rand_test  = rand_n(Train_Num+1:end);
    end
    Index_Train = [Index_Train rand_train+Start];
    Index_Test  = [Index_Test rand_test+Start]; 
    Start = Start + c_num;
end


HR_Train = HR_fea(:,Index_Train);    
trainlabels = labels(Index_Train);
LR_Train   = LR_fea(:,Index_Train);    LR_Test    = LR_fea(:,Index_Test);
testlabels = labels(Index_Test);      