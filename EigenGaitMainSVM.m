clear all; clc; close all;
 
numCycles = 60; % number of cycles
scaledLength = 100; % length all czcles will be scaled to

%Get data from files
dirnormalfiles = 'normal/';
dirparkinsonfiles = 'parkinson/';
normalfiles = dir(strcat(dirnormalfiles,'*.txt'));
parkinsonfiles = dir(strcat(dirparkinsonfiles,'*.txt'));
 
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


%for each person I have a ScaledLength of 80 points for each cycle 
%I have too leftCycles and RightCycles
numberOfHealthy = size(TMeanGaitH,1);
numberOfParkinson = size(TMeanGaitP,1);
numberOfPersons = size(TMeanGaitAll,1);


labels = zeros(numberOfPersons,3);
%Person Id
labels(1:numberOfPersons,1) = [1:numberOfPersons];
%Labels of Parkinson
labels(1:numberOfHealthy,2) = 0;
labels(numberOfHealthy+1:end,2) = 1;


%Calculate PCA Values
[meanGait, A, EigenGaits] = EigenGaitCore(TMeanGaitAll); 

    projectedGaits = [];
    for (j=1:numberOfPersons) 
        %temp = Eigenfaces'*A(:,i);
        featurevector =  EigenGaits * A(j,:)';
        projectedGaits = [projectedGaits ;featurevector']; 
    end    

% %Grid Searching
% %C_VALUES = [2^-5; 2^-3; 2^-1; 2^1; 2^3; 2^5; 2^7; 2^9; 2^11; 2^13; 2^15];
% C_VALUES = [2^-5; 2^-4; 2^-3; 2^-2; 2^-1;2^0;2^1;2^2;2^4; 2^5];
% SIGMA_VALUES = [1 2 3 4 5 6 7 8 9 10];
% %SIGMA_VALUES = [2^-15 2^-13 2^-11 2^-9 2^-7 2^-5 2^-3 2^-1 2^1 2^3];
% grid_searching_matrix = zeros(size(C_VALUES,1)+1, size(SIGMA_VALUES,2)+1);
% grid_searching_matrix(2:size(C_VALUES,1)+1,1) = C_VALUES;
% grid_searching_matrix(1, 2:size(SIGMA_VALUES,2)+1) = SIGMA_VALUES;

%SVMModel = fitcsvm(projectedGaits,labels(:,2),'KernelFunction','rbf','Standardize',true,'ClassNames',{'negClass','posClass'});

SVMStruct = svmtrain(projectedGaits,labels(:,2), 'Kernel_Function', 'rbf', 'RBF_Sigma', 1, 'BoxConstraint', 0.25);
    
%SVMStruct = svmtrain(trainingData,trainningClassification,'Kernel_Function', 'polinomial', 'BoxConstraint', 0.2);
class = svmclassify(SVMStruct, projectedGaits(45:55,:));

%CVSVMModel = crossval(SVMModel,'Leaveout','on');
%L = kfoldLoss(cvmodel)


% classificationResult = personClassification(labels);
% [TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE] = confusionmatrix(classificationResult)
% [C,order]=confusionmat(classificationResult(:,2),classificationResult(:,3))
% ConfMatrix = [C(4)  C(2);C(3) C(1)]    