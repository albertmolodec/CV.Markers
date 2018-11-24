function [JP] = stereo2_calc_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip);
% [JP] = stereo2_calc_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip)
% 
% Решение задачи стереовидения - восстановление 3D-координат точек объекта
% по известным координатам точек на двух изображениях и проекционным матрицам
% камер (используется алгоритм выбора наилучшей геометрической точки
% пересечения двух лучей)
%
% Входные параметры:
%
%   cam1_projmatrix = 3x4 матрица - проекционная матрица камеры 1
%
%   cam1_Ip = 2xM матрица - 2D-координаты изображений точек JPi
%       объекта в системе координат цифрового изображения (I) камеры 1
%
%   cam2_projmatrix = 3x4 матрица - проекционная матрица камеры 2
%
%   cam2_Ip = 2xM матрица - 2D-координаты изображений точек JPi
%       объекта в системе координат цифрового изображения (I) камеры 2
%
% Выходные параметры:
%
%   JP = 3xM матрица - 3D-координаты точек объекта в собственной
%       системе координат объекта (J), столбцы матрицы соответствуют
%       векторам JPi

%Проверяем размерности входных данных (в случае ошибки возвращаем
%нулевую матрицу 3D-координат)
M = size(cam1_Ip,2); %число точек
if( M<1 )
    JP = zeros(3,1);
    disp('error in stereo2_eval_JP() : number of points < 1!');
    return;
end;

if( (size(cam1_Ip,1)~=2) || (size(cam2_Ip,1)~=2) )
    JP = zeros(3,M);
    disp('error in stereo2_eval_JP() : vertical size of cam_Ip vectors is not 2!');
    return;
end;

if( M~=size(cam2_Ip,2) )
    JP = zeros(3,M);
    disp('error in stereo2_eval_JP() : number of cam1_Ip points differs from number of cam2_Ip!');
    return;
end;

if( (size(cam1_projmatrix,1)~=3) || (size(cam1_projmatrix,2)~=4) || ...
    (size(cam2_projmatrix,1)~=3) || (size(cam2_projmatrix,2)~=4)    )
    JP = zeros(3,M);
    disp('error in stereo2_eval_JP() : invalid size of projmatrixes!');
    return;
end

%0.Вычисляем внутренние и внешние параметры камер (пригодятся для
%  решения задачи восстановления)
[cam1_alpha,cam1_beta,cam1_theta,cam1_x0,cam1_y0,cam1_R,cam1_t] = calc_params(cam1_projmatrix);
[cam2_alpha,cam2_beta,cam2_theta,cam2_x0,cam2_y0,cam2_R,cam2_t] = calc_params(cam2_projmatrix);

%1.Вычисляем координаты оптических центров камер (все лучи к точкам объекта
%  будут исходить из оптических центров) в системе координат объекта (J)
cam1_COC = [0;0;0];
cam1_JCR = cam1_R';
cam1_JOC = cam1_JCR*cam1_COC - cam1_JCR*cam1_t; %вычислили положение начала координат камеры 1 (C1) в системе координат объекта (J)

cam2_COC = [0;0;0];
cam2_JCR = cam2_R';
cam2_JOC = cam2_JCR*cam2_COC - cam2_JCR*cam2_t; %вычислили положение начала координат камеры 2 (C2) в системе координат объекта (J)

X1 = cam1_JOC;
X2 = cam2_JOC;


%Для каждой точки объекта решаем систему уравнений
JP = zeros(3,M); %сразу выделили место
for i=1:M

    %2.Для каждой пары соответствующих точек вычисляем направляющие вектора
    %  (в системе координат объекта (J)) к соответствующей точке объекта

    CY = (1/cam1_beta)*sin(cam1_theta)*(cam1_Ip(2,i)+cam1_y0);
    CX = (1/cam1_beta)*cos(cam1_theta)*(cam1_Ip(2,i)+cam1_y0) - (1/cam1_alpha)*(cam1_Ip(1,i)+cam1_x0);
    CZ = -1;
    V = [CX;CY;CZ];
    u1 = cam1_JCR*V; % - cam1_JCR*cam1_t;
    
    CY = (1/cam2_beta)*sin(cam2_theta)*(cam2_Ip(2,i)+cam2_y0);
    CX = (1/cam2_beta)*cos(cam2_theta)*(cam2_Ip(2,i)+cam2_y0) - (1/cam2_alpha)*(cam2_Ip(1,i)+cam2_x0);
    CZ = -1;
    V = [CX;CY;CZ];
    u2 = cam2_JCR*V; % - cam2_JCR*cam2_t;

    %3.Для каждой пары соответствующих точек по найденным направляющим
    %  векторам определяем координаты "точки пересечения" двух лучей
    [JX,dist] = stereo2_find_intersection(X1,u1,X2,u2);
    
    %4.Проверяем dist, и если dist больше некоторого порога - точку
    %  игнорируем (это значит, что соответствующие точки были выбраны неверно)
    
    %поскольку соответствующие точки выбирались вручную - проверку на dist
    %не выполняем (считаем, что соответствующие точки выбраны правильно)
    
    %5.Заносим полученный результат в матрицу выходных данных
    JP(1:3,i) = JX(1:3);
end;

return;