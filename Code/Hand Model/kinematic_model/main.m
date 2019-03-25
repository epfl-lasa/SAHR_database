% Constructing and visualizing the hand kinematic model.
% Reference:
% Lenarcic, Jadran, Tadej Bajd, and Michael M. Staniši. Robot mechanisms. Vol. 60. Springer Science & Business Media, 2012.
% Chapter 10: Kinematic Model of the Human Hand

close all;
clear all;
clc;

%% Assign joint angles to each finger joints to change hand pose
% Thumb finger joint angles in degree
tT = [10, 10, 10, 10, 10]; % Ab/adduction of CMC, flexion/extension of MCP, flexion/extension of DIP

% Index finger joint angles in degree
tI = [0, 20, 20, 20]; % Ab/adduction, flexion/extension: MCP, PIP, DIP

% Middle finger joint angles in degree
tM = [0, 10, 10, 10]; % Ab/adduction, flexion/extension: MCP, PIP, DIP

% Ring finger joint angles in degree
tR = [0, 10, 10, 10]; % Ab/adduction, flexion/extension: MCP, PIP, DIP

% Little finger joint angles in degree
tL = [0, 10, 10, 10]; % Ab/adduction, flexion/extension: MCP, PIP, DIP

% Plot the kinematic model
plotKinematicModel(tT, tI, tM, tR, tL);