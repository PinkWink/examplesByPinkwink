syms th1 th2 nx ny nz ox oy oz ax ay az Px Py Pz a1 a2

RotZ1 = [cos(th1) -sin(th1) 0 0; sin(th1) cos(th1) 0 0; 0 0 1 0; 0 0 0 1]
RotZ2 = [cos(th2) -sin(th2) 0 0; sin(th2) cos(th2) 0 0; 0 0 1 0; 0 0 0 1]

TransA1 = [1 0 0 a1; 0 1 0 0; 0 0 1 0; 0 0 0 1]
TransA2 = [1 0 0 a2; 0 1 0 0; 0 0 1 0; 0 0 0 1]

T_0_2 = RotZ1*TransA1*RotZ2*TransA2
TT = [nx ox ax Px; ny oy ay Py; nz oz az Pz; 0 0 0 1]

% Left Step 1
LS1 = simplify(inv(RotZ1)*TT)

% Right Step 1
RS1 = simplify(inv(RotZ1)*T_0_2)
%%
a1 = 15;
a2 = 15;
Px = -20;
Py = 15;
th2 = [2*atan((((a1+a2)^2-(Px^2+Py^2))/(Px^2+Py^2-(a1-a2)^2))^0.5) -2*atan((((a1+a2)^2-(Px^2+Py^2))/(Px^2+Py^2-(a1-a2)^2))^0.5)]
th1 = atan2(Py,Px) - atan(a2*sin(th2)./(a1+a2*cos(th2)))

%%
% DH Table
%      |  theta   d    a    alpha
% ---------------------------------
%    1 |  theta1  0    a1     0
%    2 |  theta2  0    a2     0
RotZ = @(theta) [cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0 ; 0 0 0 1];
Trans = @(x, y, z) [1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1];

for i=1:2   
    theta1 = th1(i);
    theta2 = th2(i);
    
    T_0_1 = RotZ(theta1)*Trans(a1, 0, 0);
    T_1_2 = RotZ(theta2)*Trans(a2, 0, 0);
    T_total = T_0_1*T_1_2;
    
    y0 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    y0_1 = T_0_1 * y0;
    y0_2 = T_total * y0;
    
    originX = [y0(1,4), y0_1(1,4), y0_2(1,4)];
    originY = [y0(2,4), y0_1(2,4), y0_2(2,4)];
    
    figure
    plot(originX, originY, '*--', 'linewidth', 2);
    axis([min([originX, originY])-4, max([originX, originY])+4, min([originX, originY])-4, max([originX, originY])+4])
    grid on
    axis square
    
    axisY0X = y0(1, 1:2);
    axisY0_1X = y0_1(1, 1:2);
    axisY0_2X = y0_2(1, 1:2);
    
    axisY0Y = y0(2, 1:2);
    axisY0_1Y = y0_1(2, 1:2);
    axisY0_2Y = y0_2(2, 1:2);
    
    line([originX(1), axisY0X(1)], [originY(1), axisY0Y(1)], 'color', 'r', 'linewidth', 3);
    line([originX(1), axisY0X(2)], [originY(1), axisY0Y(2)], 'color', 'g', 'linewidth', 3);
    
    line([originX(2), originX(2)+axisY0_1X(1)], [originY(2), originY(2)+axisY0_1Y(1)], 'color', 'r', 'linewidth', 3);
    line([originX(2), originX(2)+axisY0_1X(2)], [originY(2), originY(2)+axisY0_1Y(2)], 'color', 'g', 'linewidth', 3);
    
    line([originX(3), originX(3)+axisY0_2X(1)], [originY(3), originY(3)+axisY0_2Y(1)], 'color', 'r', 'linewidth', 3);
    line([originX(3), originX(3)+axisY0_2X(2)], [originY(3), originY(3)+axisY0_2Y(2)], 'color', 'g', 'linewidth', 3);
    
    xPol = [1, 2, 1, 1];
    yPol = [1, 1, 2, 1];
    pol0 = [xPol; yPol; [0 0 0 0]; [1 1 1 1]];
    pol0_1 = T_0_1*pol0;
    pol0_2 = T_total*pol0;
    
    line(xPol, yPol, 'color', 'k', 'linewidth', 2);
    line(pol0_1(1,:), pol0_1(2,:), 'color', 'k', 'linewidth', 2);
    line(pol0_2(1,:), pol0_2(2,:), 'color', 'k', 'linewidth', 2);
end

