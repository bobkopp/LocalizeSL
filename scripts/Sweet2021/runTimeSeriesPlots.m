% 2020-09-02 10:10:38 -0400

datdir='workdir-200917';
scenimport=ImportScenarioOutput(fullfile(datdir,'LocalScenarios-Climatic.tsv'));
sub=find(scenimport.psmslid==0);
NCA4.t=[2000	2010	2020	2030	2040	2050	2060	2070	2080	2090	2100	2120	2150	2200];
NCA4.sl=[
    0	3	6	9	13	16	19	22	25	28	30	34	37	39
    0	4	8	13	18	24	29	35	40	45	50	60	73	95
    0	4	10	16	25	34	45	57	71	85	100	129	182	283
    0	5	10	19	30	44	60	79	100	124	149	203	305	511
    0	5	11	21	36	54	77	103	132	165	201	282	434	748
    0	4	11	24	41	63	90	123	161	203	250	357	554	972
];

yrs=scenimport.yrs;
projs=scenimport.projs(sub,:);
lev=scenimport.lev(sub);

projs=bsxfun(@minus,projs,projs(:,2))+3;

subM=find(strcmp(lev,'MED'));
subH=find(strcmp(lev,'HIGH'));
subL=find(strcmp(lev,'LOW'));
colrs='cmkgbr';

clf;
subplot(2,1,1);
hold on;
for sss=1:size(NCA4.sl,1)
    plot(NCA4.t,NCA4.sl(sss,:),[colrs(sss) '-']);
end
xlim([2020 2150]);
ylim([0 250]);
ylabel('cm GMSL above 2000')
title('NCA4 GMSL scenarios')
pdfwrite('NCA4')

for sss=1:length(subM)
    hp=plot(yrs,projs(subM(sss),:),[colrs(sss) '-'],'linew',2);
end
xlim([2020 2150]);
ylim([0 250]);
title('with more realistic temporal structure')
ylabel('cm GMSL above 2000')
pdfwrite('NCA4-revised')

t2 = 2000:2100;
projsi=interp1(yrs,projs',t2)';


% diffs=projs(subH(1:5),:)-projs(subL(2:6),:);
% diffs2=projs(subH(1:4),:)-projs(subL(3:6),:);
% clear diffyr;
% for sss=1:size(diffs,1)
%     sub=find(diffs(sss,:)<0);
%     diffyr(sss)=sub(1);
% end
% for sss=1:size(diffs2,1)
%     sub=find(diffs2(sss,:)<0);
%     diffyr2(sss)=sub(1);
% end

diffs=projsi(subH(1:5),:)-projsi(subL(2:6),:);
diffs2=projsi(subH(1:4),:)-projsi(subL(3:6),:);
diffs3=projsi(subH(1:5),:)-projsi(subL(6),:);
clear diffyr;
for sss=1:size(diffs,1)
    sub=find(diffs(sss,:)<0);
    diffyr(sss)=sub(1);
end
for sss=1:size(diffs2,1)
    sub=find(diffs2(sss,:)<0);
    diffyr2(sss)=sub(1);
end
for sss=1:size(diffs3,1)
    sub=find(diffs3(sss,:)<0);
    diffyr3(sss)=sub(1);
end

clf;
subplot(2,1,1);
hold on;

xlim([2020 2100]);
ylim([0 250]);

for sss=1:length(diffyr)
    hp=plot(t2(diffyr(sss))*[1 1],projsi([subL(sss) subH(sss)],diffyr(sss)),[colrs(sss) '-'],'linew',8);
    set(hp,'Color',(get(hp,'Color')+[1 1 1])/2);
    hp=plot(t2(diffyr(sss))*[1 1],projsi([subL(sss+1) subH(sss+1)],diffyr(sss)),[colrs(sss+1) '-'],'linew',8);
    set(hp,'Color',(get(hp,'Color')+[1 1 1])/2);
end
% for sss=1:length(diffyr3)
%     hp=plot(t2(diffyr3(sss))*[1 1],projsi([subL(sss) subH(sss)],diffyr3(sss)),[colrs(sss) '-'],'linew',8);
%     set(hp,'Color',(get(hp,'Color')+[1 1 1])/2);
%     hp=plot(t2(diffyr3(sss))*[1 1],projsi([subL(6) subH(6)],diffyr3(sss)),[colrs(6) '-'],'linew',8);
%     set(hp,'Color',(get(hp,'Color')+[1 1 1])/2);
% end

for sss=1:length(subM)
    hp=plot(yrs,projs(subM(sss),:),[colrs(sss) '-'],'linew',1);
end
hp=plot(yrs,projs(subL(6),:),[colrs(6) ':'],'linew',1);
title('with gates')
ylabel('cm GMSL above 2000')
pdfwrite('NCA4-revised-gates')

dat=importdata('IFILES/GMSL_TPJAOS_4.2_199209_202004.txt',' ',50);
altim.t=dat.data(:,3);
altim.y=dat.data(:,12);
sub=find(abs(altim.t-2000)<=abs(altim.t(1)-2000));
altim.y=(altim.y-mean(altim.y(sub)))/10;
plot(altim.t,altim.y,'m');

altimt2=[1994:2:2020]';
A = [altimt2.^2  altimt2 altimt2.^0]; 
[x,stdx,mse,s]=lscov(A,interp1(altim.t,altim.y,altimt2));
A2 = [t2(:).^2 t2(:) t2(:).^0];
samps=mvnrnd(x,s,1000);
samps2=A2*samps';
samps2=bsxfun(@minus,samps2,samps2(1,:));
%
