%% Plot do Vetor M�dio
figure(1)
hold on
%plot(mean(TMeanGaitAll),'b-','LineWidth',3);

plot(mean(TMeanGaitH),'r:','LineWidth',3)
plot(mean(TMeanGaitP),'g--','LineWidth',3);
title('Mean Scaled (100 Frames) and Normalized (0..1) Gait Vector','FontWeight','bold','FontSize',14)
text(18,0.5,'Left Foot','FontSize',12,'FontWeight','bold');
text(96,0.5,'Right Foot','FontSize',12,'FontWeight','bold');
legend('All Subjects', 'Healthy Group','PD Group');
hold off


%% Imagem da Proje��o no AutoEspa�o
figure(2)

%Projection into eigenspace
[meanGait, A, EigenGaits] = EigenGaitCore(TMeanGaitAll); 

trainNumber = size(TMeanGaitAll,1);
%Trainning Datasize(TMeanGaitAll,1) Projection
projectedPCA = [];
for (j=1:trainNumber) 
    %temp = Eigenfaces'*A(:,i);
    featurevector =  EigenGaits * A(j,:)';
    projectedPCA = [projectedPCA featurevector]; 
end   


    %EigenGaits = A * L_eig_vec;

    %% Select EigenGait vectors with the best discrimination between healthy and parkinson
    %dQ = median(EigenGaits(labelsTrain(:,1)==0,:))-median(EigenGaits(labelsTrain(:,1)>0,:));
    %[svalue, sindex] = sort(dQ,'descend');
    %discrminationQuality = sum(svalue(1:3))
    %EigenGaitsSelected = EigenGaits(:,sindex(1:5));



numberOfTrainHealthy = size(TMeanGaitH,1);
indexOfParkinsonData = numberOfTrainHealthy + 1;

hold on
%Scatter -Healthy Subjects
scatter3(projectedPCA(1:numberOfTrainHealthy,1),projectedPCA(1:numberOfTrainHealthy,2), projectedPCA(1:numberOfTrainHealthy,3), 24, 'blue','f')
grid on
%Scatter -Parkinson Subjects
scatter3(projectedPCA(indexOfParkinsonData:end,1),projectedPCA(indexOfParkinsonData:end,2), projectedPCA(indexOfParkinsonData:end,3), 24, 'red'),
title('Plot em 3D na Proje��o no AutoEspa�o Com as 3 PCAs Mais Discriminantes','FontWeight','bold')
legend('N�o-Parkinsoniano','Parkinsoniano');
xlabel('1a PCA Selecionada');
ylabel('2a PCA Selecionada');
zlabel('3a PCA Selecionada');
hold off