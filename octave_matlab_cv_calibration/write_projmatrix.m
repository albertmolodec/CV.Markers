function [ret] = write_projmatrix(filename,projmatrix);
% [ret] = write_projmatrix(filename,projmatrix)
% 
% Запись проекционной матрицы камеры в файл с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%   projmatrix = 3x4 матрица - проекционная матрица камеры
%
% Выходные параметры:
%   ret = число - флаг контроля (0=ошибка,1=данные записаны удачно)

%открываем файл для записи
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_projmatrix() : can not open file !'); 
    ret = 0;
    return;
end    

%запись projmatrix
fprintf(fid,'%14E  %14E  %14E  %14E\n',projmatrix');

fclose(fid);
ret = 1;
return;