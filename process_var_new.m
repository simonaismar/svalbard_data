function [VARIABLE]=process_var_new(filename,depthname,varname,upperdepth,minpeakd,extrafilter,outname)

% 
% !!! example based on MPDACS temperature data !!!
% mpdacs180601141112_processed=process_var('mpdacs180601104750_read.mat','ctd305Depth','ctd305Temperature',4.5,-7,19,'function_processed')
% clear all; close all; clc
% filename='mpdacs180601104750_read.mat';
% depthname='ctd305Depth';
% varname='ctd305Temperature';
% upperdepth=2;
% minpeakd=-7;
% extrafilter=0; % or 0 to eliminate values out of median±2*std  
% outname='ctd305Temperature_mpdacs_180601104750';
% minpeakd  % upcast - minimum distance between upcast and downcast to filter out false peaks - the number 7 is particular to the MPDACS 180601
% outname   % to be appended to all the outputs of your function, i.e. .mat files and plots


%% Processing all data

% divide upcast and downcast
% extract only downcast, not disturbed by the instrument as the upcast would be
% average data points over one meter depth or over one second
% output processed matrix 

% load data
load(filename, depthname)
load(filename, varname)

% set to NaN superficial spiked values
tmp=eval(depthname);

% identify the beginning of the casts
tmp1=smooth(ctd305Depth);
tmp2=diff(tmp1)>0;
stats = regionprops(bwlabel(tmp2), 'Area', 'PixelIdxList');
% Find which runs have a length of at least
% 500;200;100;180 elements of monotonically increasing elements
monoup = find([stats.Area] >= 180);
start_casts=stats(monoup(1)).PixelIdxList(1);

start_value=upperdepth;
tmp(tmp<=start_value)=0; % if set to NaN it influences the index
tmp(1:start_casts)=0;
% round values to integers
% the function round rounds up to the closest integer for excess or for
% defect
depth_r=round(tmp);

clear tmp* monoup start_casts stats

% find index depth+1
dm=diff(depth_r); % different meter
ind_d=find(dm>0)+1; % indexes downcast (+1 because of the difference index)
ind_u=find(dm<0); % indexes upcast
clear dm
% replace 0 with NaN in depth r
depth_r(depth_r<=start_value)=NaN;
% build array with one value every meter
depth_p=depth_r(ind_d); % depth polished
depth_p1=depth_p;
% detect jump during downcast/upcast
for kk=1:length(ind_d)-2
if depth_p((kk)+1)- depth_p(kk)<=0 && depth_p((kk)+2)- depth_p(kk+1)<=0
% if you detect one lower value in depth in the middle of a downcast set that value to NaN
depth_p1((kk)+1)=NaN;
elseif depth_p((kk)+2) - depth_p((kk))==0
% if you detect two lower values in depth in the middle of a downcast set that value to NaN
depth_p1((kk)+2)=NaN;
elseif depth_p((kk)+1) - depth_p((kk))==0
depth_p1((kk)+1)=NaN;
end
end
clear kk

for kk=1:length(ind_d)-2
    % if you detect a value that is lower (shallower) that the current and deeper than the minimum peak allowed set it to NaN
if depth_p(kk+2)- depth_p(kk)<=0 && depth_p(kk+2)>=abs(minpeakd)
   depth_p1(kk+2)=NaN;
end
end
clear kk

%% plot process
cd redundant_plots
ah=figure;
set(ah,'PaperUnits','inches',...
'PaperOrientation','portrait',...
'Paperposition',[0.5 0.5 9.5 3],...
'PaperType','<custom>',...
'Position',[50 50 1200 500],'visible','off');

plot(eval(depthname))
hold on
plot(depth_r,'r') % one meter step and NaN close to the surface <4.5m depth
hold on
scatter(ind_d,depth_p,'g') % one value per meter (useful index for later) and check misinterpretation of downcast/upcast
plot(ind_d,depth_p1,'kd')
xlabel('Data Points')
ylabel('Depth')
set(gca,'fontweight','bold')
set(gcf, 'Position', get(0, 'Screensize'));
grid on
legend('original','1 meter step','only downcast','correction jumps')
plotname1=[outname,'_processing'];
set(gcf,'PaperPositionMode','auto')

print('-dpng','-r600',plotname1)
clear plotname1 depth_p

%% find start-end casts

% end downcasts:
pks=islocalmax(depth_p1);
max_d=[depth_p1(pks) ; depth_p1(end)];
loc_d=[ind_d(pks) ; ind_d(end)];

%start downcasts:
lows=islocalmax(-depth_p1);
max_u=[depth_p1(2) ; depth_p1(lows)];
loc_u=[ind_d(2) ; ind_d(lows)];

depth_u=depth_r(ind_u);
pksu=islocalmax(depth_u);
start_u=[depth_u(1) ; depth_u(pksu)];
istart_u=[ind_u(1) ; ind_u(pksu)];


