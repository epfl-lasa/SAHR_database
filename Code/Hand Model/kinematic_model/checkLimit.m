function theta = checkLimit(idx, theta)
% Maintain all of the joints within anthropomorphic ranges of movement
    switch idx
        case 1
            range = {[0,90], [0,60], [0,180], [0,56.3], [0,62.3]}; % CMC1, CMC2, CMC3, MCP, DIP
        	% opposite grasping: [90, 60, 180, 30, 30]
        case 2
            range = {[-30,0], [0,85.2], [0,94.8], [0,77.5]}; % ab/adduction, MCP, PIP, DIP
        case 3
            range = {[-30,0], [0,86.7], [0,88.8], [0,80.2]};
        case 4
            range = {[-30,0], [0,86.0], [0,93.2], [0,79.1]};
        case 5
            range = {[-30,0], [0,83.7], [0,90.5], [0,77.8]};
    end
    
    R = cell2mat(range);
    RL = R(1:2:end);
    RU = R(2:2:end);
    
    theta(theta<RL) = RL;
    theta(theta>RU) = RU;
end