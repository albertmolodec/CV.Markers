function [Ip] = read_Ip(filename);
% [Ip] = read_Ip(filename)
% 
% Вычитывание координат изображений точек калибровочного объекта из файла 
% с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%
% Выходные параметры:
%   Ip = 2xM матрица - 2D-координаты изображений точек JPi калибровочного
%       объекта в системе координат цифрового изображения (I)


%открываем файл для чтения
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_Ip() : can not open file !'); 
    Ip = [];
    return;
end;    

%вычитываем M
[M,count] = fscanf(fid,'%d',1); %count - количество прочитанных чисел
if(count~=1)
    disp('error in read_Ip() : can not read M !'); 
    fclose(fid);
    Ip = [];
    return;
end;   

%проверка значения M
if(M<1)
    disp('error in read_Ip() : invalid M !'); 
end;
    
%вычитываем Ipi
[Ip,count] = fscanf(fid,'%f',[2,M]);
if(count~=2*M)
    disp('error in read_Ip() : can not read Ip !'); 
    fclose(fid);
    Ip = [];
    return;
end;    

fclose(fid);
return;