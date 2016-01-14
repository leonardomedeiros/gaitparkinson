%http://www.mathworks.com/matlabcentral/answers/96276-how-does-svmtrain-determine-polynomial-and-rbf-kernel-parameters-gamma-c-in-the-bioinformatics-too
function [ classificationResult ] = svmclassificationfitsvm( labels ,EigenKinnectData, C_box_constraint, rbf_sigma)
%% Select test data vs training data
%The Traiining Data Approach is Leave One Out. Then we will put each
%subject as test data and the others will be traiining data
numberOfSubjects = max(labels(:,1));

for(i=1:numberOfSubjects)
    trainCases = [1:numberOfSubjects];
    trainCases(i) = [];
    
    labels(:,3) = 0; % initialialize all as Trainning data

    %inform the testdat
    labels(labels(:,2) == i,3) = 1;         
    
    %Select TrainingData
    trainingData = EigenKinnectData(labels(:,3)==0,:);
    trainningClassification = labels(labels(:,3) == 0,1);
    
    testData = EigenKinnectData(labels(:,3)==1,:);    
    testSolutionClassification = labels(labels(:,3) == 1,1);
    
    SVMStruct = fitcsvm(trainingData,trainningClassification, 'KernelFunction','rbf', 'BoxConstraint', C_box_constraint, 'KernelScale', rbf_sigma);
    [class,score] = predict(SVMStruct,testData);
    %SVMStruct = svmtrain(trainingData,trainningClassification,'Kernel_Function', 'polinomial', 'BoxConstraint', 0.2);
    %class = svmclassify(SVMStruct, testData);
    
    labels(labels(:,3) == 1,4) = class';
end

classificationResult = personClassification(labels);
end

