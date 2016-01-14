

function [ gaitcyclefeatures,meanCycle,varCycle ] = LMMGaitCycleMatrix2( rawdatacolumn , numcycles)
i = 1;
begincycle = 1;
indices = find(rawdatacolumn);
begincycle = findInitialGaitIndex(indices);
index = begincycle;
i = 1;

scaledLength = 100; % length all czcles will be scaled to
scaledCycles = zeros(numcycles, scaledLength); % matrix to save data for all scaled cycles from file

while (i<numcycles)
    [endcycle,index] = endCycle(indices,index);
    cycle = rawdatacolumn(begincycle:endcycle);
    begincycle = indices(index);    
    
    if (length(cycle) < 50) 
        continue        
    end
    
    % scaling the cycle
    scaling = scaledLength/length(cycle) .* (1:length(cycle));
    scaledCycles(i,:) = interp1(scaling, cycle, 1:scaledLength);
    
    nonzeroscycle = nonzeros(cycle);
    
    %figure(i);
    %plot(cycle);
    
    %calculate features----------------
    %The coefficient of variation (CV) is defined as the ratio of the standard deviation to the mean :
    %A coefficient variation é definidda como a divisão do desvio padrão pela média
    cv = mean(cycle)/std(cycle);
    gaitcyclefeatures(i,1) = cv;
    
    %calcular o percentual da fase de swing
    %'SwingPhase div StancePhase
    gaitcyclefeatures(i,2) = (length(cycle)-length(nonzeroscycle))/length(nonzeroscycle);
    
    %calcular a média da força em cada ciclo
    gaitcyclefeatures(i,3) = mean(cycle);
    
    
    %colocar numa linha para  a svm
    
    %self organized maps, there is a function to normalization
    
    %gaitcyclefeatures(i,2) = ;
    %gaitcyclefeatures(i,3) = ;
    i = i + 1;
end

% example calculate mean gait cycle for that person/file
meanCycle = mean(scaledCycles);
varCycle = var(scaledCycles);


% for i=1:length(gaitcyclefeatures)
%     stdcycle = std(gaitcyclefeatures(:, 1));
%     cv = gaitcyclefeatures(i,1);
%     gaitcyclefeatures(i,2) = mean(cv,2);
%     gaitcyclefeatures(i,3) = gaitcyclefeatures(i,2) + stdcycle;
%     gaitcyclefeatures(i,4) = gaitcyclefeatures(i,2) - stdcycle;
% end

end


function [initalgaitindex] = findInitialGaitIndex (indices)
   if (indices(1) == 1)
       i = 1;       
       while (indices(i+1) == indices(i)+1) 
        i = i+1;
       end
       initalgaitindex = indices(i+1);
   else
      initalgaitindex = indices(1); 
   end
end

function [ endCycle , indice ] = endCycle( indices , beginat )
%a base possui um ruído e as vezes registra 1 zero e isso dificulta a
%caturar o ciclo colocamos essa variável para verificar a existência de
%zeros
%zerostopdetection = 3;


    i = beginat;
    
    while (indices(i+1) == indices(i)+1) 
        i = i+1;
    end
    
    %if (nonzeroindices(i)+2 == nonzeroindices(i+2))


%pega o índice e incrementa 2 para começar no movimento seguinte
indice = i+1;

%pega o valor do próximo índice e decrementa 1 para obter o número de 0
endCycle = indices(indice) -1;

end