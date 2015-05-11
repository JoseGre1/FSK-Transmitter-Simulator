function y=diracm(t)
y=zeros(1,length(t));
for n=1:length(t)
    if t(n)==0
        y(n)=1;
    else
        y(n)=0;
    end
end
end