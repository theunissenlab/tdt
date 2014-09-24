function digest_tank(tank_in,out_dir)

% Extract all spikes and epocs for a tank and save them

global ttank

%% Retrieve info for all blocks
blocks = tdt_blocks(tank_in);
nblocks = length(blocks);

%% Display tank name
disp(sprintf('%s:',tank_in.name));

%% Retrieve the spikes and epocs for each block and save
for jj = 1:nblocks
    try
        disp(sprintf('\t%s',blocks{jj}.name));
        block_spikes = spikes(blocks{jj});
        block_epocs = all_epocs(blocks{jj});
        outfile = fullfile(out_dir,[blocks{jj}.name '.mat']);
        save(outfile,'block_spikes','block_epocs');
    catch
        errstring = sprintf('Error extracting block %s %s:\n%s',...
            blocks{jj}.name,tank_in.name,lasterr);
        disp(errstring);
    end
end