%Autor: Denilson Gomes Vaz da Silva
%Graduando em Engenharia da Computação
%Estudo sobre Evasão do Curso de Engenharia de Computação

clear %limpa as variaveis
clc %limpa o visor 
close all

% Lendo os dados:
[fname path]=uigetfile('*.csv'); 
fname=strcat(path,fname);
% Preenchendo a tabela total tbl:
tbl = readtable(fname);

% Variavel dependente Y: Última coluna da tabela
% Dados X: Todas as colunas (exceto última)
X = tbl(:,1:end-1);
Y = tbl(:,end);
% Transforma o tipo tbl para arrays:
X = table2array(X);
Y = table2array(Y);

%Dimensões do dataset
numClasses = max(Y);
[numAmostras,numCaracteristicas] = size(X);
