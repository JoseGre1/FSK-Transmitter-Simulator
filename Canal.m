%% CANAL
EbNo = 10;               % Definimos un  Eb/No en dB. Entre 1 y 15.
% Tb es el tiempo de bit y Tsample es el tiempo de muestreo. 
Tsample = deltab;
SNR = EbNo - 10*log10((0.5*Tb)/Tsample);
%Tomamos la señal modulada y le agregamos ruido. Con un SNR hallado anteriormente.
s_awgn = awgn(s_FSK,SNR,'measured');
%Señal filtrada
s_rec = filter(Filtro,s_awgn);
%Graficamos la señal modulada con ruido.
figure(5)
plot(t2,s_awgn)
%Grafica de la sseñal enviada y filtrada
figure(6)
plot(t2,s_FSK)
set(gca,'xtick',0:Tb:t2(length(t2)))
grid on
xlim([delta (iter-1)*Tb]);
hold on
plot(t2,s_rec,'r')