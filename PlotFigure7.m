%% Rewrite to check line by line

clear all; clc; close all;
 
%% Select Test Files
fileNameTestMatrix = ['GaCo15_01.txt'; 'GaCo15_02.txt'; 'GaCo15_10.txt'; 'GaPt31_01.txt'; 'GaPt31_02.txt'; 'GaPt31_10.txt'];



%This was the selected Cases to Track the Subjects Along the Time, thats
%corresponds to fileNameTestMatrix
testCases = [26 27 28 98 99 100];


%% Prepare data
if exist('EigenGaitData.mat')
    load('EigenGaitData.mat');     
else 
    [EigenGaitData, labels, testCases] = prepareEigenGaitData(fileNameTestMatrix);
    save('EigenGaitData.mat', 'EigenGaitData', 'labels', 'testCases');
    clear Ga*;
    clear Ju*; 
end % if

testCases

%Train Cases
trainCases = (1:100);
%Remove the Test Cases From Train
trainCases(testCases) = [];

    % Labeling scheme:
    % Tlable(*,1) = 0 means healthy, = 1 means parkinson
    % Tlable(*,2) = subject identifying number
    % Tlable(*,3) = 0 train data, = 1 means test data

%% Select test data vs training data
numberOfSubjects = max(labels(:,2));
numberOfTestCases = size(fileNameTestMatrix,1);
numberOfTrainCases = numberOfSubjects - numberOfTestCases;

%FOR GOD I HAVE  TO CHANGE THIS :)
numberOfTrainHealthy = numberOfTrainCases / 2;
indexOfParkinsonData = numberOfTrainHealthy + 1; 
%numberOfTestCases = numberOfSubjects - numberOfTrainCases;



EigenGaitTrainData = EigenGaitData(labels(:,3)==0,:);
EigenGaitTestData  = EigenGaitData(labels(:,3)==1,:);
labelsTrain = labels(labels(:,3)==0,:);
labelsTest  = labels(labels(:,3)==1,:);

%% Calculate EigenGait matrix

MeanGait = mean(EigenGaitTrainData);
u = ones(size(EigenGaitTrainData,1),1);
A = EigenGaitTrainData - (u*MeanGait); % remember the transform!!
L = A'*A;
[V D] = eig(L);
L_eig_vec = [];
    for i = 1 : size(V,2) 
        if( D(i,i) > 100 )
            L_eig_vec = [L_eig_vec V(:,i)];
        end
    end
EigenGaits = A * L_eig_vec;

%% Select EigenGait vectors with the best discrimination between healthy and parkinson
dQ = median(EigenGaits(labelsTrain(:,1)==0,:))-median(EigenGaits(labelsTrain(:,1)>0,:));
[svalue, sindex] = sort(dQ,'descend');
discrminationQuality = sum(svalue(1:3))
EigenGaitsSelected = EigenGaits(:,sindex(1:5));

%% Visualize in 3d plot

personalGait = zeros(numberOfTrainCases, 4); % first 3 are eigenvalues, 4th is label parkinson/healthy
for j = 1:numberOfTrainCases 
    personalGait(j,1:3)= median(EigenGaitsSelected(labelsTrain(:,2)==trainCases(j),1:3));
    personalGait(j,4)= max(labelsTrain(labelsTrain(:,2)==trainCases(j),1));
end

%% Plot do Vetor M�dio
figure(1)
hold on
cyclesHealth = size(EigenGaitData,1) * 0.5
%plot(mean(EigenGaitData),'green','LineWidth',2,'--');
%plot(mean(EigenGaitData(1:cyclesHealth,1:160)),'blue','LineWidth',2)
%plot(mean(EigenGaitData(cyclesHealth+1:end,1:160)),'red','LineWidth',2);
%set(gcf,'Color',[1,0.4,0.6])
plot(mean(EigenGaitData),'b-','LineWidth',3);

plot(mean(EigenGaitData(1:cyclesHealth,1:160)),'r:','LineWidth',3)
plot(mean(EigenGaitData(cyclesHealth+1:end,1:160)),'g--','LineWidth',3);
title('Mean Scaled (80 Frames) and Normalized (0..1) Gait Vector','FontWeight','bold','FontSize',14)
text(18,0.5,'Left Foot','FontSize',12,'FontWeight','bold');
text(96,0.5,'Right Foot','FontSize',12,'FontWeight','bold');
legend('All Subjects', 'Healthy Group','PD Group');
hold off

