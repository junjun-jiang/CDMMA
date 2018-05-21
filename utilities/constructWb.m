
% construct the Nearest neighbor graph between class
function W = constructWb(fea,labels,k)
% fea = rand(240,3);
% labels = [ones(1,100) 2*ones(1,40) 3*ones(1,60) 4*ones(1,40)];

[nsmp nfea] = size(fea);
W = zeros(nsmp,nsmp);
class_num = max(labels);
Add = 0;
for i = 1:class_num
    feabc = fea(find(labels==i)',:); 
    featemp = fea;
    featemp(find(labels==i)',:) = fea(find(labels==i)',:) - 1e+6;
    feawc = fea(find(labels~=i)',:); 
    dist = EuDist2(feabc,featemp);
    [dump idx] = sort(dist,2); % sort each row
    idx = idx(:,1:k);  
    Add1 = size(find(labels<=i-1),2);
    for m = 1:size(idx,1)
        for n = 1:size(idx,2)            
            W(m+Add1,idx(m,n)) = 1/k;
        end
    end
end



W = (W + W')./2;

