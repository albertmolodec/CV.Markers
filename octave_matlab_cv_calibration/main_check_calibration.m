%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ФОТОГРАММЕТРИЧЕСКАЯ КАЛИБРОВКА КАМЕРЫ (БЕЗ УЧЁТА РАДИАЛЬНЫХ ИСКАЖЕНИЙ)
% Проверка правильности решения задачи калибровки.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%Имя папки для хранения входных и выходных данных
%dirname = 'matlab';
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

[Ip1] = read_Ip(fname_cam1_img_calpts);
[projmatrix1] = read_projmatrix(fname_cam1_projmatrix);
[alpha1,beta1,theta1,x01,y01,R1,t1] = read_params(fname_cam1_params);

[Ip2] = read_Ip(fname_cam2_img_calpts);
[projmatrix2] = read_projmatrix(fname_cam2_projmatrix);
[alpha2,beta2,theta2,x02,y02,R2,t2] = read_params(fname_cam2_params);

%В 3D-пространстве отображаем точки объекта, положение и направление камер
figure(1);

%положение калибровочного объекта
hold on;
plot3(JP(1,:),JP(2,:),JP(3,:),'.r'); 

%оси координат системы объекта(J)
%(совпадают с осями лабораторной системы(W))
scale = 200;
JO = scale*[0 0 0]';
JX = scale*[1 0 0]';
JY = scale*[0 1 0]';
JZ = scale*[0 0 1]';
draw3d_line( JO, JX, 'b');
draw3d_line( JO, JY, 'b');
draw3d_line( JO, JZ, 'b');
draw3d_text( JO, 'O');
draw3d_text( JX, 'X');
draw3d_text( JY, 'Y');
draw3d_text( JZ, 'Z');

%камеру представляем осями системы координат камеры (C)
scale = 200;
CO = scale*[0 0 0]';
CX = scale*[1 0 0]';
CY = scale*[0 1 0]';
CZ = scale*[0 0 1]';
mCZ = -7*CZ;
%переход в систему координат J:  Ja = JCR*Ca + JOC
JCO = (R1')*CO - (R1')*(t1');
JCX = (R1')*CX - (R1')*(t1');
JCY = (R1')*CY - (R1')*(t1');
JCZ = (R1')*CZ - (R1')*(t1');
disp(JCO);
JmCZ = (R1')*mCZ - (R1')*(t1');
draw3d_line( JCO, JCX, 'r');
draw3d_line( JCO, JCY, 'r');
draw3d_line( JCO, JCZ, 'r');
draw3d_line( JCO, JmCZ, '--g');
draw3d_text( JCO, 'OC1');
draw3d_text( JCX, 'XC1');
draw3d_text( JCY, 'YC1');
draw3d_text( JCZ, 'ZC1');
axis equal;

%камеру представляем осями системы координат камеры (C)
scale = 200;
CO = scale*[0 0 0]';
CX = scale*[1 0 0]';
CY = scale*[0 1 0]';
CZ = scale*[0 0 1]';
mCZ = -7*CZ;
%переход в систему координат J:  Ja = JCR*Ca + JOC
JCO = (R2')*CO - (R2')*(t2');
JCX = (R2')*CX - (R2')*(t2');
JCY = (R2')*CY - (R2')*(t2');
JCZ = (R2')*CZ - (R2')*(t2');
disp(JCO);
JmCZ = (R2')*mCZ - (R2')*(t2');
draw3d_line( JCO, JCX, 'r');
draw3d_line( JCO, JCY, 'r');
draw3d_line( JCO, JCZ, 'r');
draw3d_line( JCO, JmCZ, '--g');
draw3d_text( JCO, 'OC2');
draw3d_text( JCX, 'XC2');
draw3d_text( JCY, 'YC2');
draw3d_text( JCZ, 'ZC2');
axis equal;

