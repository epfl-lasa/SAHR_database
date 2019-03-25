%% Fingers IK
% Given: p, n
function TF = fingerIK(idx, H, cpl)
    % idx: 2 - 5: index, middle, ring, little. If missing: calculate full IK.
    % pV: 3D position of the fingertip in MCP CF
    % nV: direction of distal
    % cpl: if true, use the coupling relationship between PIP and DIP to simplify the calculation: t4 = c*t3. Otherwise do normal calculation.

    a = 204; % Hand width, unit: mm
    b = 90; % Hand length
    
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

    p1V = [xS1; yS1; zS1];
    pV = H(1:3,4);
    nV = H(1:3,1);
    r3V = pV - l4*nV - p1V;

    r3 = norm(r3V);
    r3x = r3V(1);
    r3y = r3V(2);
    r3z = r3V(3);
    r3xz = norm([r3x, r3z]);

    nx = nV(1);
    ny = nV(2);
    nz = nV(3);
    nxz = norm([nx, nz]);

    t1 = atan(nx/nz); % theta 1
    t3 = pi - acos((l2^2+l3^2-r3^2)/(2*l2*l3)); % theta 3
    t2 = atan(r3y/r3xz) - acos((r3^2+l2^2-l3^2)/(2*r3*l2)); % theta 2
    
    if cpl % If use synergy to simplify computation
        c = [0.32, 0.36, 0.16, 0.25]; % index, middle, ring, little
        t4 = c(idx-1)*t3;
    else
        t4 = atan(ny/nxz) - (t2+t3); % theta 4
    end

    TF = rad2deg([t1, t2, t3, t4]);
end