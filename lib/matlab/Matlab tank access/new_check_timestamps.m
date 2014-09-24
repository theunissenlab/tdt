function msg = check_timestamps(stim_epocs,epoc_name)

% Check for any corrupt timestamp data
% This was implemented to catch a problem where the TDT would save an end
% timestamp for the last epoc in the block as 0. It should, however, be
% generally useful. Basically it checks that each epoc ends after it
% starts, and that each epoc starts after the end of the previous one.

if ~exist('epoc_name','var')
    epoc_name = 'Frq+';
end
    
try
    times = stim_epocs(2:3,:);      %Generate a vector only of start and end times
    times1 = [0;times(:)];
    times2 = [times(:);inf];
    if all(times2>times1)
        msg = '';
    else
        msg = sprintf('Timestamp data for epoc %s is corrupt',epoc_name);
    end
catch
    msg = sprintf('Timestamp data for epoc %s is corrupt',epoc_name);
end