function [ret] = write_Ip(filename,Ip);
% [ret] = write_Ip(filename,Ip)
% 
% Запись координат изображений точек калибровочного объекта в файл
% с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%   Ip = 2xM матрица - 2D-координаты изображений точек JPi калибровочного
%       объекта в системе координат цифрового изображения (I)
%
% Выходные параметры:
%   ret = число - флаг контроля (0=ошибка,1=данные записаны удачно)

%проверяем размерность матрицы Ip
N = size(Ip,1);
M = size(Ip,2);
if( (N~=2) || (M<1) )
    disp('error in write_Ip() : invalid size of Ip !');
    ret = 0;
    return;
end;

%открываем файл для записи
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_Ip() : can not open file !'); 
    ret = 0;
    return;
end    

%запись M
fprintf(fid,'%d\n',M);

%запись Ip
fprintf(fid,'%10E  %10E \n',Ip);

fclose(fid);
ret = 1;
return;