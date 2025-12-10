[x1,Fs] = audioread("~/Desktop/Universidad/Tercer año/Segundo Semestre/PSI/tarea2-PSI/signal/signal90.wav");
x2 = x1;
x_x1 = -0.25;
x_x2 = 0.25;

dist = abs(x_x2) + abs(x_x1)
M = length(x1) + length(x2);
d = 10;
L = d*M;
c = 340;

X1 = fft(x1, M);
X2 = fft(x2, M);

X_2 = conj(X2);
num = X1 .* X_2;
X1_abs = abs(X1);
X2_abs = abs(X2);
den = X1_abs .* X2_abs;
arg = num ./ den;

R12 = ifft(arg,L);

shift = floor(L/2);

part1 = R12(L-shift : L);
part2 = R12(1 : shift+1);
part1 = part1(:);
part2 = part2(:);
R_combined = [part1 ; part2];
    

[~, D] = max(abs(R_combined));

tau = (D - shift)/(d*Fs);        
tm = dist / c ;
res = tau/tm;
theta = asind(res);


microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange', [20 Fs/2]);
array = phased.ULA(2, 0.5, 'Element', microphone);
gcc = phased.GCCEstimator('SensorArray', array, 'PropagationSpeed', c,'SampleRate',Fs);

signal_matrix = [x1(:) x2(:)];

tau_2 = gcc(signal_matrix);






