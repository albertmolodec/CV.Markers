%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Генерация изображений для СТЕРЕО-задачи
% на основе заданных 3D-координат объекта
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Имя папки для хранения входных и выходных данных
dirname = 'matlab';

%Имена входных и выходных файлов
fname_obj_calpts      = [dirname '/input/obj_calpts.txt'];

fname_cam1_projmatrix = [dirname '/output/cam1_projmatrix.txt'];
fname_cam1_params     = [dirname '/output/cam1_params.txt'];
fname_cam1_img_scene  = [dirname '/input/cam1_img_scene.txt'];

fname_cam2_projmatrix = [dirname '/output/cam2_projmatrix.txt'];
fname_cam2_params     = [dirname '/output/cam2_params.txt'];
fname_cam2_img_scene  = [dirname '/input/cam2_img_scene.txt'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%калибровочный объект (он же - наблюдаемый)
JP = [100 150 300 100 100 200 160 120 100 100 200;...
      150 160 170 180 190 200 210 220 230 240 250;...
      100 100 200 100 300 100 200 100 200 100 100];

%параметры камеры1
cam1_alpha = 4000/0.001;
cam1_beta  = 4000/0.001;
cam1_theta = pi/2;
cam1_x0 = 1500;
cam1_y0 = 1000;
cam1_R=[1 0 0;...
        0 1 0;...
        0 0 1];
cam1_t=[-200;...
         100;...
        -4000];

%параметры камеры2
cam2_alpha = 4000/0.001;
cam2_beta  = 4000/0.001;
cam2_theta = pi/2;
cam2_x0 = 1500;
cam2_y0 = 1000;
cam2_R=[1 0 0;...
        0 1 0;...
        0 0 1];
cam2_t=[ 200;...
         100;...
        -4000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%вычисляем проекционные матрицы камер
[cam1_calmatrix] = calc_calmatrix(cam1_alpha,cam1_beta,cam1_theta,cam1_x0,cam1_y0);
[cam1_projmatrix] = calc_projmatrix(cam1_calmatrix,cam1_R,cam1_t);

[cam2_calmatrix] = calc_calmatrix(cam2_alpha,cam2_beta,cam2_theta,cam2_x0,cam2_y0);
[cam2_projmatrix] = calc_projmatrix(cam2_calmatrix,cam2_R,cam2_t);

%вычисляем координаты точек объекта на изображениях, даваемых камерами
[cam1_Ip] = projection(JP,cam1_projmatrix);
[cam2_Ip] = projection(JP,cam2_projmatrix);

%Добавляем шумы измерений
NOISE_AMP = 0;
raws = size(cam1_Ip,1);
cols = size(cam1_Ip,2);
for i=1:raws
for j=1:cols
    cam1_Ip(i,j) = cam1_Ip(i,j) + NOISE_AMP*(rand(1,1)-0.5);
    cam2_Ip(i,j) = cam2_Ip(i,j) + NOISE_AMP*(rand(1,1)-0.5);
end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Вычисляем проекционные матрицы камер (калибруем камеры)
[cam1_projmatrix2] = eval_projmatrix(JP,cam1_Ip);
[cam2_projmatrix2] = eval_projmatrix(JP,cam2_Ip);

%Вычисляем параметры камер (калибруем камеры)
[cam1_alpha2,cam1_beta2,cam1_theta2,cam1_x02,cam1_y02,cam1_R2,cam1_t2] = calc_params(cam1_projmatrix2);
[cam2_alpha2,cam2_beta2,cam2_theta2,cam2_x02,cam2_y02,cam2_R2,cam2_t2] = calc_params(cam2_projmatrix2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%сохраняем найденные проекционные матрицы камер в файлы
[ret] = write_projmatrix(fname_cam1_projmatrix,cam1_projmatrix2);
if (ret==0)
    disp('error : write_projmatrix(cam1)!');
end;
[ret] = write_projmatrix(fname_cam2_projmatrix,cam2_projmatrix2);
if (ret==0)
    disp('error : write_projmatrix(cam2)!');
end;

%сохраняем найденные параметры камер в файлы
[ret] = write_params(fname_cam1_params,cam1_alpha2,cam1_beta2,cam1_theta2,cam1_x02,cam1_y02,cam1_R2,cam1_t2);
if (ret==0)
    disp('error : write_params(cam1)!');
end;
[ret] = write_params(fname_cam2_params,cam2_alpha2,cam2_beta2,cam2_theta2,cam2_x02,cam2_y02,cam2_R2,cam2_t2);
if (ret==0)
    disp('error : write_params(cam2)!');
end;

%сохраняем координаты точек объекта на изображениях в файлы
[ret] = write_Ip(fname_cam1_img_scene,cam1_Ip);
if (ret==0)
    disp('error : write_Ip(cam1)!');
end;
[ret] = write_Ip(fname_cam2_img_scene,cam2_Ip);
if (ret==0)
    disp('error : write_Ip(cam2)!');
end;

%сохраняем 3D-координаты точек объекта в файл
[ret] = write_JP(fname_obj_calpts,JP);
if (ret==0)
    disp('error : write_JP()!');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
