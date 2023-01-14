close all
clc
%This code is used to generate signals of
%body temperature, heart rate (with corresponding ecg lead I and lead II),
%blood pressures(systolic and diastolic pressures), 
%respiratory rate (with corresponding respiratory pattern (resp)).

%ecg and resp are sampled at 500Hz, and the others are sampled at 1Hz.
%All of the signal is generated based on the normal distrbution and their
%base values. Body temperature is the only signal that its base value 
%depends on time.

%run the whold code can generate each signal of each state once 
%To generate more pieces for one state of one signal, please use run
%sections and change file names.
%%
%body temperature
%normal
load("body_temperature.mat") %base signal
bt_base=0;
bt_var=0.1;
%%
%abnormal high1
alter_bt=bt_base+bt_var*normrnd(0,0.3,[1,480]); %alter in minutes
bt_f=bt+alter_bt;
bt_t=1:1440*60;
bt_f=spline(bt_time,bt_f,bt_t); %upsampling
bt_f(14401:28800)=bt_f(14401:28800)+2.*hamming(14400)';
writematrix(bt_f(1:28800)',"temperature1_high.csv");
writematrix(bt_f(28801:28800*2)',"temperature2_normal.csv");
writematrix(bt_f(28800*2+1:28800*3)',"temperature3_normal1.csv");
%%
%abnormal high2
alter_bt=bt_base+bt_var*normrnd(0,0.3,[1,480]); %alter in minutes
bt_f=bt+alter_bt;
bt_t=1:1440*60;
bt_f=spline(bt_time,bt_f,bt_t); %upsampling
bt_f(28801:28800+14400)=bt_f(28801:28800+14400)+2.*hamming(14400)';
writematrix(bt_f(1:28800)',"temperature1_normal.csv");
writematrix(bt_f(28801:28800*2)',"temperature2_high.csv");
writematrix(bt_f(28800*2+1:28800*3)',"temperature3_normal2.csv");



%%
%heart rate adult
hrn_base=75;
hrh_base=120;
hrl_base=40;
hr_var=5;
load("ecg.mat");
%%
%normal
hr=hrn_base.*ones(1,200); %base
alter_hr=hr_var*normrnd(0,0.3,[1,200]); %alter
hr_b=hr+alter_hr;
hr_b=spline(10:10:2000,hr_b,1:2000);%hear rate for each beats
%train of delta
interval_hr=round(500*60./hr_b);
hr_t=cumsum(interval_hr);
train_hr=[];
for i=hr_t
    train_hr(i)=1;
end
train_hr=train_hr(1:(hr_t(end)-mod(hr_t(end),500)));
%heart rate in secondes
hr_f=spline(hr_t,hr_b,500:500:hr_t(end));
writematrix(hr_f',"heart_normal1.csv");
%ecg
ecg1_train=conv(train_hr,ecg1,"same");
ecg2_train=conv(train_hr,ecg2,"same");
writematrix(ecg1_train',"ecg1_normal1.csv");
writematrix(ecg2_train',"ecg2_normal2.csv");
%%
%abnormal high
hr=hrh_base.*ones(1,30); %base
alter_hr=hr_var*normrnd(0,0.3,[1,30]); %alter
hr_b=hr+alter_hr;
hr_b=spline(10:10:300,hr_b,1:300);
interval_hr=round(500*60./hr_b);
hr_t=cumsum(interval_hr);
train_hr=[];
for i=hr_t
    train_hr(i)=1;
end
train_hr=train_hr(1:(hr_t(end)-mod(hr_t(end),500)));
hr_f=spline(hr_t,hr_b,500:500:hr_t(end));
writematrix(hr_f',"heart_high.csv");
%ecg
ecg1_train=conv(train_hr,ecg1,"same");
ecg2_train=conv(train_hr,ecg2,"same");
writematrix(ecg1_train',"ecg1_high.csv");
writematrix(ecg2_train',"ecg2_high.csv");
%%
%abnormal low
hr=hrl_base.*ones(1,30); %base
alter_hr=hr_var*normrnd(0,0.3,[1,30]); %alter
hr_b=hr+alter_hr;
hr_b=spline(10:10:300,hr_b,1:300);
interval_hr=round(500*60./hr_b);
hr_t=cumsum(interval_hr);
train_hr=[];
for i=hr_t
    train_hr(i)=1;
end
train_hr=train_hr(1:(hr_t(end)-mod(hr_t(end),500)));
hr_f=spline(hr_t,hr_b,500:500:hr_t(end));
writematrix(hr_f',"heart_low.csv");
%ecg
ecg1_train=conv(train_hr,ecg1,"same");
ecg2_train=conv(train_hr,ecg2,"same");
writematrix(ecg1_train',"ecg1_low.csv");
writematrix(ecg2_train',"ecg2_low.csv");



%%
%blood pressure
sys_base=105;
dia_base=70;
sysh_base=150;
diah_base=95;
sysl_base=80;
dial_base=50;
bp_var=3;
%%
%systolic pressure
sys=sys_base.*ones(1,180); %base
sys_time=10:10:1800;
alter_sys=bp_var*normrnd(0,0.4,[1,180]); %alter
sys_f=sys+alter_sys;
sys_t=1:1800;
sys_f=spline(sys_time,sys_f,sys_t);
%diastolic pressure
dia=dia_base.*ones(1,180); %base
dia_time=10:10:1800;
alter_dia=bp_var*normrnd(0,0.4,[1,180]); %alter
dia_f=dia+alter_dia;
dia_t=1:1800;
dia_f=spline(dia_time,dia_f,dia_t);
%write files
writematrix(sys_f',"bloodhigh_normal1.csv");
writematrix(dia_f',"bloodlow_normal1.csv");
%%
%abnormal high
%systolic pressure
sys=sysh_base.*ones(1,30); %base
sys_time=10:10:300;
alter_sys=bp_var*normrnd(0,0.4,[1,30]); %alter
sys_f=sys+alter_sys;
sys_t=1:300;
sys_f=spline(sys_time,sys_f,sys_t);
%diastolic pressure
dia=diah_base.*ones(1,30); %base
dia_time=10:10:300;
alter_dia=bp_var*normrnd(0,0.4,[1,30]); %alter
dia_f=dia+alter_dia;
dia_t=1:300;
dia_f=spline(dia_time,dia_f,dia_t);
%write files
writematrix(sys_f',"bloodhigh_high.csv");
writematrix(dia_f',"bloodlow_high.csv");
%%
%abnormal low
%systolic pressure
sys=sysl_base.*ones(1,30); %base
sys_time=10:10:300;
alter_sys=bp_var*normrnd(0,0.4,[1,30]); %alter
sys_f=sys+alter_sys;
sys_t=1:300;
sys_f=spline(sys_time,sys_f,sys_t);
%diastolic pressure
dia=dial_base.*ones(1,30); %base
dia_time=10:10:300;
alter_dia=bp_var*normrnd(0,0.4,[1,30]); %alter
dia_f=dia+alter_dia;
dia_t=1:300;
dia_f=spline(dia_time,dia_f,dia_t);
%write files
writematrix(sys_f',"bloodhigh_low.csv");
writematrix(dia_f',"bloodlow_low.csv");


%%
%respiratory rate adult
rrn_base=16;
rrh_base=25;
rrl_base=9;
rr_var=2;
%%
%normal
rr=rrn_base.*ones(1,48); %base
alter_rr=rr_var*normrnd(0,0.3,[1,48]); %alter
rr_f=rr+alter_rr;
rr_f=spline(10:10:480,rr_f,1:480);
interval_rr=round(500*60./rr_f);
rr_t=cumsum(interval_rr);
rr_f=spline(rr_t,rr_f,500:500:rr_t(end));
writematrix(rr_f',"respiratory_norma11.csv");
%pattern,resp
t=1:100;
x=sin(2*pi/100.*t);
resp_train=[];
for i=interval_rr
    resp_train=[resp_train spline(i:i:100*i,x,100:100:100*i)];
end
resp_train=resp_train(1:(rr_t(end)-mod(rr_t(end),500)));
writematrix(resp_train',"resp_normal1.csv");
%%
%abnormal high
rr=rrh_base.*ones(1,9); %base
alter_rr=rr_var*normrnd(0,0.3,[1,9]); %alter
rr_f=rr+alter_rr;
rr_f=spline(10:10:90,rr_f,1:90);
interval_rr=round(500*60./rr_f);
rr_t=cumsum(interval_rr);
rr_f=spline(rr_t,rr_f,500:500:rr_t(end));
writematrix(rr_f',"respiratory_high.csv");
%pattern,resp
t=1:100;
x=sin(2*pi/100.*t);
resp_train=[];
for i=interval_rr
    resp_train=[resp_train spline(i:i:100*i,x,100:100:100*i)];
end
resp_train=resp_train(1:(rr_t(end)-mod(rr_t(end),500)));
writematrix(resp_train',"resp_high.csv");
%%
%abnormal low
rr=rrl_base.*ones(1,9); %base
alter_rr=rr_var*normrnd(0,0.3,[1,9]); %alter
rr_f=rr+alter_rr;
rr_f=spline(10:10:90,rr_f,1:90);
interval_rr=round(500*60./rr_f);
rr_t=cumsum(interval_rr);
rr_f=spline(rr_t,rr_f,500:500:rr_t(end));
writematrix(rr_f',"respiratory_low.csv");
%pattern,resp
t=1:100;
x=sin(2*pi/100.*t);
resp_train=[];
for i=interval_rr
    resp_train=[resp_train spline(i:i:100*i,x,100:100:100*i)];
end
resp_train=resp_train(1:(rr_t(end)-mod(rr_t(end),500)));
writematrix(resp_train',"resp_low.csv");