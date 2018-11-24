function [ret] = write_Ip(filename,Ip);
% [ret] = write_Ip(filename,Ip)
% 
% ������ ��������� ����������� ����� �������������� ������� � ����
% � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%   Ip = 2xM ������� - 2D-���������� ����������� ����� JPi ��������������
%       ������� � ������� ��������� ��������� ����������� (I)
%
% �������� ���������:
%   ret = ����� - ���� �������� (0=������,1=������ �������� ������)

%��������� ����������� ������� Ip
N = size(Ip,1);
M = size(Ip,2);
if( (N~=2) || (M<1) )
    disp('error in write_Ip() : invalid size of Ip !');
    ret = 0;
    return;
end;

%��������� ���� ��� ������
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_Ip() : can not open file !'); 
    ret = 0;
    return;
end    

%������ M
fprintf(fid,'%d\n',M);

%������ Ip
fprintf(fid,'%10E  %10E \n',Ip);

fclose(fid);
ret = 1;
return;