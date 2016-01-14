function T = CreateDatabase(TrainDatabasePath)
% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     TrainDatabasePath      - Path of the training database
%
% Returns:      T                      - A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MN and 'T' will be a MNxP 2D matrix.
%
% See also: STRCMP, STRCAT, RESHAPE

% Original version by Amir Hossein Omidvarnia, October 2007
%                     Email: aomidvar@ece.ut.ac.ir                  
% Extended version by Leonardo Medeiros, July 2013
%%%%%%%%%%%%%%%%%%%%%%%% File management

%dados descartados 5s (preparação)¨5 * 100 = 500
windowbegin = 500;
numcycles = 60;

filesnormal = dir(strcat(TrainDatabasePath,'*.txt'));
T = [];
%eigenfaces normal
 for i = 1:length(filesnormal)   
     filesnormal(i).name
    gaitDbData = importfile(strcat(TrainDatabasePath,filesnormal(i).name))  
    lengthdata = length(gaitDbData)

    timestamp = gaitDbData(windowbegin:lengthdata,1);    
    totalForceLeft = gaitDbData(windowbegin:lengthdata,18)
    %totalForceRight = gaitDbData(windowbegin:lengthdata,19)

    %Try to put both feet
    %[gaitsright, meanCycle(:,1), varCycle] = LMMGaitCycleMatrix2(totalForceRight, numcycles);
    %[gaitsleft, meanCycle(:,2), varCycle] = LMMGaitCycleMatrix2(totalForceLeft, numcycles);
    
    %At begining lets try do eigenvalue of left foot
    [gaitsleft, meanCycle, varCycle] = LMMGaitCycleMatrix2(totalForceLeft, numcycles);
    
    %img = plot(1:100, meanCycle);
    
    % I dont no why thereis NAN in the beggining and in the end of scaledcycle
    T = [T meanCycle(2:length(meanCycle)-1)']; % 'T' grows after each turn    
 end


