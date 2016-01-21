function [EigenGaitData, labels, testCases] = prepareEigenGaitData(fileNameTest)

    % Source data
    filesH = dir('normal/*.txt');   %Healthy subjects
    filesP = dir('parkinson/*.txt');%Parkinson patients 
    
    %testCasesIndex
    testCases = returnIndexByFilename(fileNameTest, filesH, filesP);
    
    % Scale all cycles to the same length
    scaledCycleLength = 80;
    numberOfcycles = 60; 
    
    %Discard first 5 seconds...
    windowbegin = 500;
    
    % Tlable(*,1) = 0 means healthy, = 1 means parkinson
    % Tlable(*,2) = subject identifying number
    % Tlable(*,3) = 0 train data, = 1 means test data
    numberOfSubjects = length(filesH)+length(filesP);
    labels = zeros(numberOfSubjects*numberOfcycles,3);
    labels(length(filesH)*numberOfcycles+1:end,1) = 1;
    labels(:,2) = reshape(repmat((1:numberOfSubjects)',1,numberOfcycles)',1,[]);
    
    T = zeros((length(filesH)+length(filesP))*numberOfcycles,2*scaledCycleLength);
    cycleCounter = 1;
    
    for j = 1:length(filesH)
    	rawData = importfile(strcat('normal/',filesH(j).name));
        if isFileTest(filesH(j).name, fileNameTest) 
            labels(cycleCounter:cycleCounter+numberOfcycles,3) = 1;
        end
        % get force data from file
        totalForceLeft  = rawData(windowbegin:end,18);
        totalForceRight = rawData(windowbegin:end,19);

        cyclesLeft  = cyclesOfPerson(totalForceLeft,  numberOfcycles, scaledCycleLength);
        cyclesRight = cyclesOfPerson(totalForceRight, numberOfcycles, scaledCycleLength);
        
        r = [cyclesLeft cyclesRight];
        T(cycleCounter:(cycleCounter+numberOfcycles-1),:) = [cyclesLeft cyclesRight];
        cycleCounter = cycleCounter+numberOfcycles;
    end % (j)
        
    for j = 1:length(filesP)
    	rawData = importfile(strcat('parkinson/',filesP(j).name));  

        if isFileTest(filesP(j).name, fileNameTest) 
            labels(cycleCounter:cycleCounter+numberOfcycles,3) = 1;
        end
        % get force data from file
        totalForceLeft  = rawData(windowbegin:end,18);
        totalForceRight = rawData(windowbegin:end,19);

        cyclesLeft  = cyclesOfPerson(totalForceLeft,  numberOfcycles, scaledCycleLength);
        cyclesRight = cyclesOfPerson(totalForceRight, numberOfcycles, scaledCycleLength);
        
        T(cycleCounter:(cycleCounter+numberOfcycles-1),:) = [cyclesLeft cyclesRight];
        cycleCounter = cycleCounter+numberOfcycles;
    end % (j)
    
    %% Filter out defect data
    % compare imagesc(T) with plot(sum((T - (u*MeanGait)).^2,2)) to set
    % threshold
    threshold = 13;
    T(isnan(T))=0;    
    MeanGait = mean(T);
    u = ones(size(T,1),1);
    filterVector = sum((T - (u*MeanGait)).^2,2)<threshold; 
    
    %MeanGait = mean(T); 
    %filterVector = T*MeanGait';
    EigenGaitData = T(filterVector,:);
    labels = labels(filterVector,:);
    
    
end % function

function [result] = isFileTest(filename, files)
    result = false;
        for (i=1:size(files,1))
            if (filename == files(i,:))
                result = true;
                break;
            end
        end
end

function [testCases] = returnIndexByFilename(files, filesHealthy, filesParkinson)
    testCases = [];
    for (i=1:size(files,1))
        for (j=1:size(filesHealthy,1))
            if (files(i,:) == filesHealthy(j,:).name)
                testCases = [testCases j];
                break;
            end
        end
        for (j=1:size(filesParkinson,1))
            if (files(i,:) == filesParkinson(j,:).name)
                testCases = [testCases j+size(filesHealthy,1)];
                break;
            end
        end
     end
end