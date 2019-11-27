%% This is a test of the shear stress and moment diagram program with multiple possible loads

%% Variable Declarations
clear
clf
tic
%Beam Parameters
beamLength = 10;
beamHeight = 1;

%Support Parameters, Use Two Supports For Statically Determinate Beam
supportXLoc = [0, beamLength];

%Point Load Parameters
forceXLoc = [3, 5, 7];
forceMag = [-15, -15, -13];
%forceXLoc = [1.5, 4];
%forceMag = [-5, -10];

%% Calculations and Output

%Calculate Support Conditions
numbSupports = length(supportXLoc);
numbLoads = length(forceXLoc);
R = sym('r', 1:numbSupports); %Symbolic reaction force variables
forceYEq = 0;
moment1Eq = 0;

for(i = 1:numbSupports)
    forceYEq = forceYEq + R(i);
end
for(i = 1:numbLoads)
    forceYEq = forceYEq + forceMag(i);
end
forceYEq = 0 == forceYEq;

for(i = 2:numbSupports)
    moment1Eq = moment1Eq + ((supportXLoc(i) - supportXLoc(1)) * R(i));
end
for(i = 1:numbLoads)
    moment1Eq = moment1Eq + (forceXLoc(i) - supportXLoc(1)) * forceMag(i);
end
moment1Eq = 0 == moment1Eq;

eqns = [moment1Eq forceYEq];
supportMag = vpasolve(eqns);
r1 = supportMag.r1; %Fix later, should work for unknown set of supports in loop
r2 = supportMag.r2;
supportDoub = double([r1 r2]);

%Plot Beam
subplot(3, 1, 1)
rectangle('Position', [0 0 beamLength beamHeight], 'Facecolor', [0.2, 0.7, 0.9], 'Edgecolor', 'b', 'LineWidth', 1) 

%Format Plot
maxMag = abs(max(max(supportDoub), max(forceMag)));
sF = 5 / maxMag; %Scale Factor
title("Specified Forces")
xlim([-1, beamLength + 1])
ylim([-9, 10])
set(gca, 'XColor', 'w', 'YColor', 'w', 'YTick', [], 'XTick',[]);

%Plot Supports
hold on
for(i = 1:numbSupports)
    yMag = supportDoub(i) * sF;
    arrow = quiver(supportXLoc(i), -yMag, 0, yMag, 0);
    t = text(supportXLoc(i), -yMag-0.8, num2str(supportDoub(i), 3), 'HorizontalAlignment', 'center');
    t.FontWeight = 'bold';
    set(arrow, 'color', 'k', 'LineWidth', 1)
end

%Plot Loads
for(i = 1:numbLoads)
    yMag = forceMag(i) * sF;
    arrow = quiver(forceXLoc(i), -yMag, 0, 1+yMag, 0);
    t = text(forceXLoc(i), -yMag+0.9, num2str(forceMag(i), 2), 'HorizontalAlignment', 'center');
    t.FontWeight = 'bold';
    set(arrow, 'color', 'k', 'LineWidth', 1)
end

%Calculate Shear 
allForceXLoc = [supportXLoc forceXLoc];
allForceMag = [supportDoub forceMag];
[sortForceXLoc, sortFIndex] = sort(allForceXLoc);
sortAllForceMag = allForceMag(sortFIndex);

numbSteps = 2000;
shear = zeros(2, numbSteps);
x = 0;
for(i = 1:numbSteps)
    shear(1, i) = 0;
    x = (i / numbSteps) * beamLength;
    for(j = 1:length(sortAllForceMag))
        if(sortForceXLoc(j) < x)
            shear(1, i) = shear(1, i) + sortAllForceMag(j);
        end
    end
    shear(2, i) = x;
end

%Plot Shear
subplot(3, 1, 2)
shearCurve = plot(shear(2, :), shear(1, :));

set(shearCurve, 'Color', 'b', 'LineWidth', 1);
title("Shear Forces")
xlim([0, beamLength])
ylim([-max(abs(shear(1, :))) * 1.4, max(abs(shear(1, :))) * 1.4])
line([0 beamLength], [0 0], 'Color', 'k');

%Apply Text Labels
% for(i = 1:length(sortForceXLoc))
%     if(sortForceXLoc(i) ~= 0 || beamLength)
%         txt = num2str((double(shear((sortForceXLoc(i)forceXLoc(i)/2))), 3);
%         %text(forceXLoc(1)/2, (double(shear(forceXLoc(1)/2)) + 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
%     end
% end
% txt = num2str((double(shear(forceXLoc(1)/2))), 3);
% text(forceXLoc(1)/2, (double(shear(forceXLoc(1)/2)) + 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
% txt = num2str((double(shear((forceXLoc(1)+forceXLoc(2))/2))), 3);
% text((forceXLoc(1)+forceXLoc(2))/2, (double(shear((forceXLoc(1)+forceXLoc(2))/2)) + 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
% txt = num2str((double(shear((forceXLoc(2)+beamLength)/2))), 3);
% text((forceXLoc(2)+beamLength)/2, (double(shear((forceXLoc(2)+beamLength)/2)) - 2), txt, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

%Calculate Moment
numbSteps = 2000;
moment = zeros(2, numbSteps);
x = 0;
for(i = 1:numbSteps)
    moment(1, i) = 0;
    x = (i / numbSteps) * beamLength;
    for(j = 1:length(sortAllForceMag))
        if(sortForceXLoc(j) < x)
            moment(1, i) = moment(1, i) + ((x - sortForceXLoc(j)) * sortAllForceMag(j));
        end
    end
    moment(2, i) = x;
end

%Plot Moment
subplot(3, 1, 3)
momentCurve = plot(moment(2, :), moment(1, :));

set(momentCurve, 'Color', 'b', 'LineWidth', 1);
title("Bending Moment")
xlim([0, beamLength])
ylim([-max(abs(moment(1, :))) * 1.4, max(abs(moment(1, :))) * 1.4])
line([0 beamLength], [0 0], 'Color', 'k');

%Apply Text Labels
%for(i = 1:length(sortAll
% txt = [num2str(double(moment(forceXLoc(1))), 3) ' \rightarrow'];
% thisthing = text(forceXLoc(1), double(moment(forceXLoc(1))), txt, 'HorizontalAlignment', 'right', 'Fontweight', 'bold', 'Linewidth', 10);
% txt = ['\leftarrow ' num2str(double(moment(forceXLoc(2))), 3)];
% text(forceXLoc(2), double(moment(forceXLoc(2))), txt, 'HorizontalAlignment', 'left', 'Fontweight', 'bold');
toc

