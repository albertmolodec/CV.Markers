function [] = draw3d_text(X,txt);
% draw3d_text(X,text)
%
% ��������� ������ �� ������� �������
%
% X = 3x1 - ���������� ��������� ������
% txt = ������ - �������� �����

text( X(1),X(2),X(3),txt );
return;