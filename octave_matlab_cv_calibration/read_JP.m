function [JP] = read_JP(filename);
% [JP] = read_JP(filename)
% 
% ����������� ��������� ����� �������������� ������� �� ����� 
% � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%
% �������� ���������:
%   JP = 3xM ������� - 3D-���������� ����� �������������� �������
%       � ����������� ������� ��������� ������� (J), ������� �������
%       ������������� �������� JPi

%��������� ���� ��� ������
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_JP() : can not open file !'); 
    JP = [];
    return;
end;    

%���������� M
[M,count] = fscanf(fid,'%d',1); %count - ���������� ����������� �����
if(count~=1)
    disp('error in read_JP() : can not read M !'); 
    fclose(fid);
    JP = [];
    return;
end;   

%�������� �������� M
if(M<1)
    disp('error in read_JP() : invalid M !'); 
end;
    
%���������� JPi
[JP,count] = fscanf(fid,'%f',[3,M]);
if(count~=3*M)
    disp('error in read_JP() : can not read JP !'); 
    fclose(fid);
    JP = [];
    return;
end;    

fclose(fid);
return;