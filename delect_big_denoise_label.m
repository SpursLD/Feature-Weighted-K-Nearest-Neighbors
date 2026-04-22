%%%a2 = sizethresholds

file_path = ['E:\paper5\1-0.5\'];
img_path_list = dir(strcat(file_path,'*.xlsx'))
img_num = length(img_path_list)
for I6 = 1:img_num
     image_name = img_path_list(I6).name;
     model = readmatrix(image_name);
     Z = length(model);
     delect_Denoise(model,Z)

end




function delect_Denoise(model,Z)
    %model = imread(image_name);
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
    end   
        if C(i) >1
            for o = 2 : CC.NumObjects
                B1(cell2mat(CC.PixelIdxList(o))) =  w + o-1;
                B(cell2mat(CC.PixelIdxList(o))) =  w + o-1;
            end
            w = w + CC.NumObjects-1;
        end

    
    
    for i =1:w
        I2 = find(B == i);
        
        a1(i) = length(I2);
    end
    
    a2 = find(a1<10);
    
    model1 = model;
    for j = 1:length(a2)
        a3 = find(B == a2(j));
        [x, y] = ind2sub(size(B),a3);
        
        for k =1:length(x)
            if y>1 & y<Z
                model1(x(k),y(k),:) = 0;
            end
            if x>1 & x<Z
                model1(x(k),y(k),:) = 0;
            end
        end 
    end
    for I = 1:20
    model = model1;
    vec = zeros(Z*Z,3);

    for i = 1:Z
        for j = 1:Z
            color = model(i,j,:);
            vec((i-1)*Z+j,:) = color;
        end
    end

    Vec = all(vec ==0,2);
    VEc = find(Vec == 1);
    B = zeros(Z,Z);
    [x, y] = ind2sub(size(B),VEc);
    for i = 1:length(x)
        X = [x(i)-1,y(i);
            x(i)+1,y(i);
            x(i),y(i)-1;
            x(i),y(i)+1;
            x(i)-1,y(i)-1;
            x(i)-1,y(i)+1;        
            x(i)+1,y(i)-1;
            x(i)+1,y(i)+1;];
        [X1,Y1] = find(X == Z+1);
        X(X1,:) = [];
        [X2,Y2] = find(X == 0);
        X(X2,:) = [];
        Model = zeros(1,3);
        for j = 1:length(X)
            Model(j,:) = model(X(j,2),X(j,1),:);
        end 
        Model(find(sum(abs(Model),2)==0),:)=[];
        if sum(Model,'all') == 0
            continue    
        end
        [d,w,n] = unique(Model,"rows",'stable');
        table = tabulate(n);
        [maxCount,idx] = max(table(:,2));
        if maxCount<4
           continue
        end
        model1(y(i),x(i),1) = Model(idx,1);

    end
end
for I = 1:10
    model = model1;
    vec = zeros(Z*Z,3);

    for i = 1:Z
        for j = 1:Z
            color = model(i,j,:);
            vec((i-1)*Z+j,:) = color;
        end
    end

    Vec = all(vec ==0,2);
    VEc = find(Vec == 1);
    B = zeros(Z,Z);
    [x, y] = ind2sub(size(B),VEc);
    for i = 1:length(x)
        X = [x(i)-1,y(i);
            x(i)+1,y(i);
            x(i),y(i)-1;
            x(i),y(i)+1;
            x(i)-1,y(i)-1;
            x(i)-1,y(i)+1;        
            x(i)+1,y(i)-1;
            x(i)+1,y(i)+1;];
        [X1,Y1] = find(X == Z+1);
        X(X1,:) = [];
        [X2,Y2] = find(X == 0);
        X(X2,:) = [];
        Model = zeros(1,3);
        for j = 1:length(X)
            Model(j,:) = model(X(j,2),X(j,1),:);
        end 
        Model(find(sum(abs(Model),2)==0),:)=[];
        if sum(Model,'all') == 0
            continue    
        end
        [d,w,n] = unique(Model,"rows",'stable');
        table = tabulate(n);
        [maxCount,idx] = max(table(:,2));
        if maxCount<3
           continue
        end
        model1(y(i),x(i),1) = Model(idx,1);

        
    end
end
for I = 1:10
    model = model1;
    vec = zeros(Z*Z,3);

    for i = 1:Z
        for j = 1:Z
            color = model(i,j,:);
            vec((i-1)*Z+j,:) = color;
        end
    end

    Vec = all(vec ==0,2);
    VEc = find(Vec == 1);
    B = zeros(Z,Z);
    [x, y] = ind2sub(size(B),VEc);
    for i = 1:length(x)
        X = [x(i)-1,y(i);
            x(i)+1,y(i);
            x(i),y(i)-1;
            x(i),y(i)+1;
            x(i)-1,y(i)-1;
            x(i)-1,y(i)+1;        
            x(i)+1,y(i)-1;
            x(i)+1,y(i)+1;];
        [X1,Y1] = find(X == Z+1);
        X(X1,:) = [];
        [X2,Y2] = find(X == 0);
        X(X2,:) = [];
        Model = zeros(1,3);
        for j = 1:length(X)
            Model(j,:) = model(X(j,2),X(j,1),:);
        end 
        Model(find(sum(abs(Model),2)==0),:)=[];
        if sum(Model,'all') == 0
            continue    
        end
        [d,w,n] = unique(Model,"rows",'stable');
        table = tabulate(n);
        [maxCount,idx] = max(table(:,2));
        if maxCount<2
           continue
        end
        model1(y(i),x(i),1) = Model(idx,1);


        
    end
end
     name = num2str(Z);
     extension = 'delectdenoise.xlsx';
     folder = 'E:\paper5\1-0.5';
     filename = fullfile(folder,[name,extension]);
    writematrix(model,filename,'WriteMode', 'overwrite')

end




