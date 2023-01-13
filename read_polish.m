
%% read proteus telemetry
% columns
%  1 date and time
%  2 vehicle time in ms
%  3 digital I/O 0
%  4 digital I/O 1
%  5 digital I/O 2
%  6 digital I/O 3
%  7 digital I/O 4
%  8 digital I/O 5
%  9 yaw
% 10 pitch
% 11 roll
% 12 latitude
% 13 longitude
% 14 speed
% 15 HRL Vref
% 16 HRR Vref
% 17 VRC Vref
% 18 VFC Vref
% 19 HFC Vref
% 20 HRL Speed
% 21 HRR Speed
% 22 VRC Speed
% 23 VFC Speed
% 24 HFC Speed
% 25 battery voltage
% 26 internal temperature
% 27 CTD type
% 28 CTD conductivity
% 29 CTD temperature
% 30 CTD depth
% 31 CTD salinity
% 32 CTD O2 percent
% 33 CTD O2 ppm
% 34 CTD Ph
% 35 CTD Eh
% 36 echosounder range 1
% 37 echosounder range 2
% 38 angle percentage reference
% 39 surge percentage reference
% 40 heave percentage reference
% 41 yaw reference
% 42 depth reference
% 43 altitude reference
% 44 yaw Kp
% 45 yaw Ki
% 46 yaw Kd
% 47 depth Kp
% 48 depth Ki
% 49 depth Kd
% 50 altitude Kp
% 51 altitude Ki
% 52 altitude Kd
% 53 control mode
% 54 depth and altitude control mode
% 55 vehicle type
% 56 keep position flag
% 57 hyper time
% 58 hyper latitude
% 59 hyper longitude
% 60 hyper yaw
% 61 hyper pitch
% 62 hyper roll


clear;
close all;
clc

load proteus18telem180601110524.mat
% time
time      = cell2mat(table2cell(proteus18telem180601110524(:,1)));
latitude  = cell2mat(table2cell(proteus18telem180601110524(:,12)));
longitude = cell2mat(table2cell(proteus18telem180601110524(:,13)));

time=datetime(time(:), 'convertfrom','posixtime');

% the machine time as an increase of 0.1 second every data point, so 
% we add that increment to the data

% delta time converted from milliseconds to seconds
dx=0.001*diff(cell2mat(table2cell(proteus18telem180601110524(:,2)))); 
% express time to isolate the seconds column
timevec=datevec(time);
% create an increasing vector using the delta dx
startx=timevec(1,6); N=length(timevec);new_sec=startx+(0:N-1)*dx(1);
% substitute colum seconds with increasing vector

timevec(:,6)=new_sec';
TIME=datenum(timevec);
clear dx timevec startx N new_sec time

mkdir rawplots
cd rawplots
% plot proteus path
bh=figure;
set(bh,'visible','off')
scatter(longitude,latitude,70,TIME,'filled')%,'markeredgecolor','k')
grid on
cx=colorbar;
clt=get(cx,'ticks');
c_label=datestr(clt,'MM:SS');
set(cx,'yticklabel',c_label);
cx.Label.String='Time (MM:SS)';
xlabel('Longitude','fontsize',14,'fontweight','bold');
ylabel('Latitude','fontsize',14,'fontweight','bold');
set(gca,'fontweight','bold')
set(gca,'fontsize',14)
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'PaperPositionMode','auto')
title('PROTEUS Path','fontsize',14,'fontweight','bold');
print('-dpng','-r600','proteus_path')
clearvars c_label clt cx

