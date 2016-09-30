function ConditionalDistributionsPlotSeaLevel(p,condtargs,proj,projhi,projlo,projLOC,projLOChi,projLOClo,projrate,projratehi,projratelo,projLOCrate,projLOCratehi,projLOCratehi,filesuffix)

% ConditionalDistributionsPlotSeaLevel(p,condtargs,proj,projhi,projlo,projLOC,projLOChi,projLOClo,projrate,projratehi,projratelo,projLOCrate,projLOCratehi,projLOCratehi,filesuffix)
%
% Generate output plots and tables for conditional scenarios.
%
% INPUT
% -----
% p: core sea-level structure 
% condtargs: target heights (in mm) upon which conditioned
% proj: median GSL projection for each scenario
% projhi: high GSL projection for each scenario
% projlo: low GSL projection for each scenario
% projLOC: median LSL projection for each scenario
% projLOChi: high LSL projection for each scenario
% projLOClo: low LSL projection for each scenario
% projrate: median GSL rate projections for each scenario
% projratehi: high GSL rate projections for each scenario
% projratelo: low GSL rate projections for each scenario
% projLOCrate: median LSL rate projections for each scenario
% projLOCratehi: high LSL rate projections for each scenario
% projLOCratelo: low LSL rate projections for each scenario
% filesuffix: suffix to append to output files
%
% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, Fri Sep 30 08:28:58 EDT 2016
%%

defval('filesuffix','');

fid=fopen(['LocalScenarios' filesuffix '.tsv'],'w');

fprintf(fid,'Local scenarios (cm)\n');
today=date;
fprintf(fid,['Produced by Robert Kopp on ' today '\n\n']);
fprintf(fid,'Site\tID\tLatitude\tLongitude\tScenario\t2000');
fprintf(fid,'\t%0.0f',p.targyears);
fprintf(fid,'\n');

   for qqq=1:size(proj,1)
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - MED',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',proj(qqq,:)/10);
        fprintf(fid,'\n');
    
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - LOW',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',projlo(qqq,:)/10);
        fprintf(fid,'\n');
        
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - HIGH',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',projhi(qqq,:)/10);
        fprintf(fid,'\n');
    

    end

for www=1:length(p.targregions)
    selectedSite=p.targregions(www);
    % generate local samples

    for qqq=1:size(projLOC,1)
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - MED',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',projLOC(qqq,:,www)/10);
        fprintf(fid,'\n');
    
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - LOW',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',projLOClo(qqq,:,www)/10);
        fprintf(fid,'\n');
        
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - HIGH',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.0f',projLOChi(qqq,:,www)/10);
        fprintf(fid,'\n');
    

    end
    
end
fclose(fid);

%%%

doyear=2100;
dot=find(p.targyears==doyear);
for qqq=1:size(projLOC,1)
    clf;
    worldmap('North America');
    setm(gca,'parallellabel','off','meridianlabel','off','flinewidth',1);
    ax=gca;
    stateColor=[.8 .8 .8];
    geoshow('landareas.shp','facecolor',stateColor);
    u=(squeeze(projLOC(qqq,dot,:))-condtargs(1,qqq))/10;
    scatterm(p.targsitecoords(:,1),p.targsitecoords(:,2),10,u,'s','filled');

    pos0=get(gca,'position');
    hcb=colorbar('SouthOutside');

    ht=title(sprintf('Adder for %0.0f cm Scenario - %0.0f',[condtargs(1,qqq)/10 doyear]));
    colormap('parula');
    setm(gca,'mlinevisible','off','grid','off')
    crange=quantile(u,[.01 .99]);
    caxis(crange);
    pdfwrite(['LocalScenarioAdder' num2str(qqq) filesuffix]);    
    
    clf;
    worldmap('North America');
    setm(gca,'parallellabel','off','meridianlabel','off','flinewidth',1);
    ax=gca;
    stateColor=[.8 .8 .8];
    geoshow('landareas.shp','facecolor',stateColor);
    u=(squeeze(projLOClo(qqq,dot,:))-condtargs(1,qqq))/10;
    scatterm(p.targsitecoords(:,1),p.targsitecoords(:,2),10,u,'s','filled');

    pos0=get(gca,'position');
    hcb=colorbar('SouthOutside');

    ht=title(sprintf('Adder for %0.0f cm Scenario - %0.0f',[condtargs(1,qqq)/10 doyear]));
    colormap('parula');
    setm(gca,'mlinevisible','off','grid','off')
    caxis(crange);
    pdfwrite(['LocalScenarioAdderLow' num2str(qqq) filesuffix]);    
    
    clf;
    worldmap('North America');
    setm(gca,'parallellabel','off','meridianlabel','off','flinewidth',1);
    ax=gca;
    stateColor=[.8 .8 .8];
    geoshow('landareas.shp','facecolor',stateColor);
    u=(squeeze(projLOChi(qqq,dot,:))-condtargs(1,qqq))/10;
    scatterm(p.targsitecoords(:,1),p.targsitecoords(:,2),10,u,'s','filled');

    pos0=get(gca,'position');
    hcb=colorbar('SouthOutside');

    ht=title(sprintf('Adder for %0.0f cm Scenario - %0.0f',[condtargs(1,qqq)/10 doyear]));
    colormap('parula');
    setm(gca,'mlinevisible','off','grid','off')
    caxis(crange);
    pdfwrite(['LocalScenarioAdderHi' num2str(qqq) filesuffix]);    
    
end


%%%


fid=fopen(['LocalScenariosRates' filesuffix '.tsv'],'w');    

fprintf(fid,'Local scenarios (mm/yr)\n');
today=date;
fprintf(fid,['Produced by Robert Kopp on ' today '\n\n']);
fprintf(fid,'Site\tID\tLatitude\tLongitude\tScenario\t2000');
fprintf(fid,'\t%0.0f',targyearrates);
fprintf(fid,'\n');

   for qqq=1:size(proj,1)
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - MED',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projrate(qqq,:));
        fprintf(fid,'\n');
    
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - LOW',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projratelo(qqq,:));
        fprintf(fid,'\n');
        
        fprintf(fid,'GSL');
        fprintf(fid,'\t%0.0f',0);
        fprintf(fid,'\t%0.2f',[NaN NaN]);
        fprintf(fid,'\t%0.1f - HIGH',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projratehi(qqq,:));
        fprintf(fid,'\n');
    

    end

for www=1:length(p.targregions)
    selectedSite=p.targregions(www);
    % generate local samples

    for qqq=1:size(projLOC,1)
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - MED',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projLOCrate(qqq,:,www));
        fprintf(fid,'\n');
    
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - LOW',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projLOCratelo(qqq,:,www));
        fprintf(fid,'\n');
        
        fprintf(fid,p.targregionnames{www});
        fprintf(fid,'\t%0.0f',p.targregions(www));
        fprintf(fid,'\t%0.2f',p.targsitecoords(www,:));
        fprintf(fid,'\t%0.1f - HIGH',condtargs(1,qqq)/1000);
        fprintf(fid,'\t0');
        fprintf(fid,'\t%0.1f',projLOCratehi(qqq,:,www));
        fprintf(fid,'\n');
    

    end
    
end
fclose(fid);

