function [res,detail] = tofile(s,out_dir,channel)
% Write streamed data to file

%% Defaults, globals, setup
global ttank

%% Fetch data from tank server

% Open block for access
access(s.block)

% Read data for this channel
try
	ttank.SetGlobalV('Channel',channel);
	nevents = ttank.ReadEventsSimple(s.store_name);
    value=ttank.ParseEvV(0,nevents);
    eventTime = ttank.ParseEvInfoV(0, nevents, 6);   % 6 is to get out the Time Stamp. See Open Developper Manual.
    ttank.ResetGlobals;
	ttank.ReleaseServer;
catch
	res = -1;
	detail = 'Error reading data from tank';
	return
end

%% Save data to file if present
if nevents == 0
	res = 0;
	detail = 'No data to write';
else
	% Create directory if necessary
	fiatdir(out_dir);
		
    % Construct file name
    filename = fullfile(out_dir,sprintf('%s %s %d scalar.txt',...
                                        s.block.name,s.store_name,...
    									channel));
    
    % Write the data to a file
 
    try
        delimiter = '\t';
        out_data = zeros(nevents,2);
        out_data(:,1) = value;
        out_data(:,2) = eventTime;
        dlmwrite(filename,out_data,'delimiter',delimiter,'precision','%.8f')
        res = nevents;
	    detail = 'Wrote data to file';
	catch
		res = -1;
		detail = 'Error saving data to file';
	end
end