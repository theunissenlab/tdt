function [t,e,done]=navigate_epochs(t,e,ntrials,nepochs,done)
if e==nepochs, %done all events in the trial
    e=1;
    if t==ntrials %done all trials in the block
        done=1;
    else %not done all trials, move onto next trial
        t=t+1;
    end
else %not done all events, move onto next event
    e=e+1;
end
end
