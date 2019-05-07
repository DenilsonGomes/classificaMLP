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
Y = tbl(:,end); % Classes Y: ultima coluna
% Transforma o tipo tbl para arrays:
X = table2array(X)';
Y = table2array(Y)';

%MultiLayer Perceptron Networking initializarion
mlp = feedforwardnet([5 7]);
mlp.layers{1}.transferFcn = 'tansig';
mlp.layers{2}.transferFcn = 'tansig';

mlp.trainFcn = 'trainlm'; %função de treinamento
mlp.performFcn = 'mse'; %função de perfomance

%Parametros de treinamento
mlp.trainParam.min_grid = 10^-7;
mlp.trainParam.showWindow = true;
mlp.trainParam.espochs = 1000;
mlp.trainParam.time = inf;
mlp.trainParam.goal = 0;

for i=1:17 %para todos os testes
    XTreinamento = X; 
    YTreinamento = Y;
    for j=5:-1:1 %cinco elementos irão testar o modelo
        XTeste(:,j) = X(:,(i-1)*5 + j); %amostras para testar o modelo
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
    acuracia(i)=100*acertos/tamTeste; %acuracia obtida
    str = ['Acuracia obtida: ' num2str(acuracia(i)) ' %'];
    disp(str); %exibe a Acuracia obtida
end

str = ['Acuracia media obtida: ' num2str(mean(acuracia)) ' %'];
disp(str); %exibe a Acuracia obtida