svmtrainingdata = [];
svmtestdata = [];
%Make the 10 Fold Cross Validation
for i=1:K
    %the i will be  the index of test data the others will be the trainning
    %data
    trainningKFoldIndex = KFold;    
    %remove testdata
    trainningKFoldIndex([i],:)=[];
    
    %setTestData
    testIndex = KFold(i,:);   
    
    trainIndex = trainningKFoldIndex(:)';
    classification = ones(length(trainIndex),1);
    classification(1:length(trainIndex) * KFoldNormalPercentage) = 0;
    
    % create Training data
    svmtrainingdata = [];
    for(j=1:length(trainIndex))
        svmtrainingdata = [svmtrainingdata ; meanPersonFeatureVectors(trainIndex(j),:)];            
    end    
    
    % create Test data
    svmtestdata = [];
    for(j=1:length(testIndex))
        svmtestdata = [svmtestdata ; meanPersonFeatureVectors(testIndex(j),:)];            
    end    
    
    classificationtest = ones(length(testIndex),1);
    classificationtest(1:length(testIndex) * KFoldNormalPercentage) = 0;
    
    %train SVM RBF_Sigma
    SVMStruct = svmtrain(svmtrainingdata',classification,'rbf', 'RBF_Sigma')
    class = svmclassify(SVMStruct, svmtestdata,'showplot',true);
    diff = class ~= classificationtest
    raterbf = sum(diff)/length (diff)
    %Classificarion of SVM
    KFoldCrossValidationRateRBF(i,1) = 1 - raterbf
    conMat = confusionmat(classificationtest,class) % the confusion matrix
    
    %train SVM Linear
    %SVMStruct = svmtrain(svmtrainingdata',classification,'Kernel_Function', 'linear', 'BoxConstraint', 0.3);
    SVMStruct = svmtrain(svmtrainingdata',classification,'Kernel_Function'8, 'polynomial', 'Polyorder', 2)
    class = svmclassify(SVMStruct, svmtestdata,'showplot',true);
    diff = class ~= classificationtest
    ratelinear = sum(diff)/length (diff)
    %Classificarion of SVM
    KFoldCrossValidationRateLinear(i,1) = 1 - ratelinear
    
    
end

figure(3)
boxplot(KFoldCrossValidationRateRBF);

figure(4)
boxplot(KFoldCrossValidationRateLinear);