Am = 100;
fm = 1;
Tm = 1/fm;
Ts = 1/100*Tm;
t = 0:Ts:2*Tm;

m = Am * cos (2*pi*fm*t);
u = 10;
Mmax  = max(abs(m));
Cx = (log(1+u*abs(m/Mmax))./log(1+u)).*sign(m);
Cx = max(Cx)*Cx;
%%normalization of output vector

figure(1)
plot(t,m/Mmax)
hold on
plot(t,Cx,'r')
hold off

figure(2)
plot(abs(m/Mmax),abs(Cx))

q=quantizer('fixed', 'Ceiling', 'saturate',[11,3]);
range(q)
mq = quantize(q, m);

figure(3)
plot(m, mq); title(tostring(q))
hold on
Cxq = quantize(q, Cx);
plot(Cx, Cxq,'r'); title(tostring(q))
hold off

figure(4)
plot(t,mq)
hold on
plot(t,m,'r')
hold off

figure(5)
plot(t,Cxq)
hold on
plot(t,Cx,'r')
hold off

figure(6)
plot(t,Cxq*100)
hold on
plot(t,mq,'r')
hold off

