%% Process Main Variables
% in mpdacs_example_data.mat
% input - mpdacs_example_data_read.mat.mat
% output - processed variables and plots

% logDate             col# 1  date
% logTime             col# 2  
% logNanoSeconds      col# 3  
% turbidity           col# 4  
% fluorescence        col# 5  
% arlocTime           col# 6  
% arlocChlA1          col# 7  
% arlocChlA2          col# 8  
% arlocDepth          col# 9  % ArlocDepth not working properly
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

clear 
close all
clc

mkdir redundant_plots
mkdir final_plots
mkdir redundant_data 

%function [VARIABLE]=process_var_new(filename,depthname,varname,upperdepth,minpeakd,extrafilter,outname)
[temperature_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305Temperature',2,-7,0,'ctd305Temperature_mpdacs_example');
close all
[fluorescence_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','fluorescence',2,-7,0,'fluorescence_mpdacs_example');
close all
[conductivity_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305Conductivity',2,-7,0,'ctd305Conductivity_mpdacs_example');
close all
[salinity_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305Salinity',2,-7,0,'ctd305Salinity_mpdacs_example');
close all
[ctd305O2Percent_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305O2Percent',2,-7,0,'ctd305O2Percent_mpdacs_example');
close all
[ctd305O2Ppm_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305O2Ppm',2,-7,0,'ctd305O2Ppm_mpdacs_example');
close all
[ctd305pH_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305pH',2,-7,0,'ctd305pH_mpdacs_example');
close all
[ctd305Eh_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','ctd305Eh',2,-7,0,'ctd305Eh_mpdacs_example');
close all

% arloc
[arlocTime_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','arlocChl_time',2,-7,0,'arlocTime_mpdacs_example');
close all
[arlocDepth_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','arlocDepth',2,-7,0,'arlocDepth_mpdacs_example');
close all
[arlocTemperature_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','arlocTemperature',2,-7,0,'arlocTemperature_mpdacs_example');
close all
[arlocXIncl_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','arlocXIncl',2,-7,0,'arlocXIncl_mpdacs_example');
close all
[arlocYIncl_processed]=process_var_new('mpdacs_example_data_read.mat','ctd305Depth','arlocYIncl',2,-7,0,'arlocYIncl_mpdacs_example');
close all

save DATA_MPDACS_example


%% extra plot to visualise arloc location
if 0
load('DATA_MPDACS_example.mat', 'arlocXIncl_processed')
load('DATA_MPDACS_examples.mat', 'arlocYIncl_processed')
load('mpdacs_example_data_read.mat', 'arlocXIncl')
load('mpdacs_example_data_read.mat', 'arlocYIncl')

oo=scatter(arlocXIncl,arlocYIncl,40,'markeredgecolor','r');
hold on
for kk=1:7
pp=scatter(arlocarlocXIncl_processed(:,kk),arlocarlocYIncl_processed(:,kk),50,'filled','markeredgecolor','b');
hold on
end
xlabel('ARLOC LOC X')
ylabel('ARLOC LOC Y')
set(gca,'FontSize',14)
set(gca,'fontweight','bold')
grid on
legend([oo pp],'original','processed')
print('-dpng','-r600','arloc_location_processedvsoriginal.png')
axis([320 880 405 675])
print('-dpng','-r600','arloc_location_processedvsoriginal_zoom.png')
end