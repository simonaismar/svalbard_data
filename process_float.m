function [VARIABLE]=process_float(filename,timename,varname,outname,nstd)
% remove outliers
% average data points over one meter depth or over one second
% output processed matrix 

% clear all; close all; clc
% filename='proteus18telem180601110524_read.mat';
% timename='TIME';
% varname='temperature'; 
% outname='temperature_proteus18telem180601110524';
% nstd=3 ;
% nstd % number of standard deviations to be taken into account when despiking;
% outname % to be appended to all the outputs of your function, i.e. .mat files and plots

%% Processing all data

% load data
load(filename, timename)
load(filename, varname)

% set to NaN superficial spiked values
tmp=eval(timename);
tmp2=eval(varname);

% remove outliers outside of the current mean+nstd*std
mm=(median(tmp2,'omitnan'));
ss=(std(tmp2,'omitnan'));
i1=find(tmp2<mm-nstd*ss);
i2=find(tmp2>mm+nstd*ss);
tmp2(i1)=NaN;
tmp2(i2)=NaN;
tmp3=movmean(tmp2,10,'omitnan');
VARIABLE=tmp3;
TIME=eval(timename);
original_data=eval(varname);
clearvars mm ss i1 i2 tmp*
%% plot data
cd final_plots
ah=figure;
set(ah,'visible','off');

s1=scatter(TIME,VARIABLE,'filled');
% if max(VARIABLE)>min(VARIABLE)
% ylim([min(VARIABLE) max(VARIABLE)])
% end
set(gcf, 'Position', get(0, 'Screensize'));
grid on
xlabel('Time (MM:SS)')
ylabel(varname)
title1=[varname,' over Time'];
title(title1)
set(gca,'fontweight','bold')
set(gcf, 'Position', get(0, 'Screensize'));
xt=get(gca,'xtick');
xtl=datestr(xt,'MM:SS');
set(gca,'xticklabel',[]);
set(gca,'xticklabel',xtl);
plotname0=[outname,'_finaldata'];
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r600',plotname0)
hold on
p1=plot(TIME,original_data,'linewidth',2);
legend([s1 p1],'processed','original','location','best')
plotname1=[outname,'_comparison'];
print('-dpng','-r600',plotname1)

clearvars -except TIME VARIABLE outname
cd ..
cd redundant_data
save(outname)
cd ..
