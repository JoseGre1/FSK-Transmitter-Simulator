%% LIMPIEZA
clear all;
clc;
close all;
%w = warning ('off','all');
%% FUENTE DE INFORMACION
Rb = 2400;
Tb = 1/Rb; %%[s]
mpb = 8;
delta = 1/(mpb*(1/Tb));
nbits = 100;
t_bits = nbits;
vector = round(random('Uniform',0,1,1,nbits));
%% CODIFICACION DE LINEA
A=1;
lim = Tb/delta + 1;
showb = 8;
[t1,y] = EncoderURZ(A,Tb,vector,mpb);
%% TRANSMISOR
y_inv = A*double(~y);
f1 = 2*Rb;
deltaf = Rb;
i = 1;
iter = 1;
s_FSK = [];
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
t2 = linspace(delta,t_bits*Tb,length(s_FSK));
Eb = A^2*Tb;
%% <PRUEBA DE FRECUENCIA>
figure(3)
NFFT = length(t2);
Nsamp = (length(t2)*delta);
f = -(-1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT)));
S_FSK = abs(fft(s_FSK,NFFT)/length(t2));
S_FSK = fftshift(S_FSK);
%embarajuste
S_FSK = S_FSK*(2*Eb)*Nsamp/(t_bits/100);
%/embarajuste
plot(f,S_FSK/(2*Eb),'g')
%% PSD
figure(4)
[Psd_FSK, f] = pwelch(s_FSK,[],[],[],'twosided',mpb);
f = (f-mpb/2)*Rb; f = -f; f=f(end:-1:1);
Psd_FSK = fftshift(Psd_FSK)*0.7*(2*Eb)/max(Psd_FSK);
Psd_FSK = circshift(Psd_FSK,-1);
plot(f,Psd_FSK/(2*Eb)) %NORMALIZADA QUITAR EL 2*Eb para sacar la grafica normal
xlim([-(f1+deltaf+Rb) f1+deltaf+Rb])
%%
figure(2)
plot(t2,s_FSK)
set(gca,'xtick',0:Tb:t2(length(t2)))
grid on
%xlim([deltat (iter-1)*Tb]);
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
    pause(0.25)
end