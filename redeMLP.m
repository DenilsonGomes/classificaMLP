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

%Mapeia as classes para {1,2,3}
for i=1:length(Y)
    if(Y(i)<4) %Entre 0 e 3.9
        Yaux(i) = 1; %Classe 1
    end
    if(Y(i)>=4 && Y(i)<7) %Entre 4 e 6.9
        Yaux(i) = 2; %classe 2
    end
    if(Y(i) >= 7) %Entre 7 e 10
        Yaux(i) = 3; %classe 3
    end
end
Y = Yaux;

%MultiLayer Perceptron Networking initializarion
mlp = feedforwardnet([20 20]);
mlp.layers{1}.transferFcn = 'tansig';
mlp.layers{2}.transferFcn = 'tansig';

%dimensões do dataset
[linha, coluna] = size(X);
for i=1:round(coluna/5) %para todos os testes
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

str = ['Acuracia media obtida com todas as variaveis: ' num2str(mean(acuracia)) ' %'];
disp(str); %exibe a Acuracia obtida