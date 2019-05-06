%Autor: Denilson Gomes Vaz da Silva
%Graduando em Engenharia da Computa��o
%Estudo sobre Evas�o do Curso de Engenharia de Computa��o

clear %limpa as variaveis
clc %limpa o visor 
close all

% Lendo os dados:
[fname path]=uigetfile('*.csv'); 
fname=strcat(path,fname);
% Preenchendo a tabela total tbl:
tbl = readtable(fname);

% Variavel dependente Y: �ltima coluna da tabela
% Dados X: Todas as colunas (exceto �ltima)
X = tbl(:,1:end-1);
Y = tbl(:,end);
% Transforma o tipo tbl para arrays:
X = table2array(X);
Y = table2array(Y);

%Dimens�es do dataset
numClasses = max(Y);
[numAmostras,numCaracteristicas] = size(X);
