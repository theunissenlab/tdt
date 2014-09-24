function [sortcodes,nsortcodes,msg] = get_sortcodes(actxname,tankname,...
    blockname,min_spikes,maxnsortcodes,channel);

% Find which sort codes have spikes for any given block in a given tank

%==========================================================================
% Initialize variables
%==========================================================================

% 'maxnsortcodes' determines how many codes to check; I don't know if TDT
% sets a maximum possible limit for this.
% Default to check for 4 sortcodes
if ~exist('maxnsortcodes','var')
    maxnsortcodes = 4;
end

% 'min_spikes' sets a minimum number of spikes that must be present for a
% given sort code before it is counted.
if ~exist('min_spikes')
    min_spikes = 10;
end

% Default to check sortcodes for all channels
if ~exist('channel')
    channel = 0;
end

sortcodes = [];
msg = '';

% Declare some equivalences for readability:
max_return = min_spikes;
event_code = 'Spik';
starttime = 0;              % Read from start of block
endtime = 0;                % Read to end of block
options = 'ALL,JUSTTIMES';  % JUSTTIMES stores the least amount of data to memory

%==========================================================================
% Query number of spikes for each sortcode from tankserver
%==========================================================================

% Connect to the server, select tank and block
block_access;

% Check whether each sortcode has at least 'min_spikes' spikes
for sortcode = 0:maxnsortcodes
    nspikes = ReadEventsV(actxname,max_return,event_code,channel,sortcode,...
        starttime,endtime,options);
    if nspikes >= min_spikes
        sortcodes = [sortcodes,sortcode];
    elseif nspikes > 0
        if channel
            msg = strvcat(msg,sprintf('Channel %i, sort code %i has %i spikes but was not included',channel,sortcode,nspikes));
        else
            msg = strvcat(msg,sprintf('Sort code %i has %i spikes but was not included',sortcode,nspikes));
        end
    end
end

% Release server
actxname.ReleaseServer;

nsortcodes = length(sortcodes);