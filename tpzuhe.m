file_path = ['E:\备份\paper5\1-0.9\delete1\'];
excel_path_list = dir(strcat(file_path,'*.xlsx'));
excel_num = length(excel_path_list);
for i = 1:excel_num
     excel_name = excel_path_list(i).name;
     [num, txt, raw] = xlsread(excel_name);
     
     selectedColumns = raw(2:length(raw),[1:4]);
     
     selectedColumns = cell2mat(selectedColumns);
     numbers = regexp(excel_name, '\d+', 'match'); 
     name(i) = str2double(numbers);
     a(i) = length(selectedColumns);
     b(i) = round(sum(selectedColumns(:,2))/2);
     c(i) = round(sum(selectedColumns(:,3))/3) + round(sum(selectedColumns(:,4))/4);
     d(i) = mean(selectedColumns(:,1));
     e(i) = median(selectedColumns(:,1));
     f(i) = std(selectedColumns(:,1));
end
data = [name',a',b',c',d',e',f'];
title = {'resolution','number','bounadry','vertices','mean','median','std'};
result = [title; num2cell(data)];
name = '0.9_1';
filename = [name,'.xlsx'];
writecell(result,filename,'Sheet','sheet2')

