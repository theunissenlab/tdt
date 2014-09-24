function s = code_spikes(b,ev_code)
%% Get spikes from a tdt_block object by querying tank server

global ttank

access(b);

channel = 0;        % Get spikes from all channels
sortcode = 0;       % Get spikes with any sortcode
start_time = 0;     % Start at beginning of block
stop_time = 0;      % Go to end of block

nspikes = 0;
for jj = 1:length(possible_spike_stores)
	nspikes = ttank.ReadEventsV(10000000,ev_code,channel,...
							    sortcode,start_time,...
							    stop_time,'ALL');
	if nspikes > 0
		s.time = ttank.ParseEvInfoV(0,nspikes,6);
		s.sortcodes = ttank.ParseEvInfoV(0,nspikes,5);
		s.channels = ttank.ParseEvInfoV(0,nspikes,4);
		s.waveform = ttank.ParseEvV(0,nspikes);
		s = spike(s.time,s.channels,s.sortcodes,s.waveform);
		ttank.ReleaseServer;
		return
	end
end

error('No spike stores found')