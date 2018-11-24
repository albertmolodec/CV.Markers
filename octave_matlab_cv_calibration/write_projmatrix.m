function [ret] = write_projmatrix(filename,projmatrix);
% [ret] = write_projmatrix(filename,projmatrix)
% 
% ������ ������������ ������� ������ � ���� � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%   projmatrix = 3x4 ������� - ������������ ������� ������
%
% �������� ���������:
%   ret = ����� - ���� �������� (0=������,1=������ �������� ������)

%��������� ���� ��� ������
fid = fopen(filename,'w');
if(fid==-1)
    disp('error in write_projmatrix() : can not open file !'); 
    ret = 0;
    return;
end    

%������ projmatrix
fprintf(fid,'%14E  %14E  %14E  %14E\n',projmatrix');

fclose(fid);
ret = 1;
return;