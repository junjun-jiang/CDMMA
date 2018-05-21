% =========================================================================
% Simple demo codes for LR face recognition via CDMMA
% 
% Reference
% J. Jiang, R. Hu, Z. Wang, and Z. Cai. ¡°CDMMA:Coupled Discriminant Multi-
% Manifold Analysis for Matching Low-Resolution FaceImages,¡± Signal Processing, vol. 124, pp. 162-172, 2016.
% Junjun Jiang
% School of Computer Science, China University of Geosciences, Wuhan, 430074, China
% For any questions, send email to junjun0595@163.com
% =========================================================================

clc;clear all;
addpath('utilities');

Rand_NUM  = 50;

% set parameters
Train_Num = 32; % Extended Yale-B:32, CMU PIE face:25
alpha     = 1; % parameter of objective function
beta      = 0.2; % parameter of objective function
Kw        = 5;  % intra-manifold neighbors
Kb        = 320;% inter-manifold neighbors
no_dims   = 40; % dimensionality of the projected unified discriminative feature space

% Get the HR and LR image pairs
load('.\data\ExtYaleB_Originalfaces.mat');% CMUPIE_Originalfaces ExtYaleB_Originalfaces
HR_fea = Originalfaces;
[LR_fea] = get_training_set(Originalfaces);
Class_NUM = max(labels);

% Nomalize each vector to unit
HR_fea = fea_norm(HR_fea')';
LR_fea = fea_norm(LR_fea')';


for iii = 1:Rand_NUM
    
    fprintf('\n======= CDMMA for face recognition  %d/%d rand =======\n',iii,Rand_NUM);
    % Divide the database into two equal parts randomly
    [HR_Train LR_Train LR_Test trainlabels testlabels] = randsplit(HR_fea,LR_fea,labels,Train_Num);   
    
    % Perform the proposed CDMMA approach
    [LRP_test HRP_Train] = CDMMA(LR_Test,LR_Train,HR_Train,trainlabels,alpha,beta,Kw,Kb,no_dims);% 

    % Classification
    CLASS = knnclassify(LRP_test',HRP_Train',trainlabels,1,'euclidean');
    FR_SR = length(find(CLASS - testlabels' == 0))/size(LR_Test,2);
    fprintf('\n     Face recognition rate of CDMMA: %4.2f%',100*FR_SR);
    re(iii) = FR_SR;    
    mean(re)
end
