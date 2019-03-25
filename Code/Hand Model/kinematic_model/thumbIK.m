%% Thumb IK
function Theta = thumbIK(H)
    a = 204; % Hand width, unit: mm
    b = 90; % Hand length
    
    l2 = 0.251*a;
    l3 = 0.196*a;
    l4 = 0.158*a;
    zS1 = 0.073*a;
    xS1 = -0.196*b;
    yS1 = 10;
    
    p1V = [xS1; yS1; zS1];
    pV = H(1:3,4); % position of fingertip
    nV = H(1:3,1); % orientation of fingertip
    
    rV = pV - p1V;
    rx = rV(1);
    ry = rV(2);
    rz = rV(3);
    r = norm(rV);

    r3V = pV - l4*nV - p1V;
    r3x = r3V(1);
    r3y = r3V(2);
    r3z = r3V(3);
    r3 = norm(r3V);

    t4 = pi - acos((l2^2+l3^2-r3^2)/(2*l2*l3));
    alpha = acos((l3^2+r3^2-l2^2)/(2*l3*r3));
    t5 = pi - acos((r3^2+l4^2-r^2)/(2*r3*l4)) - alpha;
    
    s4 = sin(t4);
    c4 = cos(t4);
    s5 = sin(t5);
    c5 = cos(t5);

    H34 = [c4, 0, s4, 0;...
        0, 1, 0, 0;...
        -s4, 0, c4, l2;...
        0, 0, 0, 1];
    H45 = [c5, 0, s5, 0;...
        0, 1, 0, 0;...
        -s5, 0, c5, l3;...
        0, 0, 0, 1];
    H56 = [0, 1, 0, 0;...
        0, 0, 1, 0;...
        1, 0, 0, l4;...
        0, 0, 0, 1];

    tempH = ((H/H56)/H45)/H34;
    rotH = tempH(1:3,1:3);

    t1 = atan2(rotH(2,3), rotH(1,3));
%     t3 = atan2(rotH(3,2), rotH(3,1));
    t3 = atan(rotH(3,2)/rotH(3,1));
    t2 = acos(rotH(3,3));

    Theta = rad2deg([t1, t2, t3, t4, t5]);
end