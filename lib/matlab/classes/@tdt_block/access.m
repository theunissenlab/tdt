function access(b)

% Access tank on the TDT server

global ttank
access(b.tank);

if ttank.SelectBlock(b.name) ~=1
    error('error accessing block');
end

% Create epoc indexing
ttank.ClearEpocIndexing;    %just to be safe
ttank.CreateEpocIndexing;   %this must be done before epocs can be used