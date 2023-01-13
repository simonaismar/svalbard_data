
%% read mpdacs data 
% MPDACS (Multi-Purpose Data Acquisition Control System)
% raw data "mpdacs-180601-104750.log" --> "mpdacs180601104750.mat"
% important: import data with space delimeter not fixed width
% output: mpdacs180601104750_read & raw plots
% columns headers are:
% logDate             col# 1  
% logTime             col# 2  
% logNanoSeconds      col# 3  
% turbidity           col# 4  
% fluorescence        col# 5  
% arlocTime           col# 6  
% arlocChlA1          col# 7  
% arlocChlA2          col# 8  
% arlocDepth          col# 9  
% arlocTemperature    col# 10 
% arlocXIncl          col# 11
% arlocYIncl          col# 12
% arlocZAcc           col# 13
% arlocGyro           col# 14
% arlocBattery        col# 15
% ctd305Conductivity  col# 16  
% ctd305Temperature   col# 17  
% ctd305Depth         col# 18  
% ctd305Salinity      col# 19  
% ctd305O2Percent     col# 20  
% ctd305O2Ppm         col# 21  
% ctd305O2Ph          col# 22  
% ctd305O2Eh          col# 23  

clear;
close all;
clc

% load data
% save 18601140141_telem_raw
load('mpdacs180601104750.mat')

% time
dd=table2array(mpdacs180601104750(:,1));
hhmm=table2array(mpdacs180601104750(:,2));
nanosec=table2array(mpdacs180601104750(:,3)); 
% here I left out the nanoseconds for the moment as matlab does not seem to
% be able to convert them
tmp=cat(2,dd,hhmm);

for kk=1:length(tmp)
tmp1=mat2str(tmp(kk,:));
vec1(kk,:)=datevec(tmp1(2:7),'yymmdd');
vec1(kk,4)=str2num(tmp1(9:10));
vec1(kk,5)=str2num(tmp1(11:12));
vec1(kk,6)=str2num(tmp1(13:14))+(nanosec(kk)/(10^9));
%timenum(kk,1)=datenum(tmp1(2:7),'yymmdd')+datenum(tmp1(9:14),'hhmmss');
clear tmp1
end

clear kk
timenum=datenum(vec1); % no fraction of seconds
%timenum2=datenum(vec1)+nanosec/(10^12); % complete - with fraction of seconds


% parameters 
turbidity=table2array(mpdacs180601104750(:,4));
fluorescence=table2array(mpdacs180601104750(:,5));

arlocChl_time=table2array(mpdacs180601104750(:,6));
arlocChlA1=table2array(mpdacs180601104750(:,7));
arlocChlA2=table2array(mpdacs180601104750(:,8));
arlocDepth=table2array(mpdacs180601104750(:,9));
arlocTemperature=table2array(mpdacs180601104750(:,10));

arlocXIncl=table2array(mpdacs180601104750(:,11));         %col# 11
arlocYIncl=table2array(mpdacs180601104750(:,12));         %col# 12
arlocZAcc=table2array(mpdacs180601104750(:,13));          %col# 13
arlocGyro=table2array(mpdacs180601104750(:,14));          %col# 14
arlocBattery=table2array(mpdacs180601104750(:,15));       %col# 15

ctd305Conductivity=table2array(mpdacs180601104750(:,16));
ctd305Temperature=table2array(mpdacs180601104750(:,17));
ctd305Depth=table2array(mpdacs180601104750(:,18));
ctd305Salinity=table2array(mpdacs180601104750(:,19));
ctd305O2Percent=table2array(mpdacs180601104750(:,20)); % oxygen
ctd305O2Ppm=table2array(mpdacs180601104750(:,21)); % oxygen
ctd305pH=table2array(mpdacs180601104750(:,22));
ctd305Eh=table2array(mpdacs180601104750(:,23)); % redox

mkdir plots_mpdacs180601104750
cd plots_mpdacs180601104750
mkdir rawplots
cd rawplots

figure
plot(turbidity,ctd305Depth)
xlabel('Turbidity')
ylabel('Depth')
print('-dpng','-r600','Turbidity.png')

figure
plot(fluorescence,ctd305Depth)
xlabel('Fluorescence')
ylabel('Depth')
print('-dpng','-r600','Fluorescence.png')

figure
plot(arlocChlA1,ctd305Depth)
xlabel('Chlorophylle A1')
ylabel('Depth')
print('-dpng','-r600','arlocChlA1.png')

figure
plot(arlocChlA2,ctd305Depth)
xlabel('Chlorophylle A2')
ylabel('Depth')
print('-dpng','-r600','arlocChlA2.png')

figure
plot(arlocDepth)
xlabel('Arloc depth')
ylabel('Depth')
print('-dpng','-r600','arlocDepth.png')

figure
plot(arlocTemperature,ctd305Depth)
xlabel('Arloc temperature')
ylabel('Depth')
print('-dpng','-r600','arlocTemperature.png')

figure
plot(ctd305Conductivity,ctd305Depth)
xlabel('ctd305 Conductivity')
ylabel('Depth')
print('-dpng','-r600','ctd305Conductivity.png')

figure
plot(ctd305Depth)
xlabel('ctd305 Depth')
ylabel('Depth')
print('-dpng','-r600','ctd305Depth.png')

figure
plot(ctd305Temperature,ctd305Depth)
xlabel('ctd305 Temperature')
ylabel('Depth')
print('-dpng','-r600','ctd305Temperature.png')

figure
plot(ctd305Salinity,ctd305Depth)
xlabel('ctd305 Salinity')
ylabel('Depth')
print('-dpng','-r600','ctd305Salinity.png')

figure
plot(ctd305O2Percent,ctd305Depth)
xlabel('ctd305 O2 percent')
ylabel('Depth')
print('-dpng','-r600','ctd305O2Percent.png')

figure
plot(ctd305O2Ppm,ctd305Depth)
xlabel('ctd305 O2 Ppm')
ylabel('Depth')
print('-dpng','-r600','ctd305O2Ppm.png')

figure
plot(ctd305pH,ctd305Depth)
xlabel('ctd305 pH')
ylabel('Depth')
print('-dpng','-r600','ctd305pH.png')

figure
plot(ctd305Eh,ctd305Depth)
xlabel('ctd305 Eh')
ylabel('Depth')
print('-dpng','-r600','ctd305Eh.png')

close all
%hold on
%ylabel('[m]')
%xlabel('[s/10]')
%columns(data)
%t=1:length(arlocDepth);
%plot(arlocChlA2,'r')
%hold on
%grid on

clear ans vec1 tmp dd hhmm nanosec 

cd ..
cd ..
save  mpdacs180601104750_read
