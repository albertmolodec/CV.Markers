function [Ip] = projection(JP,projmatrix);
% [Ip] = projection(JP,projmatrix)
% 
% Вычисление координат изображений точек объекта в соответствии
% с преобразованием (J)->(I) (формула (26))
%
% Входные параметры:
%   JP = 3xM матрица - 3D-координаты точек калибровочного объекта
%       в собственной системе координат объекта (J), столбцы матрицы
%       соответствуют векторам JPi
%   projmatrix = 3x4 матрица - проекционная матрица камеры
%
% Выходные параметры:
%   Ip = 2xM матрица - 2D-координаты изображений точек JPi калибровочного
%       объекта в системе координат цифрового изображения (I)

M = size(JP,2);
Ip = zeros(2,M); %сразу же выделяем место

%Проверка размерности матрицы данных JP
if( (size(JP,1)~=3) || (M<1))
    disp('error in projection() : invalid size of JP!');
    return;
end;

%Проверка размерности проекционной матрицы
if( (size(projmatrix,1)~=3) || (size(projmatrix,2)~=4) )
    disp('error in projection() : invalid size of projmatrix!');
    return;
end;

%В цикле заполняем Ip
for i=1:M
    JPi = [JP(:,i);1]; %делаем 4D-вектор из 3D-вектора
    Czi = dot(projmatrix(3,:),JPi);
    Ip(1,i) = dot(projmatrix(1,:),JPi) / dot(projmatrix(3,:),JPi); %(формула (26))
    Ip(2,i) = dot(projmatrix(2,:),JPi) / dot(projmatrix(3,:),JPi); %
end;

return;