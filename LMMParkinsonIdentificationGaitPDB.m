clear all;
clc;
close all;

%dados descartados 5s (preparação)¨5 * 100 = 500
windowbegin = 500;
windowend = 800;
numcycles = 60;

T = [];

dirnormalfiles = 'trainingnormal2\';
dirparkinsonfiles = 'trainingparkinson2\';
dirnormaltestfiles = 'testnormal\';
dirparkinsontestfiles = 'testparkinson\';


fftlength = 100;


filesparkinson = dir(strcat(dirparkinsonfiles,'*.txt'));
 %fileFolder = fullfile(matlabroot,'work','original');

 
    %Label de Classificao: 0 Grupo de Controle, 1  Parkinsoniano
%     if strcmp(files(i).name(3:4),'Co')
%          classification(i,:) = 0;
%      else
%     classification(i,:) = 1;
%     end
    
THealth = CreateDataBase(dirnormalfiles);
%EigenFaces Normais
[mHealth, aHealth, EigenfacesHealth] = EigenfaceCore(THealth); 

TParkinson = CreateDataBase(dirparkinsonfiles);
[mParkinson, aParkinson, EigenfacesParkinson] = EigenfaceCore(TParkinson); 
    
[eucnormalnormal, eucnormalparkinson] = Testclassification(dirnormaltestfiles, windowbegin, numcycles, mHealth, aHealth, EigenfacesHealth, mParkinson, aParkinson, EigenfacesHealth)
[eucparkinsonnormal, eucparkinsonparkinson] = Testclassification(dirparkinsontestfiles, windowbegin, numcycles, mHealth, aHealth, EigenfacesHealth, mParkinson, aParkinson, EigenfacesParkinson)

 %eigenfaces parkinson

% %kindata = load('Leonardo-levantou-braco-direito-5-vezes-normal.RightHand.dat');
% for i = 1:length(files)
%    gaitDbData = importfile(files(i).name)   
%    lengthdata = length(gaitDbData)
%    
%    
%     %Label de Classificao: 0 Grupo de Controle, 1  Parkinsoniano
%     if strcmp(files(i).name(3:4),'Co')
%         classification(i,:) = 0;
%     else
%         classification(i,:) = 1;
%     end
%    
%    
%     timestamp = gaitDbData(windowbegin:lengthdata,1);    
%     totalForceLeft = gaitDbData(windowbegin:lengthdata,18)
%     totalForceRight = gaitDbData(windowbegin:lengthdata,19)
%     
%     [gaitsright, meanCycle(:,1), varCycle] = LMMGaitCycleMatrix2(totalForceRight, numcycles);
%     [gaitsleft, meanCycle(:,2), varCycle] = LMMGaitCycleMatrix2(totalForceLeft, numcycles);
%     
%     %plot(1:100, meanCycle, 1:100, varCycle/400);
%     figure(i);
%     plot(1:100, meanCycle);
%     legend('MeanCycle Right', 'MeanCycle Left');
%     title(files(i).name);        
% end
% 
% 
% TParkinson = CreateDatabase(TrainDatabasePath);
% 
% 
% %svm file
% %delete('svmtrainindatag');
% save('svmtrainindatag','classification','results');
    
    