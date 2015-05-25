function cod_bits = Ch_Encoder(bit_vector,n_bits)
    cod_bits = [];
    for i=1:length(bit_vector);
        redun_bits = bit_vector(i)*ones(1,n_bits);
        cod_bits = [cod_bits redun_bits];
    end
    return;
end