%% Prepare data
if exist('EigenGaitData.mat')
    load('EigenGaitData.mat');     
else 
    [EigenGaitData, labels] = prepareEigenGaitData();
    save('EigenGaitData.mat', 'EigenGaitData', 'labels');
    clear Ga*;
    clear Ju*; 
end % if

    % Labeling scheme:
    % Tlable(*,1) = 0 means healthy, = 1 means parkinson
    % Tlable(*,2) = subject identifying number
    % Tlable(*,3) = 0 train data, = 1 means test data

%% Selct test data vs training data
K = 10;
KFoldSize = numberOfSubjects/KFold;
numberOfSubjects = max(labels(:,2));
errorrate = 0;

r = randperm(numberOfSubjects);

%Generate KFolds
fold = [];
for ki = 1: K
   fold = [fold ; r((ki-1)*KFoldSize + 1:ki*KFoldSize)];
end

%CrossValidation
for ki = 1: KFold    
    %TrainData and Remove TestCases
    trainCases = fold;
    %remove testdata
    trainCases([ki],:)=[];
    %put the matrix in one line
    trainCases = reshape(trainCases.',1,[]);
    %testCasesKFold
    testCases = fold(ki);    
end
