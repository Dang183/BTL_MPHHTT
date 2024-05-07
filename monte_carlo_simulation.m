function [ber_avg] = monte_carlo_simulation(snr_db, num_trials)
    % snr_db: T? l? tín hi?u nhi?u ???c bi?u di?n d??i d?ng dB
    % num_trials: S? l?n th? (trials) ?? ?ánh giá hi?u n?ng
    % ber_avg: M?c ?? bit (bit error rate) trung bình d?a trên k? thu?t Monte Carlo
    
    % Thi?t l?p các thông s? c?a h? th?ng truy?n thông s?
    num_bits = 10000;
    data = randi([0 1], 1, num_bits);
    
    % Tính m?c ?? bit trung bình sau nhi?u l?n th? (trials)
    ber_sum = 0;
    for i = 1:num_trials
        % T?o ra tín hi?u ?i?u ch? (modulated signal)
        modulated_signal = dpskmod(data, 2);
        
        % T?o ra tín hi?u nhi?u Gauss v?i m?c ?? nhi?u ???c bi?u di?n d??i d?ng SNR_db
        snr_linear = 10^(snr_db/10);
        noise = randn(size(modulated_signal));
        power_signal = mean(abs(modulated_signal).^2);
        power_noise = power_signal/snr_linear;
        noise = noise*sqrt(power_noise);
        received_signal = modulated_signal + noise;
        
        % Gi?i ?i?u ch? tín hi?u ?? l?y l?i dãy s? bit
        demodulated_data = dpskdemod(received_signal, 2);
        
        % Tính s? l??ng bit sai khác gi?a dãy s? ban ??u và dãy s? ???c l?y l?i
        num_errors = sum(data ~= demodulated_data);
        
        % Tính m?c ?? bit d?a trên s? l??ng bit sai khác
        ber_sum = ber_sum + num_errors/num_bits;
    end
    ber_avg = ber_sum/num_trials;
end