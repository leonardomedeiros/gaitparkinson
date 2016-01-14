

function cyclesPerson = cyclesOfPerson( rawdatacolumn , numcycles, scaledLength)
% Calculated mean cycle pattern for one person and scales it to 100 time
% units
i = 1;
begincycle = 1;
indices = find(rawdatacolumn);
begincycle = findInitialGaitIndex(indices);
index = begincycle;
i = 1;

scaledCycles = zeros(numcycles, scaledLength); % matrix to save data for all scaled cycles from file

%normalizationvariable = zeros(numcycles);
normalizationvariable = 0;
while (i<=numcycles)
    [endcycle,index] = endCycle(indices,index);
    cycle = rawdatacolumn(begincycle:endcycle);
    begincycle = indices(index);    
    
    if (length(cycle) < 80) 
        continue        
    end
    
    %nonzeroscycle = nonzeros(cycle);    
    % scaling the cycle
    scaling = scaledLength/length(cycle) .* (1:length(cycle));
    scaledCycles(i,:) = interp1(scaling, cycle, 1:scaledLength);
    
    %https://en.wikipedia.org/wiki/Normalization_(statistics)
    
    % maybe here some normalization of the signa to max 1
    %we get the normalization by the mean
    normalizationvariable(i) = max(scaledCycles(i,:));
    i = i + 1;
end

  %the normalization variable will be made by the mean
  %normalized by time and amplitude
  meanNormalizationVariable = mean(normalizationvariable);
  scaledCycles = scaledCycles./meanNormalizationVariable;
  
  %
 
 
% example calculate mean gait cycle for that person/file
cyclesPerson = scaledCycles;
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
%a base possui um ru�do e as vezes registra 1 zero e isso dificulta a
%caturar o ciclo colocamos essa vari�vel para verificar a exist�ncia de
%zeros
%zerostopdetection = 3;


    i = beginat;
    
    while (indices(i+1) == indices(i)+1) 
        i = i+1;
    end
    
    %if (nonzeroindices(i)+2 == nonzeroindices(i+2))


%pega o �ndice e incrementa 2 para come�ar no movimento seguinte
indice = i+1;

%pega o valor do pr�ximo �ndice e decrementa 1 para obter o n�mero de 0
endCycle = indices(indice) -1;

end