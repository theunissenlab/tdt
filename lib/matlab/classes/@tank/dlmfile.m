function dlmfile(t,out_dir,spike_snippets,verbose,opensorter)

% Extract all spikes and epocs for a tank and save them

global ttank

%% Defaults and constants
if nargin < 5
    opensorter = 1;
end

if nargin < 4
    verbose = 0;
end

if nargin < 3
    spike_snippets = 0;
end

%% Retrieve info for all blocks
blocks = tdt_blocks(t);
nblocks = length(blocks);

%% Display tank name
disp(sprintf('%s:',t.name));

%% Save the block info
fiatdir([out_dir filesep]);
if verbose
    disp(sprintf('\tsaving block metadata file...'))
end
block_dlmfile(t,out_dir,false);
if verbose
    disp(sprintf('\t\tdone.'))
end

%% Retrieve the spikes and epocs for each block and save
for jj = 1:nblocks
    try
        b = blocks{jj};
        disp(sprintf('\t%s',b.name));
             
        % Save spike snippets if they're present -- causes problems if not,
        % so default to not do it.
        if spike_snippets
            % Retrieve and save spikes
            spikefilename = fullfile(out_dir,[b.name ' spikes.txt']);
            if exist(spikefilename,'file')
                delete(spikefilename);
            end
            wavesfilename = fullfile(out_dir,[b.name ' waves.f32']);
            if exist(wavesfilename,'file')
                delete(wavesfilename);
            end
            
            % Save spike arrival times and waveforms
            if verbose
                disp(sprintf('\t\tExtracting spike data from tank server...'));
                disp(sprintf('\t\tSaving spike times to file %s...',spikefilename));
                disp(sprintf('\t\tSaving spike waveforms to file %s...',wavesfilename));
            end
            
            % Spikes does not return spike objects anymore...
            sortname = [];
            spikes(b, spikefilename, wavesfilename, sortname);
            % This is the old way 
            
            % This call to dlm for class spikes use to write the spikes but
            % it is a memory pig...
            % dlmfile(block_spikes,spikefilename);
            
% Same for waveforms.  All of this is now done in spikes()
%             waveforms_file(block_spikes,wavesfilename)
%             clear block_spikes
            
            if verbose
                disp(sprintf('\t\t\tdone'));
            end
            
            % Save OpenSorter spike sorts if requested
            if opensorter
                file_pattern = [b.name ' %s spikes.txt'];
                dlm_opensorter(b,out_dir,file_pattern)
            end
        end
        
        % Retrieve and save epocs
        if verbose
            disp(sprintf('\t\tExtracting epoc data from tank server...'))
        end
        block_epocs = all_epocs(blocks{jj});
        
        for kk = 1:length(block_epocs)
            epocfilename = fullfile(out_dir,...
                [b.name ' epoc ' block_epocs{kk}.name '.txt']);
            if exist(epocfilename,'file')
                delete(epocfilename);
            end
            
            if verbose
                disp(sprintf('\t\t\tsaving data for epoc ''%s'' to file %s',...
                             block_epocs{kk}.name,epocfilename))
            end
            dlmfile(block_epocs{kk},epocfilename);
        end
        if verbose
            disp(sprintf('\t\t\tdone'))
        end
        clear block_epocs
        
        % Retrieve and save streamed waveform data
        % Added 7/29/09 RCM
        ttank.ResetFilters
        if verbose
           disp(sprintf('\t\tProcessing streamed data...'))
        end
        block_streams = streams(b);
        for kk = 1:length(block_streams)
            if verbose
                disp(sprintf('\t\t\tsaving stream %s...',block_streams{kk}.store_name))
            end
            all_to_file(block_streams{kk},out_dir);
        end
        if verbose
            disp(sprintf('\t\t\tdone'))
        end
        
        % Retrieve and save scalar data
        % Added 06/13/11 FET and JEE
        
        if verbose
           disp(sprintf('\t\tProcessing scalar data...'))
        end
        block_scalars = scalars(b);
        for kk = 1:length(block_scalars)
            if verbose
                disp(sprintf('\t\t\tsaving scalar %s...',block_scalars{kk}.store_name))
            end
            all_to_file(block_scalars{kk},out_dir);
        end
        if verbose
            if isempty(block_scalars)
                disp(sprintf('\t\t\tNo scalar data in block'));
            end
            disp(sprintf('\t\t\tdone'))
        end
        
    catch
        errstring = sprintf('Error extracting block %s %s:\n%s',...
            blocks{jj}.name,t.name,lasterr);
        disp(errstring);
    end
end