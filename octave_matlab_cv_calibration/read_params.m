function [alpha,beta,theta,x0,y0,R,t] = read_params(filename);
% [alpha,beta,theta,x0,y0,R,t] = read_params(filename)
% 
% Чтение внутренних и внешних параметров камеры из файла с заданным именем
%
% Входные параметры:
%   filename = строка - имя файла
%
% Выходные параметры:
%   alpha = число - отношение fF/sx (отношение фокусного расстояния к
%       горизонтальному размеру пиксела фотоматрицы камеры)
%   beta = число - отношение fF/sy (отношение фокусного расстояния к
%       вертикальному размеру пиксела фотоматрицы камеры)
%   theta = число - угол, определяющий непрямоугольность пиксела
%       фотоматрицы
%   x0 = число - положение начала координат физического изображения
%       в системе координат цифрового изображения IxOL
%   y0 = число - положение начала координат физического изображения
%       в системе координат цифрового изображения IyOL
%   R = 3x3 матрица - матрица CJR поворота преобразования координат (J)->(C)
%   t = 3x1 вектор - вектор смещения преобразования координат (J)->(C)

%открываем файл для чтения
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_params() : can not open file !'); 
    R = [];
    t = [];
    return;
end;

%Вычитываем t
[t,count] = fscanf(fid,'%f',[1,3]);
if (count ~= 3)
    disp('error in read_params() : can not read t !'); 
    fclose(fid);
    t = [];
    return;
end; 

%Вычитываем R
[R,count] = fscanf(fid, '%f',[3,3]);
if (count ~= 9)
    disp('error in read_params() : can not read R');
    fclose(fid);
    R = [];
    return;
end;

%Вычитываем alpha и beta
[alpha,count] = fscanf(fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read alpha');
    flose(fid);
    return;
end;    
[beta, count] = fscanf(fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read beta');
    fclose(fid);
    return;
end;

%Вычитываем theta
[theta, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read theta');
    fclose(fid);
    return;
end;

%Вычитываем x0 и y0
[x0, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read x0');
    fclose(fid);
    return;
end;
[y0, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read y0');
    fclose(fid);
    return;
end;

    