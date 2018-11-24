function [alpha,beta,theta,x0,y0,R,t] = read_params(filename);
% [alpha,beta,theta,x0,y0,R,t] = read_params(filename)
% 
% ������ ���������� � ������� ���������� ������ �� ����� � �������� ������
%
% ������� ���������:
%   filename = ������ - ��� �����
%
% �������� ���������:
%   alpha = ����� - ��������� fF/sx (��������� ��������� ���������� �
%       ��������������� ������� ������� ����������� ������)
%   beta = ����� - ��������� fF/sy (��������� ��������� ���������� �
%       ������������� ������� ������� ����������� ������)
%   theta = ����� - ����, ������������ ����������������� �������
%       �����������
%   x0 = ����� - ��������� ������ ��������� ����������� �����������
%       � ������� ��������� ��������� ����������� IxOL
%   y0 = ����� - ��������� ������ ��������� ����������� �����������
%       � ������� ��������� ��������� ����������� IyOL
%   R = 3x3 ������� - ������� CJR �������� �������������� ��������� (J)->(C)
%   t = 3x1 ������ - ������ �������� �������������� ��������� (J)->(C)

%��������� ���� ��� ������
fid = fopen(filename,'r');
if(fid==-1)
    disp('error in read_params() : can not open file !'); 
    R = [];
    t = [];
    return;
end;

%���������� t
[t,count] = fscanf(fid,'%f',[1,3]);
if (count ~= 3)
    disp('error in read_params() : can not read t !'); 
    fclose(fid);
    t = [];
    return;
end; 

%���������� R
[R,count] = fscanf(fid, '%f',[3,3]);
if (count ~= 9)
    disp('error in read_params() : can not read R');
    fclose(fid);
    R = [];
    return;
end;

%���������� alpha � beta
[alpha,count] = fscanf(fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read alpha');
    flose(fid);
    return;
end;    
[beta, count] = fscanf(fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read beta');
    fclose(fid);
    return;
end;

%���������� theta
[theta, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read theta');
    fclose(fid);
    return;
end;

%���������� x0 � y0
[x0, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read x0');
    fclose(fid);
    return;
end;
[y0, count] = fscanf (fid,'%f',1);
if(count ~= 1)
    disp('error in read_params(): can not read y0');
    fclose(fid);
    return;
end;

    