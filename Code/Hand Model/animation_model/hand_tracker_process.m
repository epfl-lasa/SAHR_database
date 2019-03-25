function hand_tracker_process(file_name, pLH, pRH, TimeSpan, suffix)
% Example: hand_tracker_process(file_name, pLH, pRH, TimeSpan)
% Process the raw data of hand trackers. Plot the raw data, animate the motion, and save the results.
% TimeSpan = [frameS, frameE]: starting frame number & ending frame number
% suffix: indicating the individual files for both hands: {'_L'}, {'_R'}, {'L','R'}.
close all;
data_path = [pwd,'/data/vision/'];
switch suffix
    case 0
        dataR = dlmread([data_path, file_name, '.txt'], '\t', 2, 0); % only right hand
        dataL = dataR;
    case 1 % Left hand only
        dataL = dlmread([data_path, file_name, '_L', '.txt'], '\t', 2, 0); % Col.(1-5): [TrackerID, Frame, X, Y, Z]
        dataR = dataL;
    case 2 % Right hand only
        dataR = dlmread([data_path, file_name, '_R', '.txt'], '\t', 2, 0); % Col.(1-5): [TrackerID, Frame, X, Y, Z]
        dataL = dataR;
    case 3
        dataL = dlmread([data_path, file_name, '_L', '.txt'], '\t', 2, 0); % Col.(1-5): [TrackerID, Frame, X, Y, Z]
        dataR = dlmread([data_path, file_name, '_R', '.txt'], '\t', 2, 0); % Col.(1-5): [TrackerID, Frame, X, Y, Z]
end

% TrackerID = raw_data(:,1); Frame = raw_data(:,2); dataX = raw_data(:,3); dataY = raw_data(:,4); dataZ = raw_data(:,5);
% Nt = max(TrackerID)+1; % Number of trackers, should be 25 for a single hand. Notice: only denote the max tracker number! Does not necessarily equals the number of valid trackers.
% N_frame = max(Frame)+1; % max time frame length

Nt = 25; % number of trackers, single Hand
TrajLH = cell(1, Nt); % each cell saves one tracker sequence
TrajRH = cell(1, Nt);
% FrameSet = cell(1, N_frame); % save raw data frame-wise. size is the total num of frame, each cell saves the 3D pos of all the trackers

TrackerID = dataL(:,1);
for i = 1:Nt
    % disp(['Tracker: ', num2str(Nt), ' Number: ', num2str(sum(TrackerID==i-1))]);
    TrajLH{i} = dataL(TrackerID==i-1, 2:end); % ith tracker: TrackerTrajectory{i} = [Frame(0:N_frame-1), X, Y, Z], (Nframe*4)
    TrajRH{i} = dataR(TrackerID==i-1, 2:end);
end

TrajLH = validate_trajectory(TrajLH, TimeSpan); % Remove invalid trajectory positions (-1) by interpolation
TrajRH = validate_trajectory(TrajRH, TimeSpan); % Remove invalid trajectory positions (-1) by interpolation

TrajLH = manual_correction(TrajLH, 24, 'L'); % Manual correction
TrajRH = manual_correction(TrajRH, 24, 'R'); % Manual correction

TrajComplete = [TrajLH, TrajRH]; % traj of both hands

% plot3_trajectories(TrajComplete, true); % Plot raw 3D trajectory
close all;

animate_trajectories(TimeSpan, pLH, pRH, TrajComplete); % Animate trajectories with time

end





function TrackerTrajectory = validate_trajectory(TrackerTrajectory, TimeSpan)
% Remove the invalid trajectory elements (i.e. out of frame, 9999).

    Nt = length(TrackerTrajectory); % 50
    pValid = zeros(Nt,3); % save the last frame non-9999 position before meet a 9999 position
    
    for t = 1:Nt % 1:25
        data = TrackerTrajectory{t}; % data size: (N_frame, 4)
        
        % Explanation: data length equals the whole length of the video.
        % Therefore, data frame corresponds the video frame.
        data = data(TimeSpan(1):TimeSpan(2), 2:end);
        % data = data(:, 2:end); % 1st col is time. Only takes [X, Y, Z]
        
        pValid(t,:) = data(1,:);
        if ismember(9999, pValid(t,:))
            % disp(['Outlier exists in original frame: ', num2str(t)]);
            pValid(t, pValid(t,:)==9999) = 0; % Temporary solution: move to origin
        end
        
        for f = 1:TimeSpan(2)-TimeSpan(1)+1 % Check each frame
            for a = 1:3 % Check X, Y, Z axes
                if data(f,a) == 9999
                    data(f,a) = pValid(t,a); % replace invalid trajectory with saved previous valid one
                else
                    pValid(t,a) = data(f,a); % update saved valid trajectory
                end
            end
        end
        
        if ismember(9999, data)
            disp('Out-of-frame data exists.');
        end
            
        TrackerTrajectory{t} = data;
    end
end


