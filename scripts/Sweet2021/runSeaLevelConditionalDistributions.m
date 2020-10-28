% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-10-28 11:47:05 -0400

addpath(pwd)
workdir='workdir-201028';
if ~exist(workdir,'dir')
    mkdir(workdir)
end
cd(workdir);

disp('Conditionalizing GSL...');
[projGSL,condsubscen]=ConditionalDistributionsGSL(pcomp,condtargyrs,condtargs,condtargwins);

disp('Conditionalizing LSL...');
projLOC=ConditionalDistributionsLSL(pcomp,condsubscen);

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
ConditionalDistributionsPlotSeaLevel(p,condtargs,projGSL.proj,projGSL.projhi,projGSL.projlo,projLOC.projLOC,projLOC.projLOChi,projLOC.projLOClo,projGSL.targyearrates(subrateyrs),projGSL.projrate(:,subrateyrs),projGSL.projratehi(:,subrateyrs),projGSL.projratelo(:,subrateyrs),projLOC.projLOCrate(:,subrateyrs,:),projLOC.projLOCratehi(:,subrateyrs,:),projLOC.projLOCratelo(:,subrateyrs,:),filesuffix,crange0,cmap);

filesuffix='-NoBkgd';
ConditionalDistributionsPlotSeaLevel(p,condtargs,projGSL.proj,projGSL.projhi,projGSL.projlo,projLOC.projLOC0,projLOC.projLOC0hi,projLOC.projLOC0lo,projGSL.targyearrates(subrateyrs),projGSL.projrate(:,subrateyrs),projGSL.projratehi(:,subrateyrs),projGSL.projratelo(:,subrateyrs),projLOC.projLOC0rate(:,subrateyrs,:),projLOC.projLOC0ratehi(:,subrateyrs,:),projLOC.projLOC0ratelo(:,subrateyrs,:),filesuffix,crange0,cmap);

filesuffix='';

ConditionalDistributionsPlotGSLComponents(p,condtargs,projGSL.proj,projGSL.projhi,projGSL.projlo,projGSL.projCONT,projGSL.projCONThi,projGSL.projCONTlo,projGSL.colsCONT,projGSL.colsCONTlab);
   
ConditionalDistributionsPlotSeaLevelComponents(p,condtargs,projLOC.projLOC,projLOC.projLOChi,projLOC.projLOClo,projLOC.projLOCcomp,projLOC.projLOCcomphi,projLOC.projLOCcomplo,projLOC.colsCOMP,projLOC.colsCOMPlab,filesuffix,cmap);