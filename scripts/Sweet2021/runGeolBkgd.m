% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2019-09-03 21:31:40 +0200

%%% CONFIGURATION

addpath ~/Dropbox/Code/LocalizeSL

mypath='~/Dropbox/Code/ProjectSL/slr';
addpath(mypath,fullfile(mypath,'../lib/MFILES'),fullfile(mypath,'MFILES'),fullfile(mypath,'MFILES/scripts_griddedglobal'));
PARAMDIR=fullfile(mypath,'PARAMS/');
%IFILES=fullfile(mypath,'../IFILES/slr/');

%% PSMSL data
IFILESworking='~/Dropbox/Code/CESL-STEHM-GP/IFILES-working';
psmsldir=fullfile(IFILESworking,'rlr_annual');
addpath(psmsldir);
gslfile=fullfile(IFILESworking,'Dangendorf2019.txt');


rootdir='~/Dropbox/Code/LocalizeSL';
addpath(fullfile(rootdir,'MFILES'));

savefilecore=fullfile(rootdir,'IFILES/SLRProjections161027GRIDDEDcore.mat');
p=load(savefilecore);

targsitecoords=p.targsitecoords;
targregionnames=p.targregionnames;
targregions=p.targregions;


addpath(pwd)
workdir='workdir-210311';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);

% GIA (slow)
    [rateprojs,rateprojssd,rateprojs0,~,rateGIAproj,~,~,~,finescale]=CalculateBackgroundRates([],targsitecoords,[],[],PARAMDIR,IFILESworking,[],[],psmsldir,gslfile);
    runPlotBackgroundRates
