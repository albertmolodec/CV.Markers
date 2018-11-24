%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ФОТОГРАММЕТРИЧЕСКАЯ КАЛИБРОВКА КАМЕРЫ (БЕЗ УЧЁТА РАДИАЛЬНЫХ ИСКАЖЕНИЙ)
% Главный скрипт.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; %закрываем все окна графиков
clear all; %удаляем из памяти все переменные

%Имя папки для хранения входных и выходных данных
dirname = 'serj';

%Имена входных и выходных файлов
fname_obj_calpts      = [dirname '/input/obj_calpts.txt'];

fname_cam1_img_calpts = [dirname '/input/cam1_img_calpts.txt'];
fname_cam1_projmatrix = [dirname '/output/cam1_projmatrix.txt'];
fname_cam1_params     = [dirname '/output/cam1_params.txt'];

fname_cam2_img_calpts = [dirname '/input/cam2_img_calpts.txt'];
fname_cam2_projmatrix = [dirname '/output/cam2_projmatrix.txt'];
fname_cam2_params     = [dirname '/output/cam2_params.txt'];

%Загружаем данные из файлов
[JP] = read_JP(fname_obj_calpts);
[cam1_Ip] = read_Ip(fname_cam1_img_calpts);
[cam2_Ip] = read_Ip(fname_cam2_img_calpts);

%Определяем компоненты проекционных матриц камер
[cam1_projmatrix] = eval_projmatrix(JP,cam1_Ip);
[cam2_projmatrix] = eval_projmatrix(JP,cam2_Ip);

%Вычисляем внутренние и внешние параметры камер
[cam1_alpha,cam1_beta,cam1_theta,cam1_x0,cam1_y0,cam1_R,cam1_t] = calc_params(cam1_projmatrix);
[cam2_alpha,cam2_beta,cam2_theta,cam2_x0,cam2_y0,cam2_R,cam2_t] = calc_params(cam2_projmatrix);
disp((14/cam1_alpha)*1000);
disp((14/cam1_beta)*1000);
%Сохраняем полученные результаты в файлы
[ret] = write_projmatrix(fname_cam1_projmatrix,cam1_projmatrix);
if (ret==0)
    disp('error : write_projmatrix(cam1)!');
end;
[ret] = write_projmatrix(fname_cam2_projmatrix,cam2_projmatrix);
if (ret==0)
    disp('error : write_projmatrix(cam2)!');
end;

[ret] = write_params(fname_cam1_params,cam1_alpha,cam1_beta,cam1_theta,cam1_x0,cam1_y0,cam1_R,cam1_t);
if (ret==0)
    disp('error : write_params(cam1)!');
end;
[ret] = write_params(fname_cam2_params,cam2_alpha,cam2_beta,cam2_theta,cam2_x0,cam2_y0,cam2_R,cam2_t);
if (ret==0)
    disp('error : write_params(cam2)!');
end;

%Отображаем найденные параметры камеры
disp('camera1 parameters:');
cam1_alpha
cam1_beta
cam1_theta_grad=cam1_theta*180/pi;
cam1_theta_grad
cam1_x0
cam1_y0
cam1_R
cam1_t

disp('camera2 parameters:');
cam2_alpha
cam2_beta
cam2_theta_grad=cam1_theta*180/pi;
cam2_theta_grad
cam2_x0
cam2_y0
cam2_R
cam2_t

%Для контроля за правильностью определения параметров камеры 
%вычисляем координаты точек объекта на изображении
%используя найденные параметры и проекционную матрицу
[cam1_Ip2] = projection(JP,cam1_projmatrix);

[cam1_calmatrix3] = calc_calmatrix(cam1_alpha,cam1_beta,cam1_theta,cam1_x0,cam1_y0);
[cam1_projmatrix3] = calc_projmatrix(cam1_calmatrix3,cam1_R,cam1_t);
[cam1_Ip3] = projection(JP,cam1_projmatrix3);

figure(1);
subplot(1,2,1);
plot(cam1_Ip(1,:),-cam1_Ip(2,:),'+r',cam1_Ip2(1,:),-cam1_Ip2(2,:),'vb',cam1_Ip3(1,:),-cam1_Ip3(2,:),'^k');
title('camera1');
legend('experimental','calc with found projmatrix','calc with found parameters');


[cam2_Ip2] = projection(JP,cam2_projmatrix);

[cam2_calmatrix3] = calc_calmatrix(cam2_alpha,cam2_beta,cam2_theta,cam2_x0,cam2_y0);
[cam2_projmatrix3] = calc_projmatrix(cam2_calmatrix3,cam2_R,cam2_t);
[cam2_Ip3] = projection(JP,cam2_projmatrix3);

figure(1);
subplot(1,2,2);
plot(cam2_Ip(1,:),-cam2_Ip(2,:),'+r',cam2_Ip2(1,:),-cam2_Ip2(2,:),'vb',cam2_Ip3(1,:),-cam2_Ip3(2,:),'^k');
title('camera2');
legend('experimental','calc with found projmatrix','calc with found parameters');

return;