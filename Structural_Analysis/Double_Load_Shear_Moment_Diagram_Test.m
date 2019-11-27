%% This is a test of the shear stress and moment diagram program

%% Variable Declarations
clear
clf

%Beam Parameters
beamLength = 6;
beamHeight = 1;

%Support Parameters
%numbSupports = 2;
supportXLoc = [0, beamLength];

%Load Parameters
%numbLoads = 1;
forceXLoc = [1.5, 4];
forceMag = [-5, -10];

%% Calculations and Output

%Calculate Support Conditions
syms R1 R2 real
moment1Eq = 0 == (supportXLoc(2) * R2) + (forceXLoc(1) * forceMag(1)) + (forceXLoc(2) * forceMag(2));
forceYEq = 0 == R1 + R2 + forceMag(1) + forceMag(2);
eqns = [moment1Eq forceYEq];
supportMag = vpasolve(eqns);
R1 = supportMag.R1;
R2 = supportMag.R2;
supportDoub = double([R1 R2]);

%Plot Beam
subplot(3, 1, 1)
rectangle('Position', [0 0 beamLength beamHeight], 'Facecolor', [0.2, 0.7, 0.9], 'Edgecolor', 'b', 'LineWidth', 1) 

%Format Plot
maxMag = max(abs(max(supportDoub, forceMag)));
sF = 5 / maxMag; %Scale Factor
title("Specified Forces")
xlim([-1, beamLength + 1])
ylim([-9, 10])
set(gca, 'XColor', 'w', 'YColor', 'w', 'YTick', [], 'XTick',[]);

%Plot Supports
hold on
for(i = 1:length(supportXLoc))
    yMag = supportDoub(i) * sF;
    arrow = quiver(supportXLoc(i), -yMag, 0, yMag, 0);
    t = text(supportXLoc(i), -yMag-0.8, num2str(supportDoub(i), 3), 'HorizontalAlignment', 'center');
    t.FontWeight = 'bold';
    set(arrow, 'color', 'k', 'LineWidth', 1)
end

%Plot Loads
for(i = 1:length(forceXLoc))
    yMag = forceMag(i) * sF;
    arrow = quiver(forceXLoc(i), -yMag, 0, 1+yMag, 0);
    t = text(forceXLoc(i), -yMag+0.9, num2str(forceMag(i), 2), 'HorizontalAlignment', 'center');
    t.FontWeight = 'bold';
    set(arrow, 'color', 'k', 'LineWidth', 1)
end

%Calculate Shear 
syms x;
V1(x) = R1;
V2(x) = R1 + forceMag(1);
V3(x) = R1 + forceMag(1) + forceMag(2);
shear(x) = piecewise(supportXLoc(1)<=x<forceXLoc(1), V1, forceXLoc(1)<=x<forceXLoc(2), V2, V3);

%Calculate Moment
M1(x) = R1 * x;
M2(x) = (R1 * x) + (forceMag(1) * (x - forceXLoc(1)));
M3(x) = (R1 * x) + (forceMag(1) * (x - forceXLoc(1))) + (forceMag(2) * (x - forceXLoc(2)));
moment(x) = piecewise(supportXLoc(1)<=x<=forceXLoc(1), M1, forceXLoc(1)<x<=forceXLoc(2), M2, M3);

%Plot Shear
subplot(3, 1, 2)
shearCurve = fplot(shear);

set(shearCurve, 'Color', 'b', 'LineWidth', 1);
title("Shear Forces")
xlim([0, beamLength])
ylim([-20, 20])
line([0 beamLength], [0 0], 'Color', 'k');

%Apply Text Labels
txt = num2str((double(shear(forceXLoc(1)/2))), 3);
text(forceXLoc(1)/2, (double(shear(forceXLoc(1)/2)) + 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
txt = num2str((double(shear((forceXLoc(1)+forceXLoc(2))/2))), 3);
text((forceXLoc(1)+forceXLoc(2))/2, (double(shear((forceXLoc(1)+forceXLoc(2))/2)) + 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
txt = num2str((double(shear((forceXLoc(2)+beamLength)/2))), 3);
text((forceXLoc(2)+beamLength)/2, (double(shear((forceXLoc(2)+beamLength)/2)) - 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

%Plot Moment
subplot(3, 1, 3)
momentCurve = fplot(moment);

set(momentCurve, 'Color', 'b', 'LineWidth', 1);
title("Bending Moment")
xlim([0, beamLength])
ylim([-20, 20])
line([0 beamLength], [0 0], 'Color', 'k');

%Apply Text Labels
txt = [num2str(double(moment(forceXLoc(1))), 3) ' \rightarrow'];
thisthing = text(forceXLoc(1), double(moment(forceXLoc(1))), txt, 'HorizontalAlignment', 'right', 'Fontweight', 'bold', 'Linewidth', 10);
txt = ['\leftarrow ' num2str(double(moment(forceXLoc(2))), 3)];
text(forceXLoc(2), double(moment(forceXLoc(2))), txt, 'HorizontalAlignment', 'left', 'Fontweight', 'bold');



