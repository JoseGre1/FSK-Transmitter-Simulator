%% LIMPIEZA
clear all;
clc;
w = warning ('off','all');
%% VARIABLES DE SISTEMA
Rb = 1e+3;             %Tasa de transmisión    [bps]
Mascara=[1 0];         %Fijo 
bit_vector = [1 0 1 0 0 1 1 0];  %Vector de Bit que se quiere transmitir.
n=length(bit_vector);  %# de Bits              [bits]
fs = Rb/n;             %Frecuencia de muestreo [Hz]
Tb = 1/Rb;             %Duración del bit       [s]
Eb = 1;                %Energía de la señal    [J]
A = sqrt(2*Eb/Tb);     %Voltaje máximo         [V]
snrmaxo=1*10^3;
snrmino=1;
%% Mascara para el filtro
[tf,f] = EncoderURZ(A, Tb, Mascara);
%% TRANSMISOR
Nomin=(2*Eb)/snrmaxo;
W=2*Rb;
Pnmin=Nomin*W;
Pm=Eb/Tb;
snrimax=Pm/Pnmin;
snridbmax=10*log10(snrimax);
%--------------------------
Nomax=(2*Eb)/snrmino;
Pnmax=Nomax*W;
snrimin=Pm/Pnmax;
snridbmin=10*log10(snrimin);
%--------------------------
[t,y] = EncoderURZ(A, Tb, bit_vector);
%% CANAL
Y_awgn=awgn(y,snridbmin,'measured');
%% FILTRO ACOPLADO
delta=1/(2000*(1/Tb));
nh=Tb/delta;
h=f(nh+1:-1:1);
tb=0:delta:Tb;
%% CONVOLUCIÓN
yo=0;
c1=0;
for i=1:n
  N=i-1;  
  lin=1+nh*N;
  lup=(1+N)*nh+1;
  y1=Y_awgn(lin:1:lup);
  y1t=conv(h,y1).*delta;
  y1t1=y1t(1:1:nh+1);
  c = Decisor(y1t1,nh,Eb);
  yo=[yo y1t1];
  c1=[c1 c];
end 
%% Salida del filtro
delta2=n*Tb/(length(yo)-1);
tbo=0:delta2:n*Tb;
%% Salida del decisor
co=c1(2:1:(n+1));
str1 = sprintf('Secuencia de bits Rx: %s', num2str(co));
disp(str1);
str2 = sprintf('Secuencia de bits Tx: %s', num2str(bit_vector));
disp(str2);
%% Grafica probabilidad de error
snro=snrmino:1:snrmaxo;
snrodb=10*log10(snro);
Pe=0.5*erfc(0.5*((0.5*snro).^(1/2)));
%% Grafica Salida del decisor
[td,ydec] = EncoderURZ(A, Tb, co);
%% Figuras
figure(1)
plot(t,y)
set(gca,'ylim',[-0.1*A 1.1*A])
grid on
set(gca,'xtick',0:Tb:t(length(t)))
set(gca,'ytick',[0 A])
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Salida Del Codificador','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);

figure(2)
plot(t,Y_awgn,'Color',[1 1 0])
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Señal en el canal con ruido','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);

figure(3)
plot(tb,h,'Color',[1 0 1])
grid on
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Filtro Acoplado','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);

figure(4)
plot(tbo,yo,'Color',[1 0 0])
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Señal de Salida del Filtro Acoplado','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);

figure(5)
semilogy(snrodb,Pe,'Color',[0 1 0])
ylabel('BER')
xlabel('SNRo (dB)')
title('Probabilidad de error Pe (BER vs SNRo)','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);

figure(6)
plot(td,ydec,'Color',[1 0.4 0])
set(gca,'ylim',[-0.1*A 1.1*A])
grid on
set(gca,'xtick',0:Tb:t(length(t)))
set(gca,'ytick',[0 A])
ylabel('Amplitud (Volt)')
xlabel('Tiempo (Segundos)')
title('Salida Del Decisor','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);
%% Calculos 
figure(7)
cal=imread('Calculos.png');
imshow(cal,'Border','tight')