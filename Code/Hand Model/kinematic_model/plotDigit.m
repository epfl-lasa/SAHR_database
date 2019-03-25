% Plot Finger Phalanxes
function plotDigit(mcp, pip, dip, tip, H)
% cyl: if plot cylinder (1) or not (0)

    nV = H(1:3,1)*10; % direction vector of fingertip
    sV = H(1:3,2)*25; % normal vector of finger belly
    aV = H(1:3,3)*10;
    
    ori = [0;0;0]; % Origin (palm)
    
    vec = [ori, mcp]; plot3(vec(1,:),vec(2,:),vec(3,:),'k','LineWidth',5);
    vec = [mcp, pip]; plot3(vec(1,:),vec(2,:),vec(3,:),'k','LineWidth',5);
    vec = [pip, dip]; plot3(vec(1,:),vec(2,:),vec(3,:),'k','LineWidth',5);
    vec = [dip, tip]; plot3(vec(1,:),vec(2,:),vec(3,:),'k','LineWidth',5);
    
    % Draw joints
    js = 150; % joint size
    scatter3(mcp(1),mcp(2),mcp(3),js,'filled','b');
    scatter3(pip(1),pip(2),pip(3),js,'filled','b');
    scatter3(dip(1),dip(2),dip(3),js,'filled','b');
    scatter3(tip(1),tip(2),tip(3),js,'filled','b');
    
    % Draw CF on fingertip
    lw = 2.5; % line width
    quiver3(tip(1),tip(2),tip(3),nV(1),nV(2),nV(3),'LineWidth',lw,'Color',[0 0.4470 0.7410]); % normal direction
    quiver3(tip(1),tip(2),tip(3),sV(1),sV(2),sV(3),'LineWidth',lw,'Color',[0.8500 0.3250 0.0980]); % direction of finger belly
    quiver3(tip(1),tip(2),tip(3),aV(1),aV(2),aV(3),'LineWidth',lw,'Color',[0.9290 0.6940 0.1250]);
end