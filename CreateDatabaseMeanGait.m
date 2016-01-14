function T = CreateDatabaseMeanGait(TrainDatabasePath, numcycles, scaledLength)

% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     Files      - Array of SelectedFiles
%
% Returns:      T          - A 2D matrix, containing all 1D image vectors.
%                            Suppose all P images in the training database 
%                            have the same size of MxN. So the length of 1D 
%                            column vectors is MN and 'T' will be a MNxP 2D matrix.
%
% See also: STRCMP, STRCAT, RESHAPE

% Original version by Amir Hossein Omidvarnia, October 2007
%                     Email: aomidvar@ece.ut.ac.ir                  
% Extended version by Leonardo Medeiros, July 2013
%%%%%%%%%%%%%%%%%%%%%%%% File management

%dados descartados 5s (preparação)¨5 * 100 = 500
windowbegin = 500;

filesnormal = dir(strcat(TrainDatabasePath,'*.txt'));
%T = zeros(length(filesnormal)*numcycles, 2*scaledLength);
T = [];
%eigengait normal
 for i = 1:length(filesnormal)   
     
    filesnormal(i).name
    gaitDbData = importfile(strcat(TrainDatabasePath,filesnormal(i).name));  
    lengthdata = length(gaitDbData);

    % get raw data from file
    totalForceLeft = gaitDbData(windowbegin:lengthdata,18);
    totalForceRight = gaitDbData(windowbegin:lengthdata,19);
    
    % calculate scaled mean gait pattern per person
    cyclesLeft = cyclesOfPerson(totalForceLeft, numcycles, scaledLength);
    cyclesRight = cyclesOfPerson(totalForceRight, numcycles, scaledLength);
    
        
    cyclesPerson = [cyclesLeft, cyclesRight];
     
    %reshape files of 1D
    [irow icol] = size(cyclesPerson);
    reshapeCycle = reshape(cyclesPerson,irow*icol,1);
    
    
    T = [T;reshapeCycle'];     
 end % for i
 

end % function



