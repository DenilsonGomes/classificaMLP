%Autor: Denilson Gomes Vaz da Silva
%Graduando em Engenharia da Computação
%Estudo sobre Evasão do Curso de Engenharia de Computação
%Script para chamar executar o Forward no MLP n vezes
clear
Maximo = 100;
%selecoes = zeros(Maximo,29);
for indiceExt=1:Maximo
    RedeMLPForward
    acuraciaExt(indiceExt) = desempenhoAnterior;
    acuraciasIniciaisExt(indiceExt,:) = acuraciaInicial;
    desempenhoAnteriorAtualExt(indiceExt,:) = [desempenhoAnterior desempenhoAtual];
    selecoes(indiceExt,1:length(select)) = select;
    save('results.mat','acuraciaExt','acuraciaInicial','desempenhoAnterior','desempenhoAtual','selecoes')
end