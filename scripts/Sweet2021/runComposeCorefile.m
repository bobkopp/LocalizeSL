% Combine Sweet et al 2017 core file with Bamber et al 2019 ice sheets.
% 2020-10-28 09:38:34 -0400

savefilecore=fullfile(rootdir,'IFILES/SLRProjections161027GRIDDEDcore.mat');
p=load(savefilecore);

Tscens=0.6+[3.7 2.2 1.8 1.0]; % central temperatures to go with each of the RCP scenarios
Hweights=(max(Tscens,2)-2)/3; % what mixture of 2 C and 5C from Bamber et al 2019 to use for each


% import Bamber et al 2019 samples
savefilecore=fullfile(rootdir,'IFILES/SLRProjections190726core_SEJ_full.mat');
p1=load(savefilecore);
pH=p1.corefileH;
pL=p1.corefileL;

% map Bamber et al 2019 samples
permsdraw=round(randperm(size(p.samps,1))*size(pH.samps,1)/size(p.samps,1));
NL=round((1-Hweights)*size(p.samps,1));
pcomp=p;
colice=[p.colGIS p.colAIS];

for sss=1:length(Tscens)
    pcomp.samps(1:NL(sss),colice,:,sss)=pL.samps(permsdraw(1:NL(sss)),colice,1:size(pcomp.samps,3));
    if (size(p.samps,1)-NL(sss))>0
        pcomp.samps((NL(sss)+1):end,colice,:,sss)=pH.samps(permsdraw((NL(sss)+1):end),colice,1:size(pcomp.samps,3));
    end
end

% append the original S17 samples
Nsamps=size(p.samps,1);
pcomp.samps(Nsamps+[1:Nsamps],:,:,:)=p.samps;
pcomp.seeds(:,Nsamps+[1:Nsamps])=p.seeds;
