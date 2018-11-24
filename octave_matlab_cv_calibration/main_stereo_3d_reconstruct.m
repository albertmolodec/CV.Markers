%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������� ������ ������������� (���� �������������� 3D-���������)
% ������� ������.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%��� ����� ��� �������� ������� � �������� ������
%dirname = 'matlab';
dirname = 'serj';

%����� ������� � �������� ������
fname_obj_calpts      = [dirname '/input/obj_calpts.txt'];

fname_cam1_projmatrix = [dirname '/output/cam1_projmatrix.txt'];
fname_cam1_img_scene  = [dirname '/input/cam1_img_scene.txt'];

fname_cam2_projmatrix = [dirname '/output/cam2_projmatrix.txt'];
fname_cam2_img_scene  = [dirname '/input/cam2_img_scene.txt'];

fname_scene_pts       = [dirname '/output/scene_pts.txt']

%��������� ������ �� ������
[cam1_Ip] = read_Ip(fname_cam1_img_scene);
[cam1_projmatrix] = read_projmatrix(fname_cam1_projmatrix);

[cam2_Ip] = read_Ip(fname_cam2_img_scene);
[cam2_projmatrix] = read_projmatrix(fname_cam2_projmatrix);

%��������� 3D-���������� ����� �������
[JP1] = stereo2_calc_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip); %geometrical intersection
[JP2] = stereo2_eval_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip); %mnk solution

%��������� ��������� 3D-���������� ����� ������� � ���� 
[ret] = write_JP(fname_scene_pts,JP1);
if (ret==0)
    disp('error : write_JP(scene_pts)!');
end;


%��������� �������� 3D-���������� �� ����� (��� ��������)
[JP0] = read_JP(fname_obj_calpts);

%���������� ��������� ����� �� 3D-�����������
figure('Name','3D space');
figure(1);

hold on;
plot3(JP0(1,:),JP0(2,:),JP0(3,:),'.r',  JP1(1,:),JP1(2,:),JP1(3,:),'og',  JP2(1,:),JP2(2,:),JP2(3,:),'vb');
legend('true values','geometrical intersection','mnk solution');
hold off;
axis equal;

%��� �������� ��������� �����������, �������� ��������
figure('Name','geometrical intersection');
figure(2);

[cam1_Ip2] = projection(JP1,cam1_projmatrix);
[cam2_Ip2] = projection(JP1,cam2_projmatrix);

subplot(1,2,1);
plot(cam1_Ip2(1,:),cam1_Ip2(2,:),'og',cam1_Ip(1,:),cam1_Ip(2,:),'+b');
axis equal;
title('camera1');

subplot(1,2,2);
plot(cam2_Ip2(1,:),cam2_Ip2(2,:),'og',cam2_Ip(1,:),cam2_Ip(2,:),'+b');
axis equal;
title('camera2');

figure('Name','mnk solution');
figure(3);

[cam1_Ip2] = projection(JP2,cam1_projmatrix);
[cam2_Ip2] = projection(JP2,cam2_projmatrix);

subplot(1,2,1);
plot(cam1_Ip2(1,:),cam1_Ip2(2,:),'vr',cam1_Ip(1,:),cam1_Ip(2,:),'+b');
axis equal;
title('camera1');

subplot(1,2,2);
plot(cam2_Ip2(1,:),cam2_Ip2(2,:),'vr',cam2_Ip(1,:),cam2_Ip(2,:),'+b');
axis equal;
title('camera2');
