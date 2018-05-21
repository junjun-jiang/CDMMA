function [LRP_test HRP_Train] = CDMMA(LR_Test,LR_Train,HR_Train,trainlabels,alpha,beta,Kw,Kb,no_dims)

X = fea_norm(LR_Train')';
Y = fea_norm(HR_Train')';

TrainNum = size(Y,2);
nfea = size(X,1);
fea = Y';
gnd = trainlabels;

% Construct two similarity graphs on the multi-manifold,
Ww = constructWw(Y',trainlabels,Kw);
Dw_L = diag(sum(Ww,2));
Dw_H = diag(sum(Ww,1));

Wb = constructWb(Y',trainlabels,Kb);
Db_L = diag(sum(Wb,2));
Db_H = diag(sum(Wb,1));

% 
II = 1*kron([1,-1;-1,1],eye(TrainNum,TrainNum));
Q = [alpha*Dw_L-beta*Db_L -alpha*Ww+beta*Wb;-alpha*Ww'+beta*Wb' alpha*Dw_H-beta*Db_H]+II;
Z = [X zeros(size(X,1),size(Y,2));zeros(size(Y,1),size(X,2)) Y];
F = Z*Z';
F = F+1e-6*eye(size(X,1)+size(Y,1),size(X,1)+size(Y,1));
E = Z*Q*Z';

% Perform eigendecomposition of inv(F)*E
options.Disp = 0;
options.LSolver = 'bicgstab';
[LY, evals] = eigs(E, F, no_dims + 1, 'SM', options);
[evals, ind] = sort(diag(evals), 'ascend');
P = LY(:,ind(2:end));

% Project face image into the unified discriminative feature space
LHRP_Train = P'*Z;
HRP_Train = LHRP_Train(:,TrainNum+1:end);
LRP_test = P(1:nfea,:)'*LR_Test;