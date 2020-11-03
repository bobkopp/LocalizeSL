% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-10-28 12:01:10 -0400

rootdir='~/Dropbox/Code/LocalizeSL';
addpath(fullfile(rootdir,'MFILES'));
addpath(fullfile(rootdir,'scripts/Sweet2021'));
addpath(pwd);

runComposeCorefile;

condtargyrs=[2100];
condtargs=[30 50 100 150 200 250] * 10;
condtargwins=[10 10 10 20 50 100];

workdir='workdir-201028';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);
runSeaLevelConditionalDistributions
cd ..

workdir='workdir-201028-Low';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);
runSeaLevelConditionalDistributionUncorrelatedLow
cd ..

addpath(pwd)

runGeolBkgd % note this requires ProjectSL to be installed, as well as a GMSL curve and rlr_annual
cd ..

workdir='workdir-201028';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);
runCombineNonclimaticBackground