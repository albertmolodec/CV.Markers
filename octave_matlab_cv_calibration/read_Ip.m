function [Ip] = read_Ip(filename);
% [Ip] = read_Ip(filename)
% 
% ����������� ��������� ����������� ����� �������������� ������� �� ����� 
% � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%
% �������� ���������:
%   Ip = 2xM ������� - 2D-���������� ����������� ����� JPi ��������������
%       ������� � ������� ��������� ��������� ����������� (I)


%��������� ���� ��� ������
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_Ip() : can not open file !'); 
    Ip = [];
    return;
end;    

%���������� M
[M,count] = fscanf(fid,'%d',1); %count - ���������� ����������� �����
if(count~=1)
    disp('error in read_Ip() : can not read M !'); 
    fclose(fid);
    Ip = [];
    return;
end;   

%�������� �������� M
if(M<1)
    disp('error in read_Ip() : invalid M !'); 
end;
    
%���������� Ipi
[Ip,count] = fscanf(fid,'%f',[2,M]);
if(count~=2*M)
    disp('error in read_Ip() : can not read Ip !'); 
    fclose(fid);
    Ip = [];
    return;
end;    

fclose(fid);
return;