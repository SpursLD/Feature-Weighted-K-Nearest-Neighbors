L = readmatrix('168delectdenoise.xlsx');
L = repelem(L,15,15);
Label = readmatrix('1_0.xlsx');
A_60 = countValues(L);
R_60 = (A_60(:,2)/pi).^0.5*2;
u_60 = unique(L);
A = countValues(Label);
R = (A(:,2)/pi).^0.5*2;
u = unique(Label);
D = setdiff(u,u_60)
for i = 1:length(D)
    r_loss(i) = R(D(i))';
end
r_loss = r_loss'
D1 = intersect(u,u_60)
for i = 1:length(D1)
    r_left(i) = R(D1(i))';
end
r_left = r_left';

function counts = countValues(M)


vals = M(:);                
[uniqueVals, ~, idx] = unique(vals);  
counts = [uniqueVals, accumarray(idx,1)];
end





