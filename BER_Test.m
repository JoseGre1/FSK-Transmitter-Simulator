%% FUENTE DE INFORMACION
Rb = 2400;               %[bps]
Tb = 1/Rb;               %[s]
mpb = 8;                 %Muestras por bit
deltab = 1/(mpb*(1/Tb)); %1/fs para los bits
check_encoder = 0; %0:Sin codificacion de CH, 1: Con codificación de CH    
tic;
times = [];
memories = [];
EbNos = [];
cod_can = [];
for ciclos = 1:1
    BER_vector = [];
    for EbNo=1:12
        i_bits = round(1/(0.5*erfc(sqrt(0.5*10^(EbNo*0.1))))); %Bits de informacion
        err_found = 0;
        for bit_now = 1:i_bits
            if check_encoder
                cur_bit = round(random('Uniform',0,1));
                n_bits = 3;
                cur_bit = Ch_Encoder(cur_bit,n_bits);
            else
                cur_bit = round(random('Uniform',0,1));
                n_bits = 1;
            end
            %% CODIFICACION DE LINEA
            Eb = 1; %Energia unitaria
            A = sqrt(Eb); 
            [t1,y] = EncoderUNRZ(A,Tb,cur_bit,mpb); %Encoder UNRZ
            %% MODULACION FSK
            deltaf = Rb; %Separación entre frec 1 y frec 2
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
            t2 = linspace(delta,Tb,length(s_FSK));
            %% CANAL
            % Tb es el tiempo de bit y Tsample es el tiempo de muestreo. 
            Tsample = delta;
            SNR = EbNo + 10*log10((2/(Tb*1/delta)));
            %Tomamos la señal modulada y le agregamos ruido. Con un SNR hallado anteriormente.
            s_awgn = awgn(s_FSK,SNR,'measured');
            %Señal filtrada
            s_rec = filter(Filtro,s_awgn);
            %% RECEPTOR
            iter = 1;
            i= 1;
            x1 = [];
            x2 = [];
            y_rec = [];
            while iter<=n_bits
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
                sumab = sum(y_rec(1:n_bits));
                if sumab>n_bits/2
                    y_decod = [y_decod 1];
                else
                    y_decod = [y_decod 0];
                end
            end       
            if (y_decod~=cur_bit(1))
                err_found = err_found + 1; 
                if (err_found)>99
                    disp('Se encontraron mas de 100 errores');
                    break;
                end
            end
            EbNo
            porc = bit_now*100/i_bits
        end
        %% CONTEO DE ERRORES
        BER = err_found/i_bits;
        BER_vector = [BER_vector BER];
        base = whos;
        memory = [base(1:length(base)).bytes];
        clear base;
        memory = sum(memory);
        memories = [memories memory];
        EbNos = [EbNos EbNo];
        cod_can = [cod_can check_encoder];
        times = [times toc];
        save('Results_BER (1-12 sin)2')
    end
    check_encoder = 1; 
end