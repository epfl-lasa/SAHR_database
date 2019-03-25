clear all;
close all;
clc;
warning('off');

HandModel = load([pwd,'/data/HandModel.mat']);
HandModel = HandModel.HandModel;

% Example: subject 24
process_single_subject(HandModel, 24);
