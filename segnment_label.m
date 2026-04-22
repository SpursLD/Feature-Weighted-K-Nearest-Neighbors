Z = 2520;
model = readmatrix("1_0.xlsx"); 

vec = zeros(Z*Z,3);

for i = 1:Z
    for j = 1:Z
        color = model(i,j,:);
        vec((i-1)*Z+j,:) = color;
    end
end

[d,~,n] = unique(vec,"rows",'stable');
w = length(d);

B = zeros(Z,Z);
B1 = zeros(Z,Z);
for i = 1:length(d)
    a = find(n == i);    
    for j = 1:length(a)
        A(j,2) =mod(a(j),Z);
        if A(j,2) ==  0
           A(j,2) = Z; 
        end
        A(j,1) = floor(a(j)/Z) + 1;
        if mod(a(j),Z) == 0
           A(j,1) = floor(a(j)/Z) ;
        end
    end
    B1 = zeros(Z,Z);
    for k = 1: length(a)
        B(A(k,1),A(k,2)) = i;

        B1(A(k,1),A(k,2)) = i;
    end
    CC = bwconncomp(B1,4);
    C(i) = CC.NumObjects;
    if C(i) >1
       for o = 2 : CC.NumObjects
           B1(cell2mat(CC.PixelIdxList(o))) =  w + o-1;
           B(cell2mat(CC.PixelIdxList(o))) =  w + o-1;
       end
       w = w + CC.NumObjects-1;
    end
    CC = [];
end
B2 = B(1,:);
B3 = B(Z,:);
B4 = B(:,1);
B5 = B(:,Z);

B8 = unique([B2(:),B3(:),B4(:),B5(:)]);
B9 = zeros(w,1);
B9(B8) =1;
B10 = find(B9 ==0)
unique(B);
unique(B1)
for i = 1 : length(B10)
    ind = find(B == B10(i));
    a1(i) = length(ind);
end
a1=(a1/3.14).^(0.5)*(2520/Z)*2;
a1 = a1';
filename ='1_0.xlsx'
xlswrite(filename,B,1,'A1')
