function y=ImportScenarioOutput(datfile)
% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, 2020-11-02 19:57:08 -0500
 

dat=importdata(datfile);
y.yrs=dat.data(1,:);
y.projs=dat.data(2:end,:);
textdat=dat.textdata(4:end,:);
for www=1:size(textdat,1)
    y.sitelab{www}=textdat{www,1};
    y.psmslid(www)=str2num(textdat{www,2});
    y.lat(www)=str2num(textdat{www,3});
    y.lon(www)=str2num(textdat{www,4});
    scenpair{www}=textdat{www,5};
    s=strfind(scenpair{www},' - ');
    y.scen(www)=str2num(scenpair{www}(1:(s-1)));
    y.lev{www}=scenpair{www}((s+3):end);
    if size(textdat,2)==6
        y.comp{www}=textdat{www,6};
    end
end
