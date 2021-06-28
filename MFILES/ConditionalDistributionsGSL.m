function [projections,condsubscen,pooledGSL,pooledGSLcont,pooledGSLrate]=ConditionalDistributionsGSL(p,condtargyrs,condtargs,condtargwins,substitutep,qvals,doscens)

% [projections,condsubscen]=GSLConditionalDistributions(p,condtargyrs,condtargs,condtargwins,substitutep,qvals)
%
% Generate global sea-level scenarios by conditionalizing probabilistic projections.
%
% INPUT
% -----
% p: core sea-level structure 
% condtargyrs: years on which to condition GSL
% condtargs: target heights (in mm) upon which to condition;
%            rows correpsond to years and columns to targets
% condtargwins: tolerance (in mm) for deviation from condtargs;
%               same dimensions as condtargs
% substitutep: subtitutions to make in p
% doscens: scenarios to use in core structure (default: [1 3 4])
%
% OUTPUT
% ------
% projections: structure with projection output
% condsubscen: cell array of sets of sample indices for each scenario
%
% Fields of projections structure
% -------------------------------
% proj: median GSL projection for each scenario
% projhi: high GSL projection for each scenario
% projlo: low GSL projection for each scenario
% targyearrates: years for rates
% projrate: median rate projections for each scenario
% projratehi: high rate projections for each scenario
% projratelo: low rate projections for each scenario
% projCONT: median contribution projections for each scenario
% projCONThi: high contribution projections for each scenario
% projCONTlo: low contribution projections for each scenario
% colsCONT: columns of core files used for contribution breakdown
% colsCONTlab: labels for contribution breakdown
%
% Developed for Sweet et al. (2017).
%
% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-11-02 20:30:01 -0500

defval('condtargyrs',[2100 2050 2030]);
defval('condtargs',[30 50 100 150 200 250 ;
           15 NaN NaN NaN NaN NaN ;
           9 NaN NaN NaN NaN NaN] * 10);
defval('condtargwins',[20 20 20 20 50 50 ;
              10 10 10 10 10 10 ;
              5 5 5 5 5 5]);
defval('difftimestep',20);
defval('substitutep',[]);
if length(substitutep)==0
    substitutep.filler=0;
end
defval('qvals',[.5 .167 .833])
defval('doscens',[1 3 4])


%%%%

[sampsGSLrise,sampsGSLcomponents,siteidsGSL,sitenamesGSL,targyearsGSL,scensGSL,colsGSL] = LocalizeStoredProjections(0,p,doscens,substitutep);
[sampsdGSLrise,targyearGSLrates]=SampleSLRates(sampsGSLrise,targyearsGSL,difftimestep);

targyears=targyearsGSL; targyearrates=targyearGSLrates;

pooledGSL=[sampsGSLrise{1}];
pooledGSLcont=[sampsGSLcomponents{1}];
pooledGSLrate=[sampsdGSLrise{1}];

for ssss=2:length(sampsGSLrise)
    pooledGSL=[pooledGSL; sampsGSLrise{ssss}];
    pooledGSLcont=[pooledGSLcont ; sampsGSLcomponents{ssss}];
    pooledGSLrate=[pooledGSLrate ; sampsdGSLrise{ssss}];
end

%%%%%

colsCONT={colsGSL.colGIC,colsGSL.colTE,colsGSL.colGIS,colsGSL.colAIS,colsGSL.colLS,colsGSL.colAIS(1),colsGSL.colAIS(2),union(colsGSL.colAIS,colsGSL.colGIS)};
colsCONTlab={'GIC','TE','GIS','AIS','LS','WAIS','EAIS','TotalIS'};
projections.colsCONT=colsCONT; projections.colsCONTlab=colsCONTlab;

clear condsubscen;
for qqq=1:size(condtargs,2)
    sub=1:size(pooledGSL,1);
    for rrr=1:length(condtargyrs)
       if ~isnan(condtargs(rrr,qqq)) sub=intersect(sub,find(abs(pooledGSL(:,find(targyears==condtargyrs(rrr)))-condtargs(rrr,qqq))<condtargwins(rrr,qqq)));
       end
       
    end
    
 
    condsubscen{qqq}=sub;
     projections.proj(qqq,:)=quantile(pooledGSL(sub,:),qvals(1));
     projections.projhi(qqq,:)=quantile(pooledGSL(sub,:),qvals(3));
     projections.projlo(qqq,:)=quantile(pooledGSL(sub,:),qvals(2));
     projections.projrate(qqq,:)=quantile(pooledGSLrate(sub,:),qvals(1));
     projections.projratehi(qqq,:)=quantile(pooledGSLrate(sub,:),qvals(3));
     projections.projratelo(qqq,:)=quantile(pooledGSLrate(sub,:),qvals(2));
     for www=1:length(colsCONT)
         clear w; w{1}=squeeze(sum(pooledGSLcont(sub,colsCONT{www},:),2));
         [sampsdCONT]=SampleSLRates(w,targyearsGSL,difftimestep);
         projections.projCONT(qqq,:,www)=quantile(w{1},qvals(1));
         projections.projCONThi(qqq,:,www)=quantile(w{1},qvals(3));
         projections.projCONTlo(qqq,:,www)=quantile(w{1},qvals(2));
     end     
end

projections.targyears=targyears;
projections.targyearrates=targyearrates';