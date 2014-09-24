function [stim_times,msg] = cal_stim_times(stim_epocs,stim_number)

% This script computes the length of the stimuli from the epoc data
% The epoc data is assumed to have each column be one epoc, which is how
% the tank server exports it. This is crucial because otherwise 'sortrows'
% will not work.

stim_numbers = stim_epocs(1,:);
start_times = stim_epocs(2,:);
end_times = stim_epocs(3,:);

epoc_indices = find(stim_numbers == stim_number);
ntrials = length(epoc_indices);

stim_times.start = start_times(epoc_indices);
stim_times.end = end_times(epoc_indices);

stim_times.length = stim_times.end-stim_times.start;

if std(stim_times.length) == 0
    stim_times.length = mean(stim_times.length);
else
    stim_times.length = median(stim_times.length);
end

%Bad timestamp data can cause negative lengths, which will give other
%programs problems
if stim_times.length < 0
    msg = sprintf('program has calculated a negative simulus length\n');
else
    msg = '';
end