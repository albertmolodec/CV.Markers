function [residual] = calc_residual(I0,I1);
% [residual] = calc_residual(I0,I1)
%
% 
% I0 = S x N ������� (���������� ������)
% I1 = S x N ������� (����������� ������)
%
% residual = ����� - ������������� ������:  residual = sum(|I1-I0|)/(sum(|I0|)+1)

S = size(I0,1);
N = size(I0,2);

A = 0;
B = 0;
for i = 1:N
    A = A + norm( I1(:,i)-I0(:,i) ,2);
    B = B + norm( I0(:,i)         ,2);
end;

residual = A/(B+1); %����� 1 ����������� �� ��������� ������� �� ����

return;