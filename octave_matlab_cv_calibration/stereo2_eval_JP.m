function [JP] = stereo2_eval_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip);
% [JP] = stereo2_eval_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip)
% 
% Решение задачи стереовидения - восстановление 3D-координат точек объекта
% по известным координатам точек на двух изображениях и проекционным матрицам
% камер
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

%Для каждой точки объекта решаем систему уравнений (17)
JP = zeros(3,M); %сразу выделили место
for i=1:M
    %Решаем систему уравнений (17): 
    % [cam1_px]*cam1_projmatrix*P=0
    % [cam2_px]*cam2_projmatrix*P=0
    % (Эта система уравнений сводится к виду A*X=B, поскольку P(4)=1 )
    %1.Составляем матрицы для применения МНК посредством функции lsqr
    A = zeros(6,3);
    B = zeros(6,1);

    cam1_px = [    0           -1          cam1_Ip(2,i);...
                   1            0         -cam1_Ip(1,i);...
               -cam1_Ip(2,i) cam1_Ip(1,i)     0       ];

    cam2_px = [    0           -1          cam2_Ip(2,i);...
                   1            0         -cam2_Ip(1,i);...
               -cam2_Ip(2,i) cam2_Ip(1,i)     0       ];

    cam1_D = cam1_px * cam1_projmatrix;
    cam2_D = cam2_px * cam2_projmatrix;

    A(1:3,1:3) =  cam1_D(1:3,1:3);
    A(4:6,1:3) =  cam2_D(1:3,1:3);
    B(1:3,1  ) = -cam1_D(1:3,4  );
    B(4:6,1  ) = -cam2_D(1:3,4  );
    
    
    %2.Решаем систему уравнений A*X=B
    maxit = 15;
    tol = 1e-6;
    X = lsqr(A,B,tol,maxit);
    
    %3.Заносим полученный результат в матрицу выходных данных
    JP(1:3,i) = X(1:3);
    
end;

return;