function plotKinematicModel(tT, tI, tM, tR, tL)
% Plotting kinematic model of full hand
% tT: joint angles for thumb (1,5)
% tI/tM/tR/tL: joint angles for Index/Middle/Ring/Little (1,4) for each
% tT: converted thumb joint angles
% tF: converted finger joint angles (I,M,R,L)
if nargin >= 5 % all fingers have different joints
	tT = deg2rad(tT);
    tF = {deg2rad(tI), deg2rad(tM), deg2rad(tR), deg2rad(tL)};
elseif nargin == 2 % all fingers have the same joint
	tT = deg2rad(tT);
    tF = repmat({deg2rad(tI)},1,4);
elseif nargin == 1
	tT = deg2rad(tT);
	tF = repmat({zeros(1,4)},1,4);
else
	tT = zeros(1,5); % CMC1, CMC2, CMC3, MCP, DIP
    tF = repmat({zeros(1,4)},1,4); % Ab/adduction, MCP, PIP, DIP
end

palm_f = [0;0;0]; % palm, a convex hull constructed by fingertips and origin
palm_t = [0;0;0]; % palm, a convex hull constructed by thumb and origin
g_poly = []; % grasp polyhedron

figure, hold on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
view(160,20);

scatter3(0,0,0,100,'filled','r'); % Origin
quiver3(0,0,0,25,0,0,'LineWidth',2.5,'Color','r'); % X-axis of palm
quiver3(0,0,0,0,25,0,'LineWidth',2.5,'Color','g'); % Y-axis of palm
quiver3(0,0,0,0,0,25,'LineWidth',2.5,'Color','b'); % Z-axis of palm

mcpCell = cell(1,5);
pipCell = cell(1,5);
dipCell = cell(1,5);
tipCell = cell(1,5);

HCell = cell(1,5);
JCell = cell(1,5);

%% Fingers
for idx = 2:5
	theta = tF{idx-1};
    
    % theta = checkLimit(idx, theta);
    [mcp, pip, dip, tip, H, J] = fingerFK(idx, theta);
    % tF_IK = fingerIK(idx, H, false); % Test IK
    
    mcpCell{idx} = mcp;
    pipCell{idx} = pip;
    dipCell{idx} = dip;
    tipCell{idx} = tip;
    
    HCell{idx} = H;
    JCell{idx} = J;
    
    plotDigit(mcp, pip, dip, tip, H); % plot fingers
    
    palm_f = [palm_f, mcp];
    g_poly = [g_poly, tip]; % grasping polyhedron
end

%% Thumb
idx = 1;
% tT = checkLimit(1, tT);
[cmc, mcp, dip, tip, H, J] = thumbFK(tT);
% tT_IK = thumbIK(H); % IK solution

mcpCell{idx} = cmc; % For thumb, cmc is saved as mcp
pipCell{idx} = mcp; % For thumb, mcp is saved as pip
dipCell{idx} = dip;
tipCell{idx} = tip;

HCell{idx} = H;
JCell{idx} = J;

plotDigit(cmc, mcp, dip, tip, H); % plot thumb

palm_f = [palm_f, cmc];
palm_t = [palm_t, palm_f(:,2), cmc, mcp];
g_poly = [g_poly, tip];

%% Plot Convex Hull: Palm of Fingers
palm_f = palm_f';
K_f = convhulln(palm_f);
h_f = trisurf(K_f,palm_f(:,1),palm_f(:,2),palm_f(:,3)); % plot palm
set(h_f, 'FaceColor', [148,95,81]/255);

%% Plot Convex Hull: Palm of Thumb
palm_t = palm_t';
K_t = convhulln(palm_t);
h_t = trisurf(K_t,palm_t(:,1),palm_t(:,2),palm_t(:,3)); % plot palm
set(h_t, 'FaceColor', [196,144,124]/255);

hold off;
rotate3d('on');

%% Automatically rotate 3D plot
for i=1:2:360
    view(i,20);
    pause(0.06);
end

model.mcp = mcpCell;
model.pip = pipCell;
model.dip = dipCell;
model.tip = tipCell;
model.HCell = HCell;
model.JCell = JCell;
end