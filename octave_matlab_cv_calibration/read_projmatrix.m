function [projmatrix] = read_projmatrix(filename);
% [projmatrix] = read_projmatrix(filename)
% 
% Чтение проекционной матрицы камеры из файла с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%
% Выходные параметры:
%   projmatrix = 3x4 матрица - проекционная матрица камеры


%открываем файл для чтения
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_projmatrix() : can not open file !'); 
    projmatrix = [];
    return;
end;    
    
%вычитываем JPi
[projmatrix,count] = fscanf(fid,'%f',[4,3]);
projmatrix = projmatrix';
if(count~=12)
    disp('error in read_projmatrix() : can not read projmatrix !'); 
    fclose(fid);
    projmatrix = [];
    return;
end;    

fclose(fid);
return;