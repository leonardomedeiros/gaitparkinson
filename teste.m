%Get data from files
dirnormalfiles = 'normal\';
dirparkinsonfiles = 'parkinson\';
normalfiles = dir(strcat(dirnormalfiles,'*.txt'));
parkinsonfiles = dir(strcat(dirparkinsonfiles,'*.txt'));

% import and prepare trainig data
% This files is to create the database
if exist('GaitDataBaseAll.mat')==false
    TMeanGaitH = CreateDataBaseMeanGait(dirnormalfiles,numCycles, scaledLength);
    TMeanGaitP = CreateDataBaseMeanGait(dirparkinsonfiles,numCycles, scaledLength);
    TMeanGaitAll = [TMeanGaitH, TMeanGaitP];
    TMeanGaitAll(isnan(TMeanGaitAll)) = 0;
    save('GaitDataBaseAll.mat', 'TMeanGaitH', 'TMeanGaitP', 'TMeanGaitAll');
else
    load GaitDataBaseAll.mat    
end