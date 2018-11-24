function [projmatrix] = eval_projmatrix(JP,Ip);
% [projmatrix] = eval_projmatrix(JP,Ip)
% 
% ���������� ��������� ������������ ������� ������� ���������� ���������
%
% ������� ���������:
%   JP = 3xM ������� - 3D-���������� ����� �������������� �������
%       � ����������� ������� ��������� ������� (J), ������� �������
%       ������������� �������� JPi
%   Ip = 2xM ������� - 2D-���������� ����������� ����� JPi ��������������
%       ������� � ������� ��������� ��������� ����������� (I)
%
% �������� ���������:
%   projmatrix = 3x4 ������� - ������������ ������� ������

%��������� ����������� ������� ������ (� ������ ������ ����������
%������� ������������ �������)
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

%�� �������� ������ ��������� ������� Q (������� (28))
Q = zeros(2*M,12); %����� �������� ����� - ��� ����������� �������� ������
q1 = zeros(2,12); %���� ����� � Q, ��������������� ����� ����� �������
for i=1:M
    q1(1,:) = [JP(1,i) JP(2,i) JP(3,i) 1 0 0 0 0 -Ip(1,i)*JP(1,i) -Ip(1,i)*JP(2,i) -Ip(1,i)*JP(3,i) -Ip(1,i)];
    q1(2,:) = [0 0 0 0 JP(1,i) JP(2,i) JP(3,i) 1 -Ip(2,i)*JP(1,i) -Ip(2,i)*JP(2,i) -Ip(2,i)*JP(3,i) -Ip(2,i)];
    Q(2*(i-1)+1 : 2*(i-1)+2, :) = q1;
end;

%������ ������� ��������� Q*m=0 (��������� (28)) 
%�������� ������� ���������� ���������:

%1.��������� ����������� ����������
[U,W,V] = svd(Q);

%2.������� ������� V ������������ ����� ��������� �������
%(�� ��� ���������� ������ ��������������� ������������
%� �� ������� 0 ������������ ��������, ����� �������� ��� 
%������� ���� ����������� ���������� ������ - ��� �����
%����� ������ �������, ������� ���� ��������� �����������
%�������� ������ Ip)

NS = size(V,2); %���������� �������

%���������� ��� ��������� � ���� ��, ������� ���� ����������� 
%������
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