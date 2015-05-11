function c = Decisor(y1t1,nh,Eb)
        umbral=Eb/2;
        nh = floor(nh +1);
        if y1t1(nh)>umbral
            c=1;
        end
        if y1t1(nh)<umbral
            c=0;
        end
        if y1t1(nh)==umbral
            c=random('Discrete Uniform',2)-1;
        end
        

end 