function add_opensorter_spikes(t,out_dir,verbose)

% Extract all spikes and epocs for a tank and save them

global ttank

%% Defaults and constants
if nargin < 3
    verbose=false;
end

%% Retrieve info for all blocks
blocks = tdt_blocks(t);
nblocks = length(blocks);

%% Display tank name
disp(sprintf('%s:',t.name));

%% Retrieve the spikes and epocs for each block and save
for jj = 1:nblocks
    try
        disp(sprintf('\t%s',blocks{jj}.name));
        
        % Get OpenSorter sort names, if any
        sns = sort_names(blocks{jj});
        
        for kk = 1:length(sns)
            sn = sns{kk};
            disp(sprintf('\t\t%s',sn))
            
            % Set sort name

            % Retrieve and save spikes
            spikefilename = fullfile(out_dir,[blocks{jj}.name ' spikes_' sn '.txt']);
            if exist(spikefilename,'file')
                delete(spikefilename);
            end
            if verbose
                disp(sprintf('\t\t\tExtracting spike data from tank server...'))
            end
            block_spikes = spikes(blocks{jj},sn);
            if verbose
                disp(sprintf('\t\t\tSaving spike times to file %s...',spikefilename))
            end
            dlmfile(block_spikes,spikefilename);
            if verbose
                disp(sprintf('\t\t\t\tdone'))
            end
        end
    catch
        errstring = sprintf('Error extracting block %s %s:\n%s',...
            blocks{jj}.name,t.name,lasterr);
        disp(errstring);
    end
end