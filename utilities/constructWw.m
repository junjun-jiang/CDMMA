
% construct the Nearest neighbor graph between class

function W = constructWw(fea,labels,k)
% fea = rand(240,3);
% labels = [ones(1,100) 2*ones(1,40) 3*ones(1,60) 4*ones(1,40)];


[nsmp nfea] = size(fea);
W = zeros(nsmp,nsmp);
class_num = max(labels);
Add = 0;
for i = 1:class_num
    feabc = fea(find(labels==i)',:); 
    dist = EuDist2(feabc,feabc); 
    [dump idx] = sort(dist,2); % sort each row
    idx = idx(:,2:k);
%     dump = dump(:,1:3+1)    
    for m = 1:size(idx,1)
        for n = 1:size(idx,2)            
            W(Add+m,Add+idx(m,n)) = 1/(k);
        end
    end
    Add = size(find(labels<=i),2);
end

W = (W + W')./2;
