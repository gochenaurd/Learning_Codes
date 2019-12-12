%% Gives the steady state output of a spring forced by a 2pi periodic sawtooth wave

clear;clf;
syms t;

t = linspace(0, 14*pi, 2^15);
x = pi*sawtooth(t);

aNot = 0;
f = aNot;

nMax = 200;

for n = 1:1:nMax
    f = f - 2/n*sin(n*t);
end

figure(1)
plot(t, x, 'k')
xlim([0, 10*pi])
hold on;
grid on;
plot(t, f, 'b')
title('Fourier Series Representations of a 2\pi Periodic Sawtooth Wave')
hold off

g = tf([1 0], [5 1 5]) %Transfer function
u = f;

yNot = -2*sin(t);
yss = yNot;

for k = 2:100
    gk = k*i/(5*(k*i)^2+(k*i)+5);
    yss = yss + (-2/k) * abs(gk)*sin(k*t+angle(gk));
end

figure(2)
lsim(g, u, t);
grid on;
hold on;
plot(t, yss, 'r')
