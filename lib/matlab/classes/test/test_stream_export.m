function [res,detail] = test_stream_export()
% Test data export for stream store

global ttank

temp_dir = getenv('TMP');
tanknames = {'BlaW0603','BluW3805'};
blocknames = {'loc 4 depth 3205'};
storenames = {'PDec','LFPs','Stim'};

nblocks = length(blocknames);
nstores = length(storenames);

results = logical(zeros(nblocks,nstores,256));

for jj = 1:nblocks
	t = tank(tanknames{jj});
	b = tdt_block(blocknames{jj},t);
	
	for kk = 1:nstores
		% Export all channels from the stream
		s = stream(b,storenames{kk});
		out_dir = fullfile(temp_dir,b.name);
		mkdir(out_dir);
		all_to_file(s,out_dir);
		
		[data_form,file_ext,typename] = parse_data_form(s.data_form);
		
		% For each channel, fetch the data from the server and see if it matches in a file
		for mm = 1:256
			% Get data from server
			access(b);
			ttank.SetGlobalV('Channel',mm);
			data = ttank.ReadWavesV(s.store_name);
			ttank.ReleaseServer;
			
			% Create filename
			filename = fullfile(out_dir,sprintf('%s %s %d stream.%s',...
									s.block.name,s.store_name,mm,file_ext));
			
			% Read data from file
			if isnan(data)
				results(jj,kk,mm) = ~exist(filename);
			else
				fid = fopen(filename);
				file_data = fread(fid,data_form);
				if size(data) == size(file_data)
					results(jj,kk,mm) = all(cast(data,typename) == cast(file_data,typename));
				elseif size(data) == size(file_data')
					results(jj,kk,mm) = all(cast(data,typename) == cast(file_data',typename));
				else
					results(jj,kk,mm) = false;
                end
			end
		end
	end
end
res = all(all(results));
detail = results;