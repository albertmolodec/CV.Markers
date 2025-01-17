function [X,dist] = stereo2_find_intersection(X1,u1,X2,u2);
% [X,dist] = stereo2_find_intersection(X1,u1,X2,u2)
% 
% ���������� ��������� �����, �������� ��������������� 
% "����� �����������" ���� �����
%
% ������� ���������:
%
%   X1 = 1x3 ������ - ���������� ������ ������� ����
%   u1 = 1x3 ������ - ������������ ������ ������� ���� (������������� ���������)
%
%   X2 = 1x3 ������ - ���������� ������ ������� ����
%   u2 = 1x3 ������ - ������������ ������ ������� ���� (������������� ���������)
%
% �������� ���������:
%
%   X = 1x3 ������ - ���������� "����� �����������" �����
%
%   dist = ����� - ���������� ����� ������ � "����� �����������"

%��������� ����������� ������� ������ (� ������ ������ ����������
%������� ������)
if( (size(X1,1)~=3) || (size(X1,2)~=1) || (size(u1,1)~=3) || (size(u1,2)~=1) || ...
    (size(X2,1)~=3) || (size(X2,2)~=1) || (size(u2,1)~=3) || (size(u2,2)~=1)    )
    X = zeros(3,1);
    dist = 0;
    disp('stereo2_find_intersection() : invalid size of input arguments!');
    return;
end;

%��������� ������� �������
w1 = u1/norm(u1,2);
w2 = u2/norm(u2,2);

%��������� ������������� ��������
X2_X1 = X2 - X1;
w1_w2 = dot(w1,w2);

%�������� �� ��������������
if abs(abs(w1_w2)-1) < 1e-5
    disp('stereo2_find_intersection() : it seems reys are parallel !');
    X = (X1+X2)/2;
    dist = norm(X1-X2,2);
    return;
end;    

%��������� a1,a2
a1 = ( dot(X2_X1,w1) - dot(X2_X1,w2)*w1_w2 ) / (1 - w1_w2*w1_w2);
a2 = ( dot(X2_X1,w1)*w1_w2 - dot(X2_X1,w2) ) / (1 - w1_w2*w1_w2);

%��������� ���������� "����� �����������"
P1 = X1 + a1*w1;
P2 = X2 + a2*w2;
X = 0.5*(P1+P2);
dist = norm(P1-P2,2);

return;