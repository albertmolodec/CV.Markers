function [ret] = write_JP(filename,JP);
% [ret] = write_JP(filename,JP)
% 
% Запись координат точек калибровочного объекта в файл с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%   JP = 3xM матрица - 3D-координаты точек калибровочного объекта
%       в собственной системе координат объекта (J), столбцы матрицы
%       соответствуют векторам JPi
%
% Выходные параметры:
%   ret = число - флаг контроля (0=ошибка,1=данные записаны удачно)

%проверяем размерность матрицы JP
N = size(JP,1);
M = size(JP,2);
if( (N~=3) || (M<1) )
    disp('error in write_JP() : invalid size of JP !');
    ret = 0;
    return;
end;

%открываем файл для записи
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_JP() : can not open file !'); 
    ret = 0;
    return;
end    

%запись M
fprintf(fid,'%d\n',M);

%запись JP
fprintf(fid,'%10E  %10E  %10E\n',JP);

fclose(fid);
ret = 1;
return;