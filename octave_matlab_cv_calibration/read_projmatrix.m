function [projmatrix] = read_projmatrix(filename);
% [projmatrix] = read_projmatrix(filename)
% 
% ������ ������������ ������� ������ �� ����� � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%
% �������� ���������:
%   projmatrix = 3x4 ������� - ������������ ������� ������


%��������� ���� ��� ������
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_projmatrix() : can not open file !'); 
    projmatrix = [];
    return;
end;    
    
%���������� JPi
[projmatrix,count] = fscanf(fid,'%f',[4,3]);
projmatrix = projmatrix';
if(count~=12)
    disp('error in read_projmatrix() : can not read projmatrix !'); 
    fclose(fid);
    projmatrix = [];
    return;
end;    

fclose(fid);
return;