%% plot check
ah=figure;
set(ah,'PaperUnits','inches',...
'PaperOrientation','portrait',...
'Paperposition',[0.5 0.5 9.5 3],...
'PaperType','<custom>',...
'Position',[50 50 1200 500],'visible','off');
plot(eval(depthname))
hold on
plot(ind_d,depth_p1,'kd')
hold on
tmp1=scatter(loc_d,max_d,'k','filled');
hold on
tmp2=scatter(loc_u,max_u,'r','filled');
hold on
tmp3=scatter(istart_u,start_u,'g','filled');
grid on
set(gca,'fontweight','bold')
set(gcf, 'Position', get(0, 'Screensize'));
legend([tmp1 tmp2 tmp3],'local maxima','local minima upcast','local minima downcast')
xlabel('Data Points')
ylabel('Depth')
title('Average Steps')
plotname1=[outname,'_check'];
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r600',plotname1)
clear plotname1 ah
cd ..
%% treat variable
%rename and remap on the variable on the depth
temp_r=eval(varname);temp_r(isnan(depth_r))=NaN;
temp_p=depth_p1*NaN;

% average values within the same metertestind=ismember(ind_d,loc_d);
testind=ismember(ind_d,loc_d);

for ii=1:length(ind_d)-1
   if ismember(ind_d(ii),ind_d(testind))
      ibb=find(ind_d(ii)==loc_d);
      bb(ii)=istart_u(ibb);
      aa(ii)=ind_d(ii);
      temp_p(ii)=median(temp_r(aa(ii):bb(ii)),'omitnan');

   else
    aa(ii)=ind_d(ii);
    bb(ii)=ind_d(ii+1)-1;
    temp_p(ii)=median(temp_r(aa(ii):bb(ii)),'omitnan');
   end
   
end
clear cng ii aa bb

% last value 
temp_p(length(ind_d))=median(temp_r(ind_d(end):istart_u(end)),'omitnan');

%% create matrix with every cast n(depth)x m(number of casts)

% index start downcast %loc_u
sd=find(lows==1);sd=[2; sd];
% index end downcast %loc_d
ed=find(pks==1); ed=[ed; length(depth_p1)];

% dimension matrix
max_dim=max(ed-sd)+1;
num_stations=length(loc_d);
size_stat=(ed-sd);size_stat=[ed(1)-1; size_stat];
DEPTH=NaN([max_dim num_stations]);
VARIABLE=NaN([max_dim num_stations]);

%initialise
kk=1;
    DEPTH(1:size_stat(kk),kk)=depth_p1(sd(kk):ed(kk));
    VARIABLE(1:size_stat(kk),kk)=temp_p(sd(kk):ed(kk));
    
for kk=2:num_stations
    
    DEPTH(1:(ed(kk)-sd(kk))+1,kk)=depth_p1(sd(kk):ed(kk));
    VARIABLE(1:(ed(kk)-sd(kk))+1,kk)=temp_p(sd(kk):ed(kk));
    
end
clear max_dim 

if extrafilter==1
% remove the last outliers still outside of the current mean+2std
mm=mean(median(VARIABLE,'omitnan'));
ss=mean(std(VARIABLE,'omitnan'));
i1=find(VARIABLE<=mm-2*ss);
i2=find(VARIABLE>=mm+2*ss);
VARIABLE(i1)=NaN;
VARIABLE(i2)=NaN;

clearvars mm ss i1 i2
end

%% Final plot 
cd final_plots

ah=figure;
set(ah,'PaperUnits','inches',...
'PaperOrientation','portrait',...
'Paperposition',[0.5 0.5 9.5 3],...
'PaperType','<custom>',...
'Position',[50 50 1200 500],'visible','off');

bounds = [0,1]; 
x = rand(num_stations,3) * range(bounds) + bounds(1);    % for decimals

%filtered data
for kk=1:num_stations
plot(VARIABLE(:,kk),DEPTH(:,kk))
hold on
s1=scatter(VARIABLE(:,kk),DEPTH(:,kk),[60],x(kk,:),'filled','markeredgecolor','k');
hold on
end  
axis ij
set(gcf, 'Position', get(0, 'Screensize'));
grid on
ylabel('Depth (m)')
xlabel(varname)
title1=[varname,' vs Depth'];
title(title1)
set(gca,'fontweight','bold')
set(gcf, 'Position', get(0, 'Screensize'));
plotname0=[outname,'_finaldata'];
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r600',plotname0)
hold on 
% original data
p1=plot(eval(varname),eval(depthname));    
legend([s1 p1],'processed data','original data')
plotname1=[outname,'_comparison'];
set(gcf,'PaperPositionMode','auto')
print('-dpng','-r600',plotname1)
clear plotname1 ah

 % rename variable
 final_name=[(varname),'_processed'];
 eval([final_name '= ' 'VARIABLE']);
 
clearvars -except DEPTH VARIABLE outname loc_u max_u
cd ..
cd redundant_data
save(outname)
cd ..