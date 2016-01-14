clear all; clc; close all;

%Get data from files
dirnormalfiles = ['trainingnormal\','testnormal\'];
dirparkinsonfiles = ['trainingparkinson\','testparkinson\'];

K=10; %Number of Folds (10 Fold Cross-validation)
TestPercentage = 0.34;  %HoldOut Estimation


%   P = cvpartition(classification,'Holdout',0.30);
%   %'rbf', 'RBF_Sigma': 33,42
%   SVMStruct = svmtrain(results(P.training,:),classification(P.training),'rbf', 'RBF_Sigma')
%   class = svmclassify(SVMStruct, results(P.test,:),'showplot',true)
%   classification(P.test)
%   errRateRbf(j) = sum(classification(P.test)~= class)/P.TestSize  %mis-classification rate  
%   classrate(j,1) = 1 - errRateRbf(j);
  
for j=1:K
    PNormal = cvpartition(dirnormalfiles,'Holdout',0.30);
    PParkinson = cvpartition(dirparkinsonfiles,'Holdout',0.30);
    
end
    
% import and prepare trainig data
TMeanGaitH = CreateDataBaseMeanGait(dirnormalfiles);
TMeanGaitP = CreateDataBaseMeanGait(dirparkinsonfiles);
TMeanGaitAll = [TMeanGaitH, TMeanGaitP];
TMeanGaitAll(isnan(TMeanGaitAll)) = 0;

numberOfTrainingSamples = size(TMeanGaitAll,2);
numberOfHealthyTrainingSamples = size(TMeanGaitH,2);
%calculate Eigengait
[meanGait, A, EigenGaits] = EigenGaitCore(TMeanGaitAll); 


% create Training data
svmtrainingdata = EigenGaits'*A;
classification = ones(numberOfTrainingSamples,1);
classification(1:numberOfHealthyTrainingSamples) = 0;
    
results = svmtrainingdata';
save('svmtrainindatag','classification','results');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This part is of PCA Implementation
% import and prepare test data
TMeanGaitTestH = CreateDataBaseMeanGait(dirnormaltestfiles);
TMeanGaitTestP = CreateDataBaseMeanGait(dirparkinsontestfiles);
TMeanGaitTestAll = [TMeanGaitTestH, TMeanGaitTestP];
TMeanGaitTestAll(isnan(TMeanGaitTestAll)) = 0;
numberOfTestSamples = size(TMeanGaitTestAll,2);
numberOfHealthyTestSamples = size(TMeanGaitTestH,2);



 
    
% classify
for i = 1 : size(TMeanGaitTestAll,2)
    TMeanGaitTestAll(:,i) = TMeanGaitTestAll(:,i) - meanGait;
end % i
svmtestdata = EigenGaits'*TMeanGaitTestAll;
classificationtest = ones(numberOfTestSamples,1);
classificationtest(1:numberOfHealthyTestSamples, 1) = 0;


%train SVM
SVMStruct = svmtrain(svmtrainingdata',classification,'rbf', 'RBF_Sigma')
class = svmclassify(SVMStruct, svmtestdata','showplot',true);

diff = class ~= classificationtest;
rate = sum(diff)/length (diff);


%Classificarion of SVM
rate - 1


%%%%%%%%%%% Alternative (use median instead of mean?)
Healthy =  mean(svmtrainingdata(:,1:numberOfHealthyTrainingSamples),2);
Parkinson = mean(svmtrainingdata(:,numberOfHealthyTrainingSamples+1:end),2);

myClassParkinson = (svmtestdata'* Parkinson) > (svmtestdata'* Healthy);

%Alternative Classificarion of SVM
diff = myClassParkinson ~= classificationtest;
alternativeClassificationRate = sum(diff)/length (diff);
alternativeClassificationRate - 1
    

    