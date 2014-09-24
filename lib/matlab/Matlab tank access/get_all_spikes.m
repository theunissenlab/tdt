function [timestamps,sortcodes,channels,spikes] = get_all_spikes(...
    actxname,tankname,blockname,option)

% Retrieve all spikes from a block

% Connect to the server, select tank and block
block_access;

% Define arguments
channel = 0;        % Get spikes from all channels
sortcode = 0;       % Get spikes with any sortcode
start_time = 0;     % Start at beginning of block
stop_time = 0;      % Go to end of block

nspikes = actxname.ReadEventsV(10000000,'Spik',channel,sortcode,start_time,...
    stop_time,'ALL');
timestamps = actxname.ParseEvInfoV(0,nspikes,6);
sortcodes = actxname.ParseEvInfoV(0,nspikes,5);
channels = actxname.ParseEvInfoV(0,nspikes,4);
spikes = actxname.ParseEvV(0,nspikes);

actxname.ReleaseServer;