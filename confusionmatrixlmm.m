function [ TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE ] = cfmatrix( realvalues, predictedvalues )

%% Confusion Matrix Per Cycle
% [C,order]=confusionmat(labels(:,1), labels(:,4));
% %Reorder matrix to put Parkinson first 
% %ConfMatrix = [TP FP;FN TN]
% ConfMatrix = [C(4)  C(2);C(3) C(1)]
% 
% TP = ConfMatrix(1);
% FP = ConfMatrix(2);
% FN = ConfMatrix(3);
% TN = ConfMatrix(4);
% 
% P = TP + FN;
% N = FP + TN;
% 
% %% Metrics
% %Comparar Resultados com http://www.medcalc.org/calc/diagnostic_test.php
% TPRATE =  TP/P
% FPRATE =  FP/N
% PRECISION = TP/(TP +FP)
% ACCURACY = (TP+TN)/(P+N)
% F_SCORE = 2 * (PRECISION * TPRATE)/(PRECISION + TPRATE)

%% Confusion Matrix Per Person
[C,order]=confusionmat(classificationResult(:,2),classificationResult(:,3));
%Reorder matrix to put Parkinson first 
%ConfMatrix = [TP FP;FN TN]
ConfMatrix = [C(4)  C(2);C(3) C(1)];

TP = ConfMatrix(1);
FP = ConfMatrix(2);
FN = ConfMatrix(3);
TN = ConfMatrix(4);

P = TP + FN;
N = FP + TN;

%% Metrics
%Comparar Resultados com http://www.medcalc.org/calc/diagnostic_test.php
TPRATE =  TP/P;
FPRATE =  FP/N;
PRECISION = TP/(TP +FP);
ACCURACY = (TP+TN)/(P+N);
F_SCORE = 2 * (PRECISION * TPRATE)/(PRECISION + TPRATE);
end

