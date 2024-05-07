function [ber_avg] = monte_carlo_simulation(snr_db, num_trials)
    % snr_db: T? l? t�n hi?u nhi?u ???c bi?u di?n d??i d?ng dB
    % num_trials: S? l?n th? (trials) ?? ?�nh gi� hi?u n?ng
    % ber_avg: M?c ?? bit (bit error rate) trung b�nh d?a tr�n k? thu?t Monte Carlo
    
    % Thi?t l?p c�c th�ng s? c?a h? th?ng truy?n th�ng s?
    num_bits = 10000;
    data = randi([0 1], 1, num_bits);
    
    % T�nh m?c ?? bit trung b�nh sau nhi?u l?n th? (trials)
    ber_sum = 0;
    for i = 1:num_trials
        % T?o ra t�n hi?u ?i?u ch? (modulated signal)
        modulated_signal = dpskmod(data, 2);
        
        % T?o ra t�n hi?u nhi?u Gauss v?i m?c ?? nhi?u ???c bi?u di?n d??i d?ng SNR_db
        snr_linear = 10^(snr_db/10);
        noise = randn(size(modulated_signal));
        power_signal = mean(abs(modulated_signal).^2);
        power_noise = power_signal/snr_linear;
        noise = noise*sqrt(power_noise);
        received_signal = modulated_signal + noise;
        
        % Gi?i ?i?u ch? t�n hi?u ?? l?y l?i d�y s? bit
        demodulated_data = dpskdemod(received_signal, 2);
        
        % T�nh s? l??ng bit sai kh�c gi?a d�y s? ban ??u v� d�y s? ???c l?y l?i
        num_errors = sum(data ~= demodulated_data);
        
        % T�nh m?c ?? bit d?a tr�n s? l??ng bit sai kh�c
        ber_sum = ber_sum + num_errors/num_bits;
    end
    ber_avg = ber_sum/num_trials;
end