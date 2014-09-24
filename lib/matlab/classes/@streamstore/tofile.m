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
    ttank.SetGlobalV('WavesMemLimit',2^30);
	data = ttank.ReadWavesV(s.store_name);
    ttank.ResetGlobals;
	ttank.ReleaseServer;
catch
	res = -1;
	detail = 'Error reading data from tank';
	return
end

%% Save data to file if present
if isnan(data)
	res = 0;
	detail = 'No data to write';
else
	% Create directory if necessary
	fiatdir(out_dir);
	
	% Parse output data type
	[out_dataformat,out_ext] = parse_data_form(s.data_form);
	
    % Construct file name
    filename = fullfile(out_dir,sprintf('%s %s %d stream.%s',...
                                        s.block.name,s.store_name,...
    									channel,out_ext));
    
    % Write the data to a file
    fid = fopen(filename,'w');
    try
	    fwrite(fid,data,out_dataformat);
	    fclose(fid);
	    clear data
	    res = 0;
	    detail = 'Wrote data to file';
	catch
		fclose(fid);
		clear data
		res = -1;
		detail = 'Error saving data to file';
	end
end