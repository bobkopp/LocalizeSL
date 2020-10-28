% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-10-28 09:38:17 -0400

addpath(fullfile(pwd,'scripts'));

rootdir='~/Dropbox/Code/LocalizeSL';
addpath(fullfile(rootdir,'MFILES'));

runComposeCorefile;

condtargyrs=[2100];
condtargs=[30 50 100 150 200 250] * 10;
condtargwins=[10 10 10 20 50 100];


addpath(pwd);
runSeaLevelConditionalDistributions
cd ..
runSeaLevelConditionalDistributionUncorrelatedLow
cd ..

addpath(pwd)
workdir='workdir-200917';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);
runCombineNonclimaticBackground