% 28 CTD conductivity
conductivity = cell2mat(table2cell(proteus18telem180601110524(:,28)));
plot_proteus(TIME,conductivity,'Conductivity','raw_conductivity_proteus');
% figure;
% plot(TIME,conductivity)
% xlabel('Time','fontsize',14,'fontweight','bold');
% ylabel('Conductivity','fontsize',14,'fontweight','bold');
% set(gcf, 'Position', get(0, 'Screensize'));
% xt=get(gca,'xtick');
% xtl=datestr(xt,'hh:MM:SS');
% set(gca,'xticklabel',[]);
% set(gca,'xticklabel',xtl);
% set(gcf,'PaperPositionMode','auto')
% set(gca,'fontsize',14)
% set(gca,'fontweight','bold')
% print('-dpng','-r600','proteus_path')
%% platform data
yaw = cell2mat(table2cell(proteus18telem180601110524(:,9)));    % 9 yaw
pitch = cell2mat(table2cell(proteus18telem180601110524(:,10))); % 10 pitch
roll = cell2mat(table2cell(proteus18telem180601110524(:,11)));  % 11 roll
battery_voltage = cell2mat(table2cell(proteus18telem180601110524(:,25)));  % 25 battery voltage
internal_temperature = cell2mat(table2cell(proteus18telem180601110524(:,26)));  % 26 internal temperature

%% ctd data
% 29 CTD temperature
temperature = cell2mat(table2cell(proteus18telem180601110524(:,29)));
plot_proteus(TIME,temperature,'Temperature','raw_temperature_proteus');
% 30 CTD depth
depth = cell2mat(table2cell(proteus18telem180601110524(:,30)));
plot_proteus(TIME,depth,'Depth','raw_depth_proteus');
% 31 CTD salinity
salinity = cell2mat(table2cell(proteus18telem180601110524(:,31)));
plot_proteus(TIME,salinity,'Salinity','raw_salinity_proteus');
% 32 CTD O2 percent
O2percent = cell2mat(table2cell(proteus18telem180601110524(:,32)));
plot_proteus(TIME,O2percent,'O2 percent','raw_O2percent_proteus');
% 33 CTD O2 ppm
O2ppm = cell2mat(table2cell(proteus18telem180601110524(:,33)));
plot_proteus(TIME,O2ppm,'O2 ppm','raw_O2ppm_proteus');
% 34 CTD Ph
Ph = cell2mat(table2cell(proteus18telem180601110524(:,34)));
plot_proteus(TIME,Ph,'Ph','raw_ph_proteus');
% 35 CTD Eh
Eh = cell2mat(table2cell(proteus18telem180601110524(:,35)));
plot_proteus(TIME,Eh,'Eh','raw_Eh_proteus');
cd ..
clearvars bh
save proteus18telem180601110524_read

close all; clear ; clc
%function [VARIABLE]=process_float(filename,timename,varname,outname)
mkdir redundant_data
mkdir final_plots
[TEMP]=process_float('proteus18telem180601110524_read.mat','TIME','conductivity','COND_PROC',1);
[COND]=process_float('proteus18telem180601110524_read.mat','TIME','temperature','TEMP_PROC',3);
[DEPTH]=process_float('proteus18telem180601110524_read.mat','TIME','depth','DEPTH_PROC',3);
[SAL]=process_float('proteus18telem180601110524_read.mat','TIME','salinity','SAL_PROC',3);
[O2PERCENT]=process_float('proteus18telem180601110524_read.mat','TIME','O2percent','O2PERCENT_PROC',3);
[O2PPM]=process_float('proteus18telem180601110524_read.mat','TIME','O2ppm','O2PPM_PROC',3);
[PH]=process_float('proteus18telem180601110524_read.mat','TIME','Ph','PH_PROC',3);
[EH]=process_float('proteus18telem180601110524_read.mat','TIME','Eh','EH_PROC',3);

%% extra platform variables
[YAW] = process_float('proteus18telem180601110524_read.mat','TIME','yaw','YAW_PROC',3);   % 9 yaw
[PITCH] = process_float('proteus18telem180601110524_read.mat','TIME','pitch','PITCH_PROC',3); % 10 pitch
[ROLL] = process_float('proteus18telem180601110524_read.mat','TIME','roll','ROLL_PROC',3);  % 11 roll
[BATTERY_VOLTAGE] = process_float('proteus18telem180601110524_read.mat','TIME','battery_voltage','BATTERY_VOLTAGE_PROC',3); % 25 battery voltage
[INTERNAL_TEMPERATURE] = process_float('proteus18telem180601110524_read.mat','TIME','internal_temperature','INTERNAL_TEMPERATURE_PROC',3);  % 26 internal temperature

load('proteus18telem180601110524_read.mat', 'TIME')

save proteus18telem180601110524_processed


