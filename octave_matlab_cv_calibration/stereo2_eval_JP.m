function [JP] = stereo2_eval_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip);
% [JP] = stereo2_eval_JP(cam1_projmatrix,cam1_Ip,cam2_projmatrix,cam2_Ip)
% 
% ������� ������ ������������� - �������������� 3D-��������� ����� �������
% �� ��������� ����������� ����� �� ���� ������������ � ������������ ��������
% �����
%
% ������� ���������:
%
%   cam1_projmatrix = 3x4 ������� - ������������ ������� ������ 1
%
%   cam1_Ip = 2xM ������� - 2D-���������� ����������� ����� JPi
%       ������� � ������� ��������� ��������� ����������� (I) ������ 1
%
%   cam2_projmatrix = 3x4 ������� - ������������ ������� ������ 2
%
%   cam2_Ip = 2xM ������� - 2D-���������� ����������� ����� JPi
%       ������� � ������� ��������� ��������� ����������� (I) ������ 2
%
% �������� ���������:
%
%   JP = 3xM ������� - 3D-���������� ����� ������� � �����������
%       ������� ��������� ������� (J), ������� ������� �������������
%       �������� JPi

%��������� ����������� ������� ������ (� ������ ������ ����������
%������� ������� 3D-���������)
M = size(cam1_Ip,2); %����� �����
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

%��� ������ ����� ������� ������ ������� ��������� (17)
JP = zeros(3,M); %����� �������� �����
for i=1:M
    %������ ������� ��������� (17): 
    % [cam1_px]*cam1_projmatrix*P=0
    % [cam2_px]*cam2_projmatrix*P=0
    % (��� ������� ��������� �������� � ���� A*X=B, ��������� P(4)=1 )
    %1.���������� ������� ��� ���������� ��� ����������� ������� lsqr
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
    
    
    %2.������ ������� ��������� A*X=B
    maxit = 15;
    tol = 1e-6;
    X = lsqr(A,B,tol,maxit);
    
    %3.������� ���������� ��������� � ������� �������� ������
    JP(1:3,i) = X(1:3);
    
end;

return;