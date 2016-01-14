clear all;
close all;
load('svmtrainindatag','classification','results');

%Partição de grupo de treinamento e teste
%P = cvpartition(classification,'Holdout',0.30);

%figure(1)

%SVMStruct = svmtrain(results(trainingMatrix,:),classification(trainingMatrix));
%class = svmclassify(SVMStruct, results(testIndex,:),'Showplot',true)
%SVMStruct = svmtrain(results(P.training,:),classification(P.training),'showplot',true);

%Kernel Polinomial de ordem 4
%SVMStruct = svmtrain(results(P.training,:),classification(P.training),'Kernel_Function', 'polynomial', 'Polyorder', 4)

%Kernel RBF
%SVMStruct = svmtrain(results(P.training,:),classification(P.training),'rbf', 'RBF_Sigma')
%SVMStruct = svmtrain(results(P.training,:),classification(P.training),'Kernel_Function', 'linear', 'BoxConstraint', 0.3);


for j=1:1000
  P = cvpartition(classification,'Holdout',0.30);
  %'rbf', 'RBF_Sigma': 33,42
  SVMStruct = svmtrain(results(P.training,:),classification(P.training),'rbf', 'RBF_Sigma')
  class = svmclassify(SVMStruct, results(P.test,:),'showplot',true)
  classification(P.test)
  errRateRbf(j) = sum(classification(P.test)~= class)/P.TestSize  %mis-classification rate  
  classrate(j,1) = 1 - errRateRbf(j);
end

for j=1:1000
  P = cvpartition(classification,'Holdout',0.30);
  SVMStruct = svmtrain(results(P.training,:),classification(P.training),'Kernel_Function', 'linear', 'BoxConstraint', 0.3);
  class = svmclassify(SVMStruct, results(P.test,:),'showplot',true)
  classification(P.test)
  errRateLinear(j) = sum(classification(P.test)~= class)/P.TestSize  %mis-classification rate  
  classrate(j,2) = 1 - errRateLinear(j);
end

boxplot(classrate) 
mean(classrate) 
%testresult = classification(testIndex)

%Resultado do Treinamento-----------------
%classification(P.test)
%errRate = sum(classification(P.test)~= class)/P.TestSize  %mis-classification rate
%conMat = confusionmat(classification(P.test),class) % the confusion matrix



