clear;clf;
L=1e+6;
f_ovsamp=8;
delay_rc=3;
prcos = rcosflt([1], 1 , f_ovsamp, 'sqrt', 0.5 , delay_rc);
prcos = prcos(1:end-f_ovsamp+1);
prcos = prcos/norm(prcos);
pcmatch = prcos(end:-1:1);
%Rectangular pulse
prect = ones(1,f_ovsamp);
prect = prect/norm(prect);
prmatch = prect(end:-1:1);
%Half-sine pulse
psine = sin([0:f_ovsamp-1]*pi/f_ovsamp);
psine = psine/norm(psine);
psmatch = psine(end:-1:1);
%Random polar signaling data
s_data = 2*round(rand(L,1))-1;
%upsample
s_up = upsample(s_data,f_ovsamp);

delayrc = 2*delay_rc*f_ovsamp;
delayrt = f_ovsamp-1;
delaysn = f_ovsamp-1;
%Polar signaling different pulse shaping
xrcos = conv(s_up,prcos);
xrect = conv(s_up,prect);
xsine = conv(s_up,psine);
t=(1:200)/f_ovsamp;

figure(1)
figwave1 = plot(t,xrcos(delayrc/2:delayrc/2+199));

figure(2)
figwave2 = plot(t,xrect(delayrt:delayrt+199));

figure(3)
figwave3 = plot(t,xsine(delaysn:delaysn+199));
%Channel with noise
Lrcos = length(xrcos); Lrect = length(xrect); Lsine = length(xsine); %signal lenght
BER = [];
noiseq = randn(Lrcos,1);
for i=1:10
    Eb2N(i) = i;
    Eb2N_num = 10^(Eb2N(i)/10);
    Var_n = 1/(2*Eb2N_num);
    signois = sqrt(Var_n);
    awgnois = signois*noiseq;
    yrcos = xrcos+awgnois;
    z1 = conv(yrcos,pcmatch); clear awgnois, yrcos;
    z1 = z1(delayrc+1:f_ovsamp:end);
    dec1 = sign(z1(1:L));
    BER = [BER sum(abs(s_data-dec1))/(2*L)];
    Q(i) = 0.5*erfc(sqrt(Eb2N_num));
end
figure(4)
[Psd1, f] = pwelch(xrcos,[],[],[],'twosided',f_ovsamp);
plot(f-f_ovsamp/2,fftshift(Psd1))