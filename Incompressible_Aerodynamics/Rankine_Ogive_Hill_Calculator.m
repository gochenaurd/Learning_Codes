
clear;clf;clf;

height = 850;
len = 1200;
Vinf = 20;

holdError = inf;
holdR = 0;
holdRHS = 0;

for R = 0:0.001:1200
    RHS = (1200) * tan(pi - 850/R);
    errorTest = abs(height - RHS)/abs(height);
    if errorTest < holdError
        holdError = errorTest;
        holdR = R;
        holdRHS = RHS;
    end
end

holdError;
holdR;
holdRHS;
Q = Vinf * 2 * pi * holdR;
testSol = (1200-holdR) * tan(pi - height/holdR);

QSol = 34000;
holdRSol = 270.56;

tic
[x, y] = meshgrid([-1000:10:2000], -1000:10:1000);
startY = [-1000:50:1000, 0.0001, -0.0001];
startX = -2*holdR*ones([length(startY), 1]);
 
z = Vinf*y + Q/(2*pi) * atan2(y, x);
u = Vinf + Q * x ./ (2*pi * (x.^2 + y.^2));
v = Q * y./ (2*pi * (x.^2 + y.^2));

zSol = Vinf*y + QSol/(2*pi) * atan2(y, x);
uSol = Vinf + QSol * x ./ (2*pi * (x.^2 + y.^2));
vSol = QSol * y./ (2*pi * (x.^2 + y.^2));

subplot(2, 1, 1)
title('Exact Solution')
ylabel('y (m)')
xlabel('x (m)')
streamline(x, y, u, v, startX, startY);
hold on
plot([-holdR, -holdR], [-900, 1000], 'k')
plot([-holdR*2, 2000], [0,0], 'k')
plot([1200, 1200], [-900, 1000], 'r')
plot([-holdR*2, 2000], [850,850], 'r')
grid on
xlim([-600, 2000]);
ylim([-0, 1000]);
text(300, 400, sprintf('r = %.1f m, Q = %.0f m^2/s', holdR, Q))
tx = annotation('textarrow', [0.715, 0.668], [0.8, 0.875], 'String', 'Streamline touches A');

subplot(2, 1, 2)
title('Given Test Solution')
ylabel('y (m)')
xlabel('x (m)')
streamline(x, y, uSol, vSol, startX, startY);
hold on
plot([-holdRSol, -holdRSol], [-900, 1000], 'k')
plot([-holdRSol*3, 2000], [0,0], 'k')
plot([1200, 1200], [-900, 1000], 'r')
plot([-holdRSol*3, 2000], [850,850], 'r')
grid on
xlim([-600, 2000]);
ylim([0, 1000]);
text(300, 300, sprintf('r = %.1f m, Q = %.0f m^2/s', holdRSol, QSol))
annotation('textarrow', [0.725, 0.668], [0.3, 0.399], 'String', 'Streamline misses A');

toc;

