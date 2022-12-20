close all
clc
%%
%body temperature
load("body_temperature.mat") %base signal
alter_bt=0.1*normrnd(0,0.3,[1,240]); %alter in minutes
bt_f=bt+alter_bt;
bt_t=1:1440*60;
bt_f=spline(bt_time,bt_f,bt_t); %upsampling
%%
%heart rate
%normal
hr=75.*ones(1,180); %base
hr_time=10:10:1800;
alter_hr=5*normrnd(0,0.3,[1,180]); %alter
hr_f=hr+alter_hr;
hr_t=1:1800;
hr_f=spline(hr_time,hr_f,hr_t);
%%
%abnormal high
hr=110.*ones(1,30); %base
hr_time=10:10:300;
alter_hr=5*normrnd(0,0.3,[1,30]); %alter
hr_f=hr+alter_hr;
hr_t=1:300;
hr_f=spline(hr_time,hr_f,hr_t);
%%
%abnormal low
hr=40.*ones(1,30); %base
hr_time=10:10:300;
alter_hr=5*normrnd(0,0.3,[1,30]); %alter
hr_f=hr+alter_hr;
hr_t=1:300;
hr_f=spline(hr_time,hr_f,hr_t);
%%
%train of deltaf
freq=hr_f./60;
interval=floor(500./freq);
train=zeros(1,length(interval)*500);

t=interval(1);
train(1)=1;
train(interval(1))=1;
i=2;
while i<=length(interval)
    if t>i*500
        i=i+1;
    else
        train(interval(i))=1;
        t=t+interval(i);
    end
end

% train=zeros(1,300*500);
% for i = cumsum(interval)
%     train(1,floor(i*500))=1;
% end
%%
ecg_train=conv(train,ecg,'same');

%%
f=hr; %frequency of the impulse in Hz
fs=f*10; % sample frequency is 10 times higher
t=0:1/fs:1; % time vector
y=zeros(size(t));
y(1:fs/f:end)=1;
plot(t,y);
%%
%ecg
figure,
plot(lead_one_time,lead_one_amplitude)
hold on
ecg1_time=0:0.002:0.8;
ecg1=spline(lead_one_time,lead_one_amplitude,ecg1_time);
plot(ecg1_time,ecg1)