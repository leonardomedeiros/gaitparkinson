close all;

 % import and prepare trainig data
% This files is to create the database
figure(1)
if exist('GaitDataBase.mat')==false
    TMeanGaitH = CreateDatabaseMeanGait(dirnormalfiles,numCycles, scaledLength);
    TMeanGaitP = CreateDatabaseMeanGait(dirparkinsonfiles,numCycles, scaledLength);
    TMeanGaitAll = [TMeanGaitH;TMeanGaitP];
    TMeanGaitAll(isnan(TMeanGaitAll)) = 0;
    save('GaitDataBase.mat', 'TMeanGaitH', 'TMeanGaitP', 'TMeanGaitAll');
else
    load GaitDataBase.mat    
end


figure(5)
hold on
plot(mean(TMeanGaitH),'r')
plot(mean(TMeanGaitP),'b')
legend('Control Group','Parkinson')
hold off