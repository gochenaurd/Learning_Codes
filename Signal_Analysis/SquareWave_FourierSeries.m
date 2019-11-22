%% Fourier Series Test

clear;clf;
syms t;

t = linspace(-2*pi, 2*pi, exp(10));
x = square(t);

aNot = 0;
f = aNot;
p = aNot;
g = aNot;

nMax = 2;
mMax = 10;
qMax = 50;

for n = 1:1:nMax
    f = f + 4 * (sin((2*n-1) * t) / ((2*n-1) * pi));
end

for m = 1:1:mMax
    p = p + 4 * (sin((2*m-1) * t) / ((2*m-1) * pi));
end

for q = 1:1:qMax
    g = g + 4 * (sin((2*q-1) * t) / ((2*q-1) * pi));
end

plot(t, x, 'k')
xlim([-2*pi, 2*pi])
hold on
plot(t, f, 'b')
plot(t, p, 'r')
plot(t, g, 'color', [0, 0.55, 0])
legend('Original', ['n = ' num2str(nMax)], ['n = ' num2str(mMax)], ['n = ' num2str(qMax)])
title('Various Fourier Series Representations of a 2\pi periodic Square Wave')
