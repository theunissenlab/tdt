function [cellname,depth,stimset,notes] = parse_blockname(blockname,stimsets)

%========================================================================
% This function pulls the cell number, depth, and stimulus set from the
% block name input. Block name input is assumed to be in the form 'cell
% <cellnum> depth <depth> <stimset>'. It is designed to be insensitive to
% the case of the first letter of the strings 'cell' and 'depth', and to
% the presence or absence of spaces between the arguments.
%========================================================================

% Define allowable labels for the stimset
if ~exist('stimsets','var')
    stimsets = {
        'STRF1'
        'STRF2'
        'P1'
        'P2'
        'P3'
        'srch'};
end
nstimsets = length(stimsets);

% Define the allowable labels for the depth
depth_labels = {
    'depth'
    'position'
    'dep'
    'pos'
    'dpth'
    'dp'
    'deth'};
ndepthlabels = length(depth_labels);

% Define a list of bad characters that should be replaced with whitespace
% delimiters so the function strtok will work properly
bad_chars = {
    '.'
    ','
    '_'
    '-'
    '|'};
nbadchars = length(bad_chars);

% Clean up the blockname string
blockname = lower(blockname);
for jj = 1:nbadchars
    blockname = strrep(blockname,bad_chars{jj},char(32));
end    

% Find the start of each cell name block
cell_start = strfind(lower(blockname),'cell');

% Find the start of each depth record block
for jj = 1:ndepthlabels
    
    depth_start = strfind(blockname,depth_labels{jj});
    
    % Stop and exit the first time a depth label is found
    if ~isempty(depth_start)
        depth_start = depth_start(1);
        depth_label = depth_labels{jj};
        break
        
    % If none of the depth labels appears, assume depth information is missing
    elseif jj == ndepthlabels
        depth_start = 0;
        depth_label = '';
    end
end

% Find the stimset label
for jj = 1:nstimsets
    
    stimset_start = strfind(blockname,lower(stimsets{jj}));
    
    % Stop and exit the first time a stimset label is found
    if ~isempty(stimset_start)
        stimset_start = stimset_start(1);
        stimset = stimsets{jj};
        break
        
    % If none of the stimsets appears, assign stimset #1
    elseif jj == nstimsets
        stimset_start = 0;
        stimset = stimsets{1};
    end
end

% Order the fields
field_starts = [cell_start,depth_start,stimset_start,length(blockname)+1];
[sorted_starts,order] = sort(field_starts);
nstarts = length(sorted_starts);

% Break the blockname string into 3 sub-strings: one for cellname, one for
% stimset, and one for depth.
for jj = 1:nstarts-1
    if sorted_starts(jj) == 0
        if sorted_starts(jj+1) <= 1
            all_strings{jj} = '';
        else
            all_strings{jj} = blockname(1:sorted_starts(jj+1)-1);
        end
    else  
        all_strings{jj} = blockname(sorted_starts(jj):sorted_starts(jj+1)-1);
    end
end

% Trim the cell name string
cell_order = find(order == 1);
cellname_str = strtrim(all_strings{cell_order});
cellname_str = strtrim(strrep(cellname_str,'cell',''));
[cellname,remain{1}] = strtok(cellname_str);

% Trim the depth string
depth_order = find(order == 2);
depth_str = strtrim(all_strings{depth_order});
depth_str = strtrim(strrep(depth_str,lower(depth_label),''));
[depth,remain{2}] = strtok(depth_str);
depth = str2num(depth);

% Trim the stimset string
stimset_order = find(order == 3);
stimset_str = strtrim(all_strings{stimset_order});
remain{3} = strrep(stimset_str,lower(stimset),'');

% Put any leftover annotations into 'notes'
notes = '';
for jj = 1:length(remain)
    if isempty(notes)
        notes = strtrim(remain{jj});
    elseif ~isempty(strtrim(remain{jj}))
        notes = sprintf('%s %s',notes,strtrim(remain{jj}));
    end
end