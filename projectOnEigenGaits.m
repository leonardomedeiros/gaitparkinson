function featureVector = projectOnEigenGaits(filename, numcycles, meanGait, EigenGaits)

    windowbegin = 500 % don#t look at the first 500 time units
    
    rawGaitData = importfile(filename);  
    lengthdata = length(rawGaitData);

    % get raw data from file
    totalForceLeft = rawGaitData(windowbegin:lengthdata,18);
    totalForceRight = rawGaitData(windowbegin:lengthdata,19);
    
    % calculate scaled mean gait pattern per person
    meanCycleLeft = meanCycleOfPerson(totalForceLeft, numcycles);
    meanCycleRight = meanCycleOfPerson(totalForceRight, numcycles);

    diffFromMeanTraining = [ meanCycleLeft, meanCycleRight ] - meanGait;
    
    featureVector = EigenGaits'*diffFromMeanTraining;

end % function projectOnEigenGaits