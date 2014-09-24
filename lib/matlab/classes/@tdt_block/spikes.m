function spikes(b, spikesfilename, wavesfilename, sort_name)
%% Get spikes from a tdt_block object by querying tank server and write
%% them to file

global ttank

access(b);

ttank.ResetGlobals;
ttank.ResetFilters;

% Set sort name if any
if ~isempty(sort_name)
    ttank.SetUseSortName(sort_name);
end

channel = 0;        % Get spikes from all channels
sortcode = 0;       % Get spikes with any sortcode
start_time = 0;     % Start at beginning of block
stop_time = 0;      % Go to end of block

% Initialize spike data array
% s.time = {};
% s.sortcodes = {};
% s.channels = {};
% s.waveform = {};

% Loop through possible spike store names
possible_spike_stores = {'Spik','Snip','EA__'};
last_spike = 0;
for jj = 1:length(possible_spike_stores)
    nspikes = 0.1;
    while nspikes
        if nspikes == 0.1
            nspikes = ttank.ReadEventsV(100000,possible_spike_stores{jj},...
                channel,sortcode,start_time,stop_time,'ALL');
        else
            nspikes = ttank.ReadEventsV(100000,possible_spike_stores{jj},...
                channel,sortcode,start_time,stop_time,'NEW');
        end
        if nspikes > 0
            time = ttank.ParseEvInfoV(0,nspikes,6);
            sortcodes = ttank.ParseEvInfoV(0,nspikes,5);
            channels = ttank.ParseEvInfoV(0,nspikes,4);
            waveform = ttank.ParseEvV(0,nspikes);
            % Because of memory issues we write immediately to file
            spikeid = last_spike+1:last_spike+nspikes;            
            last_spike = last_spike + nspikes;

            fid = fopen(spikesfilename,'a');
            for is = 1:nspikes
                fprintf(fid,'%.8f\t%d\t%d\t%d\n',time(is), channels(is), spikeid(is), sortcodes(is));
            end
            fclose(fid);
            
            fid = fopen(wavesfilename,'a');
            fwrite(fid,waveform,'float32');
            fclose(fid);

        end
    end
    if last_spike
%         s = spike(cell2mat(s.time),cell2mat(s.channels),...
%             cell2mat(s.sortcodes),cell2mat(s.waveform));
        ttank.ResetGlobals;
        ttank.ResetFilters;
        ttank.ReleaseServer;
        return
    end
end

%added so that we can still export days without ephys recordings (and thus
%without spikes--RG3
% s.time = 0;
% s.sortcodes=0;
% s.channels=0;
% s.waveform=0;
% s=spike(s.time,s.channels,s.sortcodes,s.waveform);
disp('No spike stores found');
% error('No spike stores found')