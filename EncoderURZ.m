function [t,y] = EncoderURZ(A,Tb,bit_vector)
    delta = 1/(2000*(1/Tb));
    t = 0:delta:Tb-delta;
    y = 0;
    for i=1:length(bit_vector);
        switch(bit_vector(i))
         case 0
             y = [y 0*t];
          case 1
             y = [y A*rectpuls(t,Tb)];
        end
    end
    t = 0:delta:Tb*length(bit_vector);
    return;
end