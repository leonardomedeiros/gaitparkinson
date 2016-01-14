clear all; clc; close all;
 
numCycles = 60;
scaledLength = 100;

load GaitDataBase.mat;  

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

%One leave out cross validation
for T=1:numberOfPersons
    % create Training data
    TTrainningGaitAll = TMeanGaitAll;
    TTrainningGaitAll(T,:) = [];
    
    [meanGait, A, EigenGaits] = EigenGaitCore(TTrainningGaitAll); 
    
    %Trainning Data Projection
    trainNumber = size(TTrainningGaitAll,1);
    projectedGaits = [];
    for (j=1:trainNumber) 
        %temp = Eigenfaces'*A(:,i);
        featurevector =  EigenGaits * A(j,:)';
        projectedGaits = [projectedGaits featurevector]; 
    end    
    
    
    
    %Classification Test
    testData = TMeanGaitAll(T,:);
    Difference = testData - meanGait;
    projectedTest = EigenGaits * Difference';
     
    %Classification Using Euclidian Distance
    %%%%%%%%%%%%%%%%%%%%%%%% Calculating Euclidean distances 
    % Euclidean distances between the projected test image and the projection
    % of all centered training images are calculated. Test image is
    % supposed to have minimum distance with its corresponding image in the
    % training database.
    Euc_dist = [];
    for z = 1 : trainNumber
        q = projectedGaits(:,z);
        temp = ( norm(projectedTest - q ) )^2;
        Euc_dist = [Euc_dist temp];
    end
    
    [Euc_dist_min , Recognized_index] = min(Euc_dist);
    if (Recognized_index <= numberOfHealthy)
        labels(T,3) = 0;
    else
        labels(T,3) = 1;
    end
    
end

diff = labels(:,2) ~= labels(:,3)
errorRate = sum(diff)/length(diff)

[TPRATE, FPRATE, PRECISION, ACCURACY, F_SCORE,ConfMatrix] = cfmatrix(labels)