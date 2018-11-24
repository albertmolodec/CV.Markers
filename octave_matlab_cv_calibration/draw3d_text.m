function [] = draw3d_text(X,txt);
% draw3d_text(X,text)
%
% Рисование текста на текущем графике
%
% X = 3x1 - координаты положения текста
% txt = строка - рисуемый текст

text( X(1),X(2),X(3),txt );
return;