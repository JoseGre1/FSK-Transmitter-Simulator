%SISTEMA COMPLETO
%FECHA: 19-05-2015 (DIA QUE LE FUIMOS A PREGUNTAR AL RUSO)
%% LIMPIEZA
clear all;
clc;
close all;
%w = warning ('off','all');
%% FUENTE DE INFORMACION
Rb = 2400; %[bps]
Tb = 1/Rb; %[s]
mpb = 8;   %Muestras por bit
deltab = 1/(mpb*(1/Tb)); %1/fs para los bits
i_bits = 10; %Bits de informacion
vector = round(random('Uniform',0,1,1,i_bits));
%% CODIFICACION DE CANAL
e_vector = vector;
check_encoder = 0; %0:Sin codificacion de CH, 1: Con codificaci�n de CH
if (check_encoder)
    n_bits = 3; %Bits de redundancia
    e_vector = Ch_Encoder(vector,n_bits);
end
t_bits = length(e_vector); %Bits transmitidos
%% CODIFICACION DE LINEA
Eb = 1; %Energia unitaria
A = sqrt(Eb); 
lim = Tb/deltab + 1;
showb = 8; %Bits a mostrar en ventana
[t1,y] = EncoderUNRZ(A,Tb,e_vector,mpb); %Encoder UNRZ
%% MODULACION FSK
deltaf = Rb; %Separaci�n entre frec 1 y frec 2
f1 = 2*Rb; %Frecuencia 1
f2 = f1+deltaf; %Frecuencia 2
fQ = 5/3; %Sobremuestreo
delta = 1/(2*fQ*(f1+deltaf)); %nueva delta para nueva freq de muestreo
y_inv = A*double(~y); 
i = 1;
iter = 1;
s_FSK = []; 
fase1 = 0.1896; %valor de fase obtenido de phasez() para f1=4800
fase2 = -fase1; %valor de fase obtenido de phasez() para f2=7200
cor_tif1 = - fase1/(2*pi*f1); %Ajuste de fase --> Tiempo
cor_tif2 = - fase2/(2*pi*f2); %Ajuste de fase --> Tiempo
cor_mu1 = round(cor_tif1/delta); %Ajuste de Tiempo --> Muestras
cor_mu2 = round(cor_tif2/delta); %Ajuste de Tiempo --> Muestras
while i<=length(y)
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    circshift(phi1,cor_mu1); %Corrimiento de muestras
    phi2 = sqrt(2/Tb)*cos(2*pi*f2*t2);
    circshift(phi2,cor_mu2); %Corrimiento de muestras
    sum1 = y(i).*phi1;
    sum2 = y_inv(i).*phi2;
    s_FSK = [s_FSK sum1+sum2];
    i = i + Tb/deltab;
    iter = iter+1;
end
t2 = linspace(delta,t_bits*Tb,length(s_FSK));
%% CANAL
EbNo = 2;               % Definimos un  Eb/No en dB. Entre 1 y 15.
% Tb es el tiempo de bit y Tsample es el tiempo de muestreo. 
Tsample = deltab;
SNR = EbNo - 10*log10((0.5*Tb)/Tsample);
%Tomamos la se�al modulada y le agregamos ruido. Con un SNR hallado anteriormente.
s_awgn = awgn(s_FSK,SNR,'measured');
%Se�al filtrada
s_rec = filter(Filtro,s_awgn);
%% RECEPTOR
iter = 1;
i= 1;
x1 = [];
x2 = [];
y_rec = [];
while iter<=t_bits
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    phi2 = sqrt(2/Tb)*cos(2*pi*f2*t2);
    dem1 = s_rec(round(i):round(iter*Tb/delta)).*phi1; 
    dem2 = s_rec(round(i):round(iter*Tb/delta)).*phi2;
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
%% DECODIFICADOR DE CANAL
y_decod = y_rec;
if (check_encoder)
    y_decod = [];
    for i=1:n_bits:t_bits
        sumab = sum(y_rec(i:(i+n_bits-1)));
        if sumab>n_bits/2
            y_decod = [y_decod 1];
        else
            y_decod = [y_decod 0];
        end
    end
end
t2 = linspace(delta,t_bits*Tb,length(s_FSK));
%% CONTEO DE ERRORES
comp = xor(y_decod,vector);
errors = sum(comp);
BER = errors/i_bits;