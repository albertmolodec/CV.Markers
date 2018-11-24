function [Ip] = projection(JP,projmatrix);
% [Ip] = projection(JP,projmatrix)
% 
% ���������� ��������� ����������� ����� ������� � ������������
% � ��������������� (J)->(I) (������� (26))
%
% ������� ���������:
%   JP = 3xM ������� - 3D-���������� ����� �������������� �������
%       � ����������� ������� ��������� ������� (J), ������� �������
%       ������������� �������� JPi
%   projmatrix = 3x4 ������� - ������������ ������� ������
%
% �������� ���������:
%   Ip = 2xM ������� - 2D-���������� ����������� ����� JPi ��������������
%       ������� � ������� ��������� ��������� ����������� (I)

M = size(JP,2);
Ip = zeros(2,M); %����� �� �������� �����

%�������� ����������� ������� ������ JP
if( (size(JP,1)~=3) || (M<1))
    disp('error in projection() : invalid size of JP!');
    return;
end;

%�������� ����������� ������������ �������
if( (size(projmatrix,1)~=3) || (size(projmatrix,2)~=4) )
    disp('error in projection() : invalid size of projmatrix!');
    return;
end;

%� ����� ��������� Ip
for i=1:M
    JPi = [JP(:,i);1]; %������ 4D-������ �� 3D-�������
    Czi = dot(projmatrix(3,:),JPi);
    Ip(1,i) = dot(projmatrix(1,:),JPi) / dot(projmatrix(3,:),JPi); %(������� (26))
    Ip(2,i) = dot(projmatrix(2,:),JPi) / dot(projmatrix(3,:),JPi); %
end;

return;