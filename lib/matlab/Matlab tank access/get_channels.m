function [channels,nchannels,msg] = get_channels(actxname,tankname,...
    blockname,min_spikes,maxnchannels);

% Find which sort codes have spikes for any given block in a given tank

%==========================================================================
% Initialize variables
%==========================================================================

% 'maxnchannels' determines how many codes to check; I don't know if TDT
% sets a maximum possible limit for this.
% Default to check for 4 channels
if ~exist('maxnchannels','var')
    maxnchannels = 4;
end

% 'min_spikes' sets a minimum number of spikes that must be present for a
% given sort code before it is counted.
if ~exist('min_spikes')
    min_spikes = 10;
end

channels = [];
msg = '';

% Declare some equivalences for readability:
max_return = min_spikes;
event_code = 'Spik';
sortcode = 0;               % Return all sortcodes
starttime = 0;              % Read from start of block
endtime = 0;                % Read to end of block
options = 'ALL,JUSTTIMES';  % JUSTTIMES stores the least amount of data to memory

%==========================================================================
% Query number of spikes for each channel from tankserver
%==========================================================================

% Connect to the server, select tank and block
block_access;

% Check whether each channel has at least 'min_spikes' spikes
for channel = 1:maxnchannels
    nspikes = ReadEventsV(actxname,max_return,event_code,channel,sortcode,...
        starttime,endtime,options);
    if nspikes >= min_spikes
        channels = [channels,channel];
    elseif nspikes > 0
        msg = strvcat(msg,sprintf('Channel %i has %i spikes but was not included',channel,nspikes));
    end
end

% Release server
actxname.ReleaseServer;

nchannels = length(channels);