function TrackerTrajectory = manual_correction(TrackerTrajectory, Nr, side)
    switch Nr
        case 24 % For P24
            if isequal(side, 'L')
                % Thumb is missing
                missing_tracker = [1,2,3,4,21,22,23,24]; %% 21, 22 are available. but to simplify the plot, deactivate their plotting.
                for i = missing_tracker
                    TrackerTrajectory{i} = TrackerTrajectory{25}; % (N, 3)
                end
                len = size(TrackerTrajectory{25},1);
                TrackerTrajectory{1} = repmat([-0.25,-1.2, 0.12],len,1); % Approximated value
                TrackerTrajectory{2} = repmat([-0.45,-1.3, 0.13],len,1); % Approximated value
                TrackerTrajectory{3} = repmat([-0.75,-1.35,0.14],len,1); % Approximated value
                TrackerTrajectory{4} = repmat([-0.95,-1.3,  0.2],len,1); % Approximated value
            elseif isequal(side, 'R') % 25 is center
                missing_tracker = [4,21,22,23,24];
                for i = missing_tracker
                    TrackerTrajectory{i} = TrackerTrajectory{25};
                end
                TrackerTrajectory{6} = (TrackerTrajectory{5} + TrackerTrajectory{7})/2;
            end
    end
end




%% Animation of 3D joint trajectories
function M = animate_trajectories(TimeSpan, pLH, pRH, TrackerTrajectory)
% 'hand': 'L', only plot left hand. 'R', only plot right hand. 'B', both.
% 'TrackerTrajectory': should be a concatanation of both hands. 1:25: left, 26:end right.
    
    Nt = length(TrackerTrajectory); % 'Nt': Number of Tracker, 50
    TrajLH = TrackerTrajectory(1:25);
    TrajRH = TrackerTrajectory(26:50);
    
    figure;
    hold on;
    view(180,15);
    pause(5.0);
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title([num2str(TimeSpan(1)), '-', num2str(TimeSpan(2))]);
    
    % trajectory = animatedline('LineWidth',2);
    % Set the liminations for axes
    minVec = zeros(Nt,3); % [Xmin Ymin Zmin]
    maxVec = zeros(Nt,3); % [Xmax Ymax Zmax]
    for t = 1:Nt
        data = TrackerTrajectory{t}; % (N, 3)
        minVec(t,:) = min(data);
        maxVec(t,:) = max(data);
    end
    minLim = min(minVec)-0.25;
    maxLim = max(maxVec)+0.25;
    set(gca,'XLim',[minLim(1),maxLim(1)],'YLim',[minLim(2),maxLim(2)],'ZLim',[minLim(3),maxLim(3)]);
    
    % Plot the environment
    % left index fingertip
    idxLtip = 5+25;
    X1 = TrackerTrajectory{idxLtip}(end,:); % assume the end frame is not zero
    X2 = X1; X2(3) = X2(3)-1;
    Cylinder(X1,X2,0.05,10,'b',1,0);
    
    % Generate color list
    c_step = 1/(Nt-1);
    ColorList = mat2cell([0:c_step:1; 1:-c_step:0; 0:c_step:1]', [ones(1,Nt)], [3]);
    
    for i = 1:TimeSpan(2)-TimeSpan(1)+1 % total frame length
        % disp(num2str(i));
        % addpoints(trajectory,dataX(i),dataY(i),dataZ(i)); % plot historical trajectories
        h_tracker = cell(1,Nt);
        % h_text = cell(1,Nt); % test tracker numbers
        
        % Plot all tracker positions
        for t = 1:Nt % number of tracker, 50
            Tracker = TrackerTrajectory{t};
            h_tracker{t} = scatter3(Tracker(i,1), Tracker(i,2), Tracker(i,3), 50, ColorList{t}, 'filled');
            % h_text{t} = text(Tracker(i,1), Tracker(i,2), Tracker(i,3)+0.15, ['T',num2str(t)], 'FontSize', 12);
        end
        % Plot all phalanges of hands
        [hLT, hLI, hLM, hLR, hLL, hLText] = plot_single_hand_skeleton_models(TrajLH, pLH, i);
        [hRT, hRI, hRM, hRR, hRL, hRText] = plot_single_hand_skeleton_models(TrajRH, pRH, i);
        
        % Plot center point of hand
        idxPalm = 25; % center of the hand is the 25 th tracker
        if pLH(idxPalm) %            ; corresponding tracker is not empty
            hLCenter = scatter3(TrajLH{pLH(idxPalm)}(i,1), TrajLH{pLH(idxPalm)}(i,2), TrajLH{pLH(idxPalm)}(i,3), 50, 'k', 'filled');
            hLCenterText = text(TrajLH{pLH(idxPalm)}(i,1), TrajLH{pLH(idxPalm)}(i,2), TrajLH{pLH(idxPalm)}(i,3)+0.15, 'Left', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'r');
        end
        if pRH(idxPalm) % corresponding tracker is not empty
            hRCenter = scatter3(TrajRH{pRH(idxPalm)}(i,1), TrajRH{pRH(idxPalm)}(i,2), TrajRH{pRH(idxPalm)}(i,3), 50, 'k', 'filled');
            hRCenterText = text(TrajRH{pRH(idxPalm)}(i,1), TrajRH{pRH(idxPalm)}(i,2), TrajRH{pRH(idxPalm)}(i,3)+0.15, 'Right', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'r');
        end
        
        drawnow
        M(i) = getframe;
        pause(0.0001);
        
        % Clear all trackers
        for t = 1:Nt
            delete(h_tracker{t});
            % delete(h_text{t});
        end
        
        % Clear all phalanegs
        for p = 1:4 % each finger has 4 phalanges in total
            delete(hLT{p}); delete(hLI{p}); delete(hLM{p}); delete(hLR{p}); delete(hLL{p});
            delete(hRT{p}); delete(hRI{p}); delete(hRM{p}); delete(hRR{p}); delete(hRL{p});
        end
        
        % Clear all texts
        for t = 1:5
            delete(hLText{t});
            delete(hRText{t});
        end
        
        % Clear center point
        if exist('hLCenter', 'var')
            delete(hLCenter);
            delete(hLCenterText);
        end
        if exist('hRCenter', 'var')
            delete(hRCenter);
            delete(hRCenterText);
        end

    end
end





%% Plot original 3D data
function plot3_trajectories(data, is_traj)
    % is_traj: if input data is trajectory data (full length as videos, contains 9999s)
    
    figure;
    hold on;
    view(45,25);
    
    if is_traj
        Nt = length(data); % number of trackers
        for i = 1:Nt
            temp_data = data{i};
            scatter3(temp_data(:,1),temp_data(:,2),temp_data(:,3));
            hold on;
        end
    else % pre-process (validated trajectories)
        TrackerID = data(:,1);
        Nt = max(TrackerID)+1;

        for i = 1:Nt
            temp_data = data(TrackerID==i, 3:end); % X, Y, Z, (Nframe*3)
            if length(TrackerID)/Nt ~= length(temp_data)
                error('Tracker size does not match.');
            end
            scatter3(temp_data(:,1),temp_data(:,2),temp_data(:,3));
            hold on;
        end
    end
    
    legend;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Visualization of Original Tracker Data');
    hold off;
end





function [hT, hI, hM, hR, hL, hText] = plot_single_hand_skeleton_models(TrackerTrajectory, posList, Nf)
    phaT = {[ 1, 2], [ 2, 3], [ 3, 4], [ 4,25]}; % Thumb % 4 for each finger: Distal, Middle, Proximal, Metacarpals; for Thumb, Carpo
    phaI = {[ 5, 6], [ 6, 7], [ 7, 8], [ 8,25]}; % Index
    phaM = {[ 9,10], [10,11], [11,12], [12,25]}; % Middle
    phaR = {[13,14], [14,15], [15,16], [16,25]}; % Ring
    phaL = {[17,18], [18,19], [19,20], [20,25]}; % Little

    hT = cell(1,4);
    hI = cell(1,4);
    hM = cell(1,4);
    hR = cell(1,4);
    hL = cell(1,4);
    
    hText = cell(1,5); % Fingers Names

    for p = 1:4
        hT{p} = plot_phalange(posList(phaT{p}(1)), posList(phaT{p}(2)), TrackerTrajectory, Nf);
        hI{p} = plot_phalange(posList(phaI{p}(1)), posList(phaI{p}(2)), TrackerTrajectory, Nf);
        hM{p} = plot_phalange(posList(phaM{p}(1)), posList(phaM{p}(2)), TrackerTrajectory, Nf);
        hR{p} = plot_phalange(posList(phaR{p}(1)), posList(phaR{p}(2)), TrackerTrajectory, Nf);
        hL{p} = plot_phalange(posList(phaL{p}(1)), posList(phaL{p}(2)), TrackerTrajectory, Nf);
    end
    
    TextIdxList = [1,5,9,13,17]; % 1st, 5th, 9th, 13th, 17th trackers are fingertips
    % TextList = {'Thumb', 'Index', 'Middle', 'Ring', 'Little'};
    TextList = {'T', 'I', 'M', 'R', 'L'};
    
    for t = 1:5
        if posList(TextIdxList(t)) % not 0, means corresponding tracker exist in the tracking results
            pos = TrackerTrajectory{posList(TextIdxList(t))}(Nf,:);
            if ismember(9999, pos) % in case some points out of the scope
                hText{t} = '9999';
            else
                hText{t} = text(pos(1), pos(2), pos(3)+0.1, TextList{t}, 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'r');
            end
        else
            hText{t} = '0000';
        end
    end
end





function h = plot_phalange(tA, tB, TrackerTrajectory, Nf)
    % tA, tB: index of tracker A and tracker B
    if ~(tA && tB) % tracker does not exist
        h = '';
    else
        posA = TrackerTrajectory{tA}(Nf,:);
        posB = TrackerTrajectory{tB}(Nf,:);
        vec = [posA;posB];
        if ismember(9999, vec) % in case some points out of the scope
            h = '';
        else
            h = plot3(vec(:,1),vec(:,2),vec(:,3),'k','LineWidth',5);
        end
    end
end