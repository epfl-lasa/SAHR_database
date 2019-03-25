%% Thumb FK
function [cmc, mcp, dip, tip, H, J] = thumbFK(Theta)
% Input:
%     Theta: joint vector of thumb, 1*5
% Output:
%     cmc, mcp, dip, tip: position of joints in WCF
%     H: homogeneous transformation of thumb tip
%     J: Jacobian

    a = 204; % Hand width, unit: mm
    b = 90; % Hand length
    
    l2 = 0.251*a;
    l3 = 0.196*a;
    l4 = 0.158*a;

    zS1 = 0.073*a;
    xS1 = -0.196*b;
    yS1 = 10; % mm

    t1 = Theta(1);
    t2 = Theta(2);
    t3 = Theta(3);
    t4 = Theta(4);
    t5 = Theta(5);

    s1 = sin(t1); c1 = cos(t1);
    s2 = sin(t2); c2 = cos(t2);
    s3 = sin(t3); c3 = cos(t3);
    s4 = sin(t4); c4 = cos(t4);
    s5 = sin(t5); c5 = cos(t5);

    dT = [0, 0, 0, 0, 0];
    eT = {[0;0;1], [0;1;0], [0;0;-1], [0;1;0], [0;1;0]};
    bT = {[xS1;yS1;zS1], [0;0;0], [0;0;0], [0;0;l2], [0;0;l3], [0;0;l4]};

    H01 = [c1, -s1, 0, xS1;...
        s1, c1, 0, yS1;...
        0, 0, 1, zS1;...
        0, 0, 0, 1];
    H12 = [c2, 0, s2, 0;...
        0, 1, 0, 0;...
        -s2, 0, c2, 0;
        0, 0, 0, 1];
    H23 = [c3, s3, 0, 0;...
        -s3, c3, 0, 0;...
        0, 0, 1, 0;...
        0, 0, 0, 1];
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
    
    H = H01*H12*H23;
    cmc = H(1:3,4);
    
    H = H*H34;
    mcp = H(1:3,4);
    
    H = H*H45;
    dip = H(1:3,4);
    
    H = H*H56;
    tip = H(1:3,4);
    
    J = [cross(eT{1},(tip-cmc)), cross(eT{2},(tip-cmc)), cross(eT{3},(tip-cmc)), cross(eT{4},(tip-mcp)), cross(eT{5},(tip-dip));...
        eT{1}, eT{2}, eT{3}, eT{4}, eT{5}];
end