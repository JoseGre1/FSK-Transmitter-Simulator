%% LIMPIEZA
clear all;
clc;
%w = warning ('off','all');
%% FUENTE DE INFORMACION
bit = round(random('Uniform',0,1));
Rb = 2400;
Tb = 1/Rb; %%[s]
delta = 1/(2000*(1/Tb));
%% PAUSE
vector = 0;
A=1;
lim = Tb/delta + 1;
showb = 10;
enter = 1;
while(1)
    bit = round(random('Uniform',0,1));
    vector = [vector bit];
    if length(vector) == 2 && enter == 1
        vector = vector(2);
        enter = 0;
    end
    [t,y] = EncoderURZ(A,Tb,vector);
    figure(1)
    plot(t,y)
    if length(vector) > showb
        xlim([Tb*(length(vector)-showb) length(vector)*Tb]);
    else
        xlim([0 showb*Tb]);
    end
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
    pause(0.5)
end