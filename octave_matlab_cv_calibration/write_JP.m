function [ret] = write_JP(filename,JP);
% [ret] = write_JP(filename,JP)
% 
% ������ ��������� ����� �������������� ������� � ���� � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%   JP = 3xM ������� - 3D-���������� ����� �������������� �������
%       � ����������� ������� ��������� ������� (J), ������� �������
%       ������������� �������� JPi
%
% �������� ���������:
%   ret = ����� - ���� �������� (0=������,1=������ �������� ������)

%��������� ����������� ������� JP
N = size(JP,1);
M = size(JP,2);
if( (N~=3) || (M<1) )
    disp('error in write_JP() : invalid size of JP !');
    ret = 0;
    return;
end;

%��������� ���� ��� ������
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_JP() : can not open file !'); 
    ret = 0;
    return;
end    

%������ M
fprintf(fid,'%d\n',M);

%������ JP
fprintf(fid,'%10E  %10E  %10E\n',JP);

fclose(fid);
ret = 1;
return;