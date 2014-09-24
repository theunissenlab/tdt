function [stim_times,msg] = cal_stimlengths(stim_epocs,nstims,ntrials);

% This script computes the length of the stimuli from the epoc data
% The epoc data is assumed to have each column be one epoc, which is how
% the tank server exports it. This is crucial because otherwise 'sortrows'
% will not work.
%
% Changed to handle different numbers of trials

times = stim_epocs';            %There is no dictionary sort for column data
times = sortrows(times);        %Dictionary sort puts the data in order
starts = cumsum(ntrials)-ntrials+1;
for jj = 1:nstims
    start = starts(jj);
    stop = start + ntrials(jj) -1;
    stim_times{jj}.start = times(start:stop,2);
    stim_times{jj}.end = times(start:stop,3);
    stim_times{jj}.length = stim_times{jj}.end-stim_times{jj}.start;
    if std(stim_times{jj}.length) == 0
        stim_times{jj}.length = mean(stim_times{jj}.length);
    else
        stim_times{jj}.length = median(stim_times{jj}.length);
    end
    
    %Bad timestamp data can cause negative lengths, which will give other
    %programs problems
    if stim_times{jj}.length < 0
        msg = sprintf('program has calculated a negative simulus length\n');
    else
        msg = '';
    end
end