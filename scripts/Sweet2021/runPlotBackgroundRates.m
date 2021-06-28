% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2019-09-04 16:57:03 +0200


% plot GIA rates

clf;
hm=worldmap('world');
setm(hm,'meridianlabel','off','parallellabel','off' );

scatterm(mod(targsitecoords(:,1),360),targsitecoords(:,2),10,rateprojs,'s','filled');
geoshow('landareas.shp','FaceColor',[.9 .9 .9]);

colorbar;
colormap(brewermap(24,'RdBu'));
caxis([-3 3]);
title('Mean background rate (mm/yr)');
sub=find(targregions<10000);
scatterm(mod(targsitecoords(sub,1),360),targsitecoords(sub,2),10,rateprojs(sub),'o','filled');
pdfwrite('bkgdrate_mean');

clf;
hm=worldmap('world');
setm(hm,'meridianlabel','off','parallellabel','off' );

scatterm(mod(targsitecoords(:,1),360),targsitecoords(:,2),10,rateprojssd,'s','filled');
geoshow('landareas.shp','FaceColor',[.9 .9 .9]);

colorbar;
colormap(brewermap(13,'OrRd'));
caxis([0 6.5]);
title('Background rate std. (mm/yr)');
sub=find(targregions<10000);
scatterm(mod(targsitecoords(sub,1),360),targsitecoords(sub,2),10,rateprojssd(sub),'o','filled');

pdfwrite('bkgdrate_std');

fid=fopen('bkgdrate.tsv','w');
fprintf(fid,'site\tID\tlat\tlong\tbkgd rate\tstd\n');
for iii=1:length(rateprojs)
    fprintf(fid,targregionnames{iii});
    fprintf(fid,'\t%0.0f',targregions(iii));
    fprintf(fid,'\t%0.2f',targsitecoords(iii,:));
    fprintf(fid,'\t%0.2f',[rateprojs(iii) rateprojssd(iii)]);
    fprintf(fid,'\n');
    
end

fclose(fid);
