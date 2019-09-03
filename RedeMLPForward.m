%Autor: Denilson Gomes Vaz da Silva
%Graduando em Engenharia da Computação
%Estudo sobre Evasão do Curso de Engenharia de Computação

clearvars -except indiceExt selecoes acuraciaExt acuraciasIniciaisExt %limpa as variaveis
clc %limpa o visor 
close all

% Lendo os dados:
% [fname path]=uigetfile('*.csv'); 
% fname=strcat(path,fname);
% Preenchendo a tabela total tbl:
% tbl = readtable(fname);
tbl = readtable('C:\Users\Tery\Dropbox\Evasão na Eng Comput UFC\redeMLP\calculo1.csv');

% Variavel dependente Y: Última coluna da tabela
% Dados X: Todas as colunas (exceto última)
X = tbl(:,1:end-1);
Y = tbl(:,end); % Classes Y: ultima coluna
% Transforma o tipo tbl para arrays:
X = table2array(X)';
Y = table2array(Y)';

% %Mapeia as classes para {1,2,3}
for i=1:length(Y)
    if(Y(i)<4) %Entre 0 e 3.9
        Yaux(i) = 1; %Classe 1
    end
    if(Y(i) >= 4 && Y(i) < 7) %Entre 4 e 6.9
        Yaux(i) = 2; %classe 2
    end
    if(Y(i) >= 7) %Entre 7 e 10
        Yaux(i) = 3; %classe 3
    end
end
Y = Yaux;

%MultiLayer Perceptron Networking initializarion
mlp = feedforwardnet([10 10]);
mlp.layers{1}.transferFcn = 'tansig';
mlp.layers{2}.transferFcn = 'tansig';

%Forward selection (começa sem nenhuma, vai adicioando)
%Adicionando a primeira variavel
[z,coluna] = size(X);
for v=1:z %para todas as variaveis
       
    for i=1:round(coluna/5) %para todos os testes
        XTreinamento = X(v,:); % Treinamos com cada variavel v
        YTreinamento = Y; %YTreinamento
        for j=5:-1:1 %cinco elementos irão testar o modelo
            XTeste(:,j) = XTreinamento(:,(i-1)*5 + j); %amostras para testar o modelo
            XTreinamento(:,(i-1)*5 + j) = []; %ficam so as amostras que vão treinar o modelo
            YTeste(:,j) = Y(:,(i-1)*5 + j); %classes para verificar acuracia do modelo
            YTreinamento(:,(i-1)*5 + j) = []; %ficam so as classes que vão treinar o modelo
        end
    
        %treinando a rede com tamTreino
        mlp = train(mlp,XTreinamento,YTreinamento);
    
        %testando a rede com tamTeste
        yout = mlp(XTeste);
        %yout = round(yout); %podemos arredondar yout e comparar com Y
        %calcula acuracia
        acertos = 0; %acertos
        [~,tamTeste] = size(XTeste); %numero de testes
        for j=1:tamTeste
            if abs(yout(j) - YTeste(j)) < 0.5 %caso a rede neural tenha acertado
                acertos = acertos +1; %acrescenta acertos
            end
        end
        acuracia(i)=100*acertos/tamTeste; %acuracia obtida no i-esimo experimento
    end
    acuraciaInicial(v) = mean(acuracia); %media de acuracia da v-esima variavel
end
[desempenhoAnterior,g] = max(acuraciaInicial); %pega a variavel que obteve maior acuracia
Xselect = X(g,:); %primeira variavel adicionada na seleção
Xaux = X; %X auxiliar
Xaux(g,:) = [];
count = 1; %variavel para contar variaveis selecionadas

desempenhoAtual = desempenhoAnterior; %atribuição para entrar no while na primeira execução
while desempenhoAnterior <= desempenhoAtual %enquanto alguma variavel melhorar o desempenho do modelo
     
    %MultiLayer Perceptron Networking initializarion
    mlp = feedforwardnet([10 10]);
    mlp.layers{1}.transferFcn = 'tansig';
    mlp.layers{2}.transferFcn = 'tansig';
    
    [z,coluna] = size(Xaux); %atualiza dimensão do dataset
    for v=1:z %para todas as variaveis restantes
             
        for i=1:round(coluna/5) %para todos os testes
            
            clear XTreinamento YTreinamento XTeste YTeste; %apaga as variaveis de treino e teste
            XTreinamento = Xselect; %Variaveis ja no modelo
            
            XTreinamento(count+1,:) = Xaux(v,:); % Adicionamos a variavel v
            YTreinamento = Y; %YTreinamento
            for j=5:-1:1 %cinco elementos irão testar o modelo
                XTeste(:,j) = XTreinamento(:,(i-1)*5 + j); %amostras para testar o modelo
                XTreinamento(:,(i-1)*5 + j) = []; %ficam so as amostras que vão treinar o modelo
                YTeste(:,j) = Y(:,(i-1)*5 + j); %classes para verificar acuracia do modelo
                YTreinamento(:,(i-1)*5 + j) = []; %ficam so as classes que vão treinar o modelo
            end
    
            %treinando a rede com tamTreino
            mlp = train(mlp,XTreinamento,YTreinamento);
    
            %testando a rede com tamTeste
            yout = mlp(XTeste);
            %yout = round(yout); %podemos arredondar yout e comparar com Y
            %calcula acuracia
            acertos = 0; %acertos
            [~,tamTeste] = size(XTeste); %numero de testes
            for j=1:tamTeste
                if abs(yout(j) - YTeste(j)) < 0.5 %caso a rede neural tenha acertado
                    acertos = acertos +1; %acrescenta acertos
                end
            end
            acuracia(i)=100*acertos/tamTeste; %acuracia obtida no i-esimo experimento
        end
        acuraciaAtual(v) = mean(acuracia); %media de acuracia da v-esima variavel
    end   
    [desempenhoAtual,g] = max(acuraciaAtual); %pega a variavel que obteve maior acuracia
    %testando se diminui o tamanho de acuraciAtual aki
    clear acuraciaAtual
    
    %Caso alguma variavel melhore o modelo
    if desempenhoAnterior <= desempenhoAtual
        count = count+1; %mais uma variavel selecionada
        Xselect(count,:) = Xaux(g,:); %adiciona variavel que acrescenta maior acuracia
        Xaux(g,:) = []; %remove a variavel do conjunto de selecionaveis
        [z,coluna] = size(Xaux); %atualiza dimensão do dataset
        desempenhoAnterior = desempenhoAtual; %desempenhoAtual vira desempenhoAnterior
    else
        break
    end
end
%forward selection finalizado
[a,~] = size(Xselect);
[b,~] = size(X);
for i=1:a %para todas as variaveis
    for j=1:29 %para as variaveis selecionadas
        if Xselect(i,:) == X(j,:); %caso seja a mesma variavel
            select(i) = j; %guarda o numero da variavel selecionada
        end
    end
end