%% Imagem da Proje��o no AutoEspa�o
figure(2)
hold on
%Scatter -Healthy Subjects
scatter3(personalGait(1:numberOfTrainHealthy,1),personalGait(1:numberOfTrainHealthy,2), personalGait(1:numberOfTrainHealthy,3), 24, 'blue','f')
grid on
%Scatter -Parkinson Subjects
scatter3(personalGait(indexOfParkinsonData:end,1),personalGait(indexOfParkinsonData:end,2), personalGait(indexOfParkinsonData:end,3), 24, 'red'),
title('Plot em 3D na Proje��o no AutoEspa�o Com as 3 PCAs Mais Discriminantes','FontWeight','bold')
legend('N�o-Parkinsoniano','Parkinsoniano');
xlabel('1a PCA Selecionada');
ylabel('2a PCA Selecionada');
zlabel('3a PCA Selecionada');
hold off

%% Classification
    u = ones(size(EigenGaitTestData,1),1);
    EigenGaitsTestForClassifying = (EigenGaitTestData - (u*MeanGait))* L_eig_vec; 
    EGTFCSelected = EigenGaitsTestForClassifying(:,sindex(1:5));

    personalGaitT = zeros(numberOfTestCases, 4); % first 3 are eigenvalues, 4th is label parkinson/helthy
    for j = 1:numberOfTestCases
        personalGaitT(j,1:3)= median(EGTFCSelected(labelsTest(:,2)==testCases(j),1:3));
        personalGaitT(j,4)= max(labelsTest(labelsTest(:,2)==testCases(j),1));
    end

    figure(3)
    scatter3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3), 12, personalGaitT(:,4));
    title('TEST: persons plotted based on 3 most relevant eigenvectors, red = parkinson')

    u = ones(numberOfTrainCases,1);
    classification = ones(numberOfTestCases,2)*2;
    
    for j = 1:numberOfTestCases
        [minVal, minIndex] = min(sum((personalGait(:,1:3) - (u*personalGaitT(j,1:3))).^2,2));
        classification(j,1) = personalGait(minIndex,4);
        classification(j,2) = personalGaitT(j,4);
    end
    figure(4)
    imagesc(classification)
    
    errorrate=sum(classification(:,1)~=classification(:,2))/numberOfTestCases
 figure(5)
 boxplot(errorrate)
 title('Ten K-Fold CrossValidation')

 
 %% Imagem do Monitoramento de Um Indiv�duo de Cada Grupo
figure(7)
hold on
%scatter3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3), 12, personalGaitT(:,4));
%title('TEST: persons plotted based on 3 most relevant eigenvectors, red = parkinson')

%scatter3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3), 36, personalGaitT(:,4), 'filled');
scatter3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3), 36, personalGaitT(:,4), '*');
%scatter3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3), 36, personalGaitT(:,4),'--rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10)

%Scatter -Healthy Subjects
scatter3(personalGait(1:numberOfTrainHealthy,1),personalGait(1:numberOfTrainHealthy,2), personalGait(1:numberOfTrainHealthy,3), 24, personalGait(1:numberOfTrainHealthy,4)),

%Scatter -Parkinson Subjects
scatter3(personalGait(indexOfParkinsonData:end,1),personalGait(indexOfParkinsonData:end,2), personalGait(indexOfParkinsonData:end,3), 24, personalGait(indexOfParkinsonData:end,4),'f'),

%plot3((personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3))

%plot3(personalGaitT(:,1),personalGaitT(:,2), personalGaitT(:,3))
plot3(personalGaitT(1:3,1),personalGaitT(1:3,2), personalGaitT(1:3,3), 'blue')
plot3(personalGaitT(4:6,1),personalGaitT(4:6,2), personalGaitT(4:6,3), 'red')
grid on
labelGap = 0.01;
text(personalGaitT(4,1)+labelGap,personalGaitT(4,2)+labelGap,personalGaitT(4,3)+labelGap,'Indiv�duo Parkisoniano');
text(personalGaitT(1,1)+labelGap,personalGaitT(1,2)+labelGap,personalGaitT(1,3)+labelGap,'Indiv�duo N�o-Parkisoniano');
legend('Indiv�duo Teste', 'N�o-Parkinsoniano','Parkinsoniano','Trajet�ria');
title('Exemplo de Proje��o de Indiv�duos de Treinamento versus 1 Indiv�duo de Teste de Cada Grupo','FontWeight','bold')
xlabel('1a PCA Selecionada');
ylabel('2a PCA Selecionada');
zlabel('3a PCA Selecionada');
hold off
