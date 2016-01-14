function [ euclidiannormal, euclidianparkinson ] = Testclassification( testDirectory , windowbegin, numcycles, mHealth, aHealth, EigenFacesHealth, mParkinson, aParkinson, EigenFacesParkinson)
    files = dir(strcat(testDirectory,'*.txt'));
    
    for i=1:length(files)
        testfile = importfile(strcat(testDirectory,files(1).name))     
        totalForceLeft = testfile(windowbegin:length(testfile),18)
        [gaitsleft, testMeanCycle, varCycle] = LMMGaitCycleMatrix2(totalForceLeft, numcycles);
        
        %Reconhecer Valor
        euclidiannormal(:,i) = Recognition(testMeanCycle(2:length(testMeanCycle)-1)', mHealth, aHealth, EigenFacesHealth);
        euclidianparkinson(:,i) = Recognition(testMeanCycle(2:length(testMeanCycle)-1)', mParkinson, aParkinson, EigenFacesParkinson);
    end

end

