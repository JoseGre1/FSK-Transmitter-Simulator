%% LIMPIEZA
clear all;
clc;
close all;
%w = warning ('off','all');
%% FUENTE DE INFORMACION
Rb = 2400;
Tb = 1/Rb; %%[s]
mpb = 8; %Muestras por bit
delta = 1/(mpb*(1/Tb));
nbits = 10;
vector = round(random('Uniform',0,1,1,nbits));
%% CODIFICACION DE LINEA
A=1;
lim = Tb/delta + 1;
showb = 8;
[t1,y] = EncoderURZ(A,Tb,vector,mpb);
t_bits = nbits; %Transmitted bits
%% TRANSMISOR
y_inv = double(~y);
f1 = 2*Rb;
deltaf = Rb;i = 1;
iter = 1;
s_FSK = 0;
while i<=length(y)
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    phi2 = sqrt(2/Tb)*cos(2*pi*(f1+deltaf)*t2);
    sum1 = y(i).*phi1;
    sum2 = y_inv(i).*phi2;
    s_FSK = [s_FSK sum1+sum2];
    i = i + Tb/delta;
    iter = iter+1;
end
s_FSK = s_FSK(2:length(s_FSK));
t2 = linspace(delta,(iter-1)*Tb,length(s_FSK));
%% <PRUEBA DE FRECUENCIA>
figure(3)
NFFT = length(t2);
f = -1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT));
S_FSK = abs(fft(s_FSK,NFFT)/length(t2));
S_FSK = fftshift(S_FSK);
plot(-f,S_FSK)
%% </PRUEBA DE FRECUENCIA>
figure(2)
plot(t2,s_FSK)
set(gca,'xtick',0:Tb:t2(length(t2)))
grid on
xlim([delta (iter-1)*Tb]);
%% VISUALIZACION
bit_cur = 1;
figure(1)
plot(t1,y,'o')
hold on
plot(t1,y,'r')
set(gca,'ylim',[-0.1*A 1.1*A])
grid on
set(gca,'xtick',Tb:Tb:t1(length(t1)))
set(gca,'ytick',[0 A])
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Salida Del Codificador','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);
while(bit_cur<=length(vector)) 
    if bit_cur > showb
        xlim([Tb*(bit_cur-showb) bit_cur*Tb]);
    else
        xlim([0 showb*Tb]);
    end
    bit_cur = bit_cur+1;
    pause(0.0001)
end
%% RECEPTOR
iter = 1;
i= 1;
x1 = [];
x2 = [];
y_rec = [];
while iter<=t_bits
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    phi2 = sqrt(2/Tb)*cos(2*pi*(f1+deltaf)*t2);
    dem1 = s_FSK(round(i):round(iter*Tb/delta)).*phi1; 
    dem2 = s_FSK(round(i):round(iter*Tb/delta)).*phi2;
    facop1 = sum(dem1)*delta;
    facop2 = sum(dem2)*delta;
    x1 = [x1 facop1];
    x2 = [x2 facop2];
    dif_aco = facop1-facop2;
    if dif_aco >= 0
        y_rec = [y_rec 1];
    else
        y_rec = [y_rec 0];
    end
    i = i + Tb/delta;
    iter = iter+1;
end
y_rec
vector