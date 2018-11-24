function [projmatrix] = form_projmatrix(m);
% [projmatrix] = form_projmatrix(m)
%
% формируем проекционную матрицу из найденного вектора m
%
%

a = 1;
for i=1:3
for j=1:4
    projmatrix(i,j) = m(a);
    a = a + 1;
end;
end;

return;