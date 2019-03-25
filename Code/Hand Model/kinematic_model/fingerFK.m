%% Fingers FK
function [mcp, pip, dip, tip, H, J] = fingerFK(idx, Theta)
% Calculate the forward kinematics of finger.
% Input:
%     idx: 2 - 5: index, middle, ring, little
%     Theta: vector of finger joint angles
% Output:
%     mcp, pip, dip, tip: position of joint in WCF (World CF = Hand CF)
%     H: Homogeneous TF matrix of fingertip
%     J: Jacobian
    
    a = 204; % Hand width, unit: mm
    b = 90; % Hand length
    t1 = Theta(1); % theta_1 | theta_2 | theta_3 | theta_4
    t2 = Theta(2);
    t3 = Theta(3);
    t4 = Theta(4);
    s1 = sin(t1); c1 = cos(t1);
    s2 = sin(t2); c2 = cos(t2);
    s3 = sin(t3); c3 = cos(t3);
    s4 = sin(t4); c4 = cos(t4);
    
    % Finger parameters: l2, l3, l4, xS1, zS1
    switch idx
        case 2
            param = [a*0.245, a*0.143, a*0.097,-b*0.251, a*0.447]; % Finger: Index
        case 3
            param = [a*0.266, a*0.170, a*0.108, b*0.000, a*0.446]; % Finger: Middle
        case 4
            param = [a*0.244, a*0.165, a*0.107, b*0.206, a*0.409]; % Finger: Ring
        case 5
            param = [a*0.204, a*0.117, a*0.093, b*0.402, a*0.368]; % Finger: Little
    end
    
    l2 = param(1);
    l3 = param(2);
    l4 = param(3);
    xS1 = param(4);
    zS1 = param(5);
    yS1 = 0;
    
    dF = [0, 0, 0, 0];
    eF = {[0;-1;0], [-1;0;0], [-1;0;0], [-1;0;0]};
    bF = {[xS1;yS1;zS1], [0;0;0], [0;0;l2], [0;0;l3], [0;0;l4]};
    
    H01 = [c1, 0, -s1, xS1;...
        0, 1, 0, yS1;...
        s1, 0, c1, zS1;...
        0, 0, 0, 1];
    H12 = [1, 0, 0, 0;...
        0, c2, s2, 0;...
        0, -s2, c2, 0;...
        0, 0, 0, 1];
    H23 = [1, 0, 0, 0;...
        0, c3, s3, 0;...
        0, -s3, c3, l2;...
        0, 0, 0, 1];
    H34 = [1, 0, 0, 0;...
        0, c4, s4, 0;...
        0, -s4, c4, l3;...
        0, 0, 0, 1];
    H45 = [0, 0, -1, 0;...
        0, 1, 0, 0;...
        1, 0, 0, l4;...
        0, 0, 0, 1];

    H = H01*H12;
    mcp = H(1:3,4); % 3d position of MCP joint
    
    H = H*H23;
    pip = H(1:3,4); % 3d position of PIP joint
    
    H = H*H34;
    dip = H(1:3,4); % 3d position of DIP joint
    
    H = H*H45;
    tip = H(1:3,4); % finger tip
    
    J = [cross(eF{1},(tip-mcp)), cross(eF{2},(tip-mcp)), cross(eF{3},(tip-pip)), cross(eF{4},(tip-dip));...
        eF{1}, eF{2}, eF{3}, eF{4}]; % Jacobian
end