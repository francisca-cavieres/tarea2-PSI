angulos = [-90, 30, 90];


for k = 1:length(angulos)

    ang = angulos(k);

    % Construcción automática del nombre del archivo
    filename = sprintf("~/Desktop/Universidad/Tercer año/Segundo Semestre/PSI/tarea2-PSI/signal/signal%d.wav", ang);

    fprintf("\nProcesando archivo: signal%d.wav\n", ang);

    %% Lectura del archivo
    [x, Fs] = audioread(filename);

    % Extracción de señales de audio de cada micrófono
    x1 = x(:,1);
    x2 = x(:,2);

    %% Posición de los micrófonos
    x_x1 = -0.25;
    x_x2 = 0.25;
    dist = abs(x_x2) + abs(x_x1);

    %% Parámetros
    M = length(x1) + length(x2);
    d = 10;
    L = d * M;
    c = 340;

    %% FFT
    X1 = fft(x1, M);
    X2 = fft(x2, M);

    %% GCC-PHAT
    num = X1 .* conj(X2);
    den = abs(X1) .* abs(X2);
    arg = num ./ den;

    %% IFFT
    R12 = ifft(arg, L);

    %% fftshift manual
    shift = floor(L/2);
    R_combined = [R12(L-shift+1:L); R12(1:shift)];

    %% Estimación del retardo
    [~, D] = max(abs(R_combined));
    tau = (D - shift) / (d * Fs);

    tm = dist / c;
    ratio = tau / tm;

    %% Ángulo estimado
    theta = asind(ratio);

    fprintf("======== GCC - PHAT manual para %d ========\n",ang);
    disp("Ángulo real = " + num2str(ang) + "°");
    disp("Theta estimado = " + num2str(theta) + "°");
    disp("===================================")

    %% GCC-PHAT de MATLAB
    microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange', [20 Fs/2]);
    array = phased.ULA(2, 0.5, 'Element', microphone);
    gcc = phased.GCCEstimator( ...
        'SensorArray', array, ...
        'PropagationSpeed', c, ...
        'SampleRate', Fs);

    signal_matrix = [x1(:) x2(:)];
    theta_matlab = gcc(signal_matrix);

    fprintf("======== MATLAB GCC - PHAT para %d ==========\n",ang);
    disp("Theta MATLAB = " + num2str(theta_matlab) + "°");
    disp("=====================================")

end





