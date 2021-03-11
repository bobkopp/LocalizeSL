% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-11-02 20:32:57 -0500

% This script is identical to runSeaLevelConditionalDistributions, except that it
% turns off the correlation between thermal expansion and ocean dynamics.
% It's used in Sweet et al. 2017 for the Low scenario.

% turn off correlation of TE and OD
p.OceanDynTECorr=p.OceanDynTECorr*0;
condtargs1=condtargs(:,1);

disp('Conditionalizing GSL...');
[projGSL,condsubscen]=ConditionalDistributionsGSL(p,condtargyrs,condtargs1,condtargwins);

% only do condsubscen(1)

disp('Conditionalizing LSL...');
projLOC=ConditionalDistributionsLSL(p,condsubscen,[],[],1);

% now output

fid=fopen('conditionalScenariosN.tsv','w'); fprintf(fid,'scenario\tN\n');
for ppp=1:length(condsubscen)
    fprintf(fid,'%0.0f',ppp);
    fprintf(fid,'\t%0.0f',length(condsubscen{ppp}));
    fprintf(fid,'\n');
end
fclose(fid);

crange0=[-80 80];
cmap=brewermap(16,'RdYlBu');
cmap=cmap(end:-1:1,:);

subrateyrs=find(projGSL.targyearrates<2100);



filesuffix='';
ConditionalDistributionsPlotSeaLevel(p,condtargs1,projGSL.proj,projGSL.projhi,projGSL.projlo,projLOC.projLOC,projLOC.projLOChi,projLOC.projLOClo,projGSL.targyearrates(subrateyrs),projGSL.projrate(:,subrateyrs),projGSL.projratehi(:,subrateyrs),projGSL.projratelo(:,subrateyrs),projLOC.projLOCrate(:,subrateyrs,:),projLOC.projLOCratehi(:,subrateyrs,:),projLOC.projLOCratelo(:,subrateyrs,:),filesuffix,crange0,cmap);

filesuffix='-NoBkgd';
ConditionalDistributionsPlotSeaLevel(p,condtargs1,projGSL.proj,projGSL.projhi,projGSL.projlo,projLOC.projLOC0,projLOC.projLOC0hi,projLOC.projLOC0lo,projGSL.targyearrates(subrateyrs),projGSL.projrate(:,subrateyrs),projGSL.projratehi(:,subrateyrs),projGSL.projratelo(:,subrateyrs),projLOC.projLOC0rate(:,subrateyrs,:),projLOC.projLOC0ratehi(:,subrateyrs,:),projLOC.projLOC0ratelo(:,subrateyrs,:),filesuffix,crange0,cmap);

filesuffix='';

ConditionalDistributionsPlotGSLComponents(p,condtargs1,projGSL.proj,projGSL.projhi,projGSL.projlo,projGSL.projCONT,projGSL.projCONThi,projGSL.projCONTlo,projGSL.colsCONT,projGSL.colsCONTlab);
   
ConditionalDistributionsPlotSeaLevelComponents(p,condtargs1,projLOC.projLOC,projLOC.projLOChi,projLOC.projLOClo,projLOC.projLOCcomp,projLOC.projLOCcomphi,projLOC.projLOCcomplo,projLOC.colsCOMP,projLOC.colsCOMPlab,filesuffix);
