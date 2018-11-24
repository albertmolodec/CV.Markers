function [JP] = read_JP(filename);
% [JP] = read_JP(filename)
% 
% Вычитывание координат точек калибровочного объекта из файла 
% с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%
% Выходные параметры:
%   JP = 3xM матрица - 3D-координаты точек калибровочного объекта
%       в собственной системе координат объекта (J), столбцы матрицы
%       соответствуют векторам JPi

%открываем файл для чтения
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_JP() : can not open file !'); 
    JP = [];
    return;
end;    

%вычитываем M
[M,count] = fscanf(fid,'%d',1); %count - количество прочитанных чисел
if(count~=1)
    disp('error in read_JP() : can not read M !'); 
    fclose(fid);
    JP = [];
    return;
end;   

%проверка значения M
if(M<1)
    disp('error in read_JP() : invalid M !'); 
end;
    
%вычитываем JPi
[JP,count] = fscanf(fid,'%f',[3,M]);
if(count~=3*M)
    disp('error in read_JP() : can not read JP !'); 
    fclose(fid);
    JP = [];
    return;
end;    

fclose(fid);
return;