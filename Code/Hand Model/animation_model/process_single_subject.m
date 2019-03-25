function process_single_subject(HandModel, Nr)
    disp(['Subject: ', num2str(Nr)]);
    Subject = HandModel.(['P',num2str(Nr)]);
    ScrewList = Subject.ScrewList; % [10786, 15328, 22730] Starting frame number of action segment.
    % ScrewList = 22730; % Only for test
    
    for frame = ScrewList
        TrackerSet = Subject.TrackerSet.(['F',num2str(frame)]);
        disp(['  Screw Frame: ', num2str(frame)]);
        
        FileName = TrackerSet.FileName;
        pLH = TrackerSet.pLH;
        pRH = TrackerSet.pRH;
        TimeSpan = TrackerSet.TimeSpan;
        
        % Including the animation of the hand skeleton model
        hand_tracker_process(FileName, pLH, pRH, TimeSpan, 3); % 1: left hand, 2: right hand, 3: both hands
        
    end
end