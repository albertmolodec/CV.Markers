function [projmatrix] = eval_projmatrix(JP,Ip);
% [projmatrix] = eval_projmatrix(JP,Ip)
% 
% Нахождение компонент проекционной матрицы методом наименьших квадратов
%
% Входные параметры:
%   JP = 3xM матрица - 3D-координаты точек калибровочного объекта
%       в собственной системе координат объекта (J), столбцы матрицы
%       соответствуют векторам JPi
%   Ip = 2xM матрица - 2D-координаты изображений точек JPi калибровочного
%       объекта в системе координат цифрового изображения (I)
%
% Выходные параметры:
%   projmatrix = 3x4 матрица - проекционная матрица камеры

%Проверяем размерности входных данных (в случае ошибки возвращаем
%нулевую проекционную матрицу)
M = size(JP,2);
if( M~=size(Ip,2) )
    projmatrix = zeros(3,4);
    disp('error in eval_projmatrix() : number of JP points differs from number of Ip!');
    return;
end;

if( M<6 )
    projmatrix = zeros(3,4);
    disp('error in eval_projmatrix() : number of points < 6!');
    return;
end;
    
if( (size(JP,1)~=3) || (size(Ip,1)~=2) )
    projmatrix = zeros(3,4);
    disp('error in eval_projmatrix() : invalid size of input parameters!');
    return;
end;    

%Из исходных данных формируем матрицу Q (формула (28))
Q = zeros(2*M,12); %сразу выделили место - для оптимизации скорости работы
q1 = zeros(2,12); %пара строк в Q, соответствующих одной точке объекта
for i=1:M
    q1(1,:) = [JP(1,i) JP(2,i) JP(3,i) 1 0 0 0 0 -Ip(1,i)*JP(1,i) -Ip(1,i)*JP(2,i) -Ip(1,i)*JP(3,i) -Ip(1,i)];
    q1(2,:) = [0 0 0 0 JP(1,i) JP(2,i) JP(3,i) 1 -Ip(2,i)*JP(1,i) -Ip(2,i)*JP(2,i) -Ip(2,i)*JP(3,i) -Ip(2,i)];
    Q(2*(i-1)+1 : 2*(i-1)+2, :) = q1;
end;

%Решаем систему уравнений Q*m=0 (уравнение (28)) 
%линейным методом наименьших квадратов:

%1.Выполнили сингулярное разложение
[U,W,V] = svd(Q);

%2.Столбцы матрицы V представляют собой возможные решение
%(но нас интересует только соответствующее минимальному
%и не равному 0 сингулярному значению, выбор которого при 
%наличии шума осуществить достаточно трудно - для этого
%будем искать решение, которое даст наилучшее приближение
%исходных данных Ip)

NS = size(V,2); %количество решений

%перебираем все возможные и ищем то, которое даст минимальную 
%ошибку
best_i = 1;
best_m = V(:,best_i);
best_projmatrix = form_projmatrix(best_m);
best_Ip = projection(JP,best_projmatrix);
best_err = calc_residual(Ip,best_Ip);

if NS>1
    for i=1:NS
    if W(i,i)>0
        i_m = V(:,i);
        i_projmatrix = form_projmatrix(i_m);
        i_Ip = projection(JP,i_projmatrix);
        i_err = calc_residual(Ip,i_Ip);
        if i_err < best_err
            best_i = i;
            best_projmatrix = i_projmatrix;
            best_err = i_err;
        end;   
    end;    
    end;
end;

disp('best i');
best_i
best_err
best_projmatrix

projmatrix = best_projmatrix;
   
return;