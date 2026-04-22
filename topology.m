
file_path = ['E:\deeplearning\1-0.75\'];
img_path_list = dir(strcat(file_path,'*.png'))
img_num = length(img_path_list)
%Import image
for I6 = 1:img_num
     image_name = img_path_list(I6).name;
     [filepath, name, ext] = fileparts(image_name);
     model = imread(image_name);
     Z = length(model);
     topology(model,Z,name)
     
end


function topology(model,Z,name)

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
    %surface
    B2 = B(1,:);
    B3 = B(Z,:);
    B4 = B(:,1);
    B5 = B(:,Z);
    B8 = unique([B2(:),B3(:),B4(:),B5(:)]);
    B9 = zeros(w,1);
    B9(B8) =1;
    B10 = find(B9 ==0);
    %Increase the resolution
    B = repelem(B,4,4);
    L37=zeros(length(B10),1);
    L47=zeros(length(B10),1);
    %Extract the pixel D8 at the grain boundary of each grain
    for i =1:length(B10)
        ind = find(B == B10(i));
        a1(i) = 2*((length(ind)/pi)^0.5)/4;
        [x, y] = ind2sub(size(B),ind);
        D = [x, y];
        D1 = [x+1, y];
        D2 = [x-1, y];
        D3 = [x, y+1];
        D4 = [x, y-1];
        D11 = setdiff(D,D1,"rows");
        D21 = setdiff(D,D2,"rows");
        D31 = setdiff(D,D3,"rows");
        D41 = setdiff(D,D4,"rows");
        D7 = [D11;D21;D31;D41];
        D8 = unique(D7,'row','stable');
        X = D8(:,1);
        Y = D8(:,2);
        %     Z = D8(:,3);
        D12 = zeros();
        D13 = zeros();
        D14 = zeros();
        D15 = [];
        D17 = zeros();
        D19 = zeros(1,4);
        D191 = [];
        D20 = [];
        D21 = zeros(1,9);
        %8 nearest-neighbour pixels
        for k = 1:length(X)
            D12 = [X(k),Y(k);
                X(k)-1,Y(k);
                X(k)+1,Y(k);
                X(k),Y(k)-1;
                X(k),Y(k)+1;
                X(k)-1,Y(k)-1;
                X(k)-1,Y(k)+1;
                X(k)+1,Y(k)-1;
                X(k)+1,Y(k)+1];

            for l = 1:length(D12)
                D13(l,:) = B(D12(l,1),D12(l,2));
            end
            D21(k,:) = D13';
        end
        D21 = sort(D21,2);
        D214 = zeros(1,27);
        for L = 1:size((D21),1)
            %length(unique(D21(L,:)))
            D214(L,:) = [unique(D21(L,:)), zeros(1,27 - length(unique(D21(L,:))))];
        end
        %All adjacent results for unD214
        [unD214, ~, subs] = unique(D214,"rows");
        %D211: Number of occurrences for each result
        D211 = accumarray(subs,1);

        %D2110 = find(D211 == 1);
        %D212 = length(find(D211 == 1));
        D213 =unD214(:,3);
        D215 = find(D213 == 0);
        %D216：Number of grain boundaries
        D216(i) = length(D215);
        D217 =unD214(:,4);
        D218 = find(D217 == 0);
        %D2191: The number of triple vertices
        D219= setdiff(D218,D215);
        D2191(i) = length(D219);
        D2111 = unD214(:,5);
        D2112 = find(D2111 == 0);
        %L91: The number of quadruple vertices
        L9 = setdiff(D2112,D218);
        L91(i) = length(L9);
        L92 = L91 + D2191;
       
    end
    data = [a1',D216',D2191',L91',L92'];
    title = {'grainsize','lines','3t','4t','t'};
    result = [title; num2cell(data)];
    name = char(name);
    filename = [name,'.xlsx'];
    writecell(result,filename,'Sheet','sheet2')
end







