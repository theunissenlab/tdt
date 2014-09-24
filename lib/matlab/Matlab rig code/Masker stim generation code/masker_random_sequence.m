function sequence = masker_random_sequence(stims,ntrials,nrepeats,bosnum,bos_type)

% Create sequence of stim-masker combinations
% which argument is which is not specified so that the types can be
% transparent to the program
% Stims and bos are passed as indices for files, i.e. integers that the TDT
% can reference

% Put randperm.m on the path
randpath = fullfile(toolboxdir('matlab'),'randfun');
addpath(randpath);

%
nstims = cellfun(@length,stims);
npresentations = sum(nstims) + max(nstims)*(min(nstims) > 0);

% Create structure for bos
if nargin > 3
    npresentations = npresentations + 1;
    bos = {[0] [0]};
    bos{bos_type} = bosnum;
else
    bos = {[] []};
end

% Initialize output sequence variable
sequence = zeros(2,ntrials * npresentations * nrepeats);

% Ensure that the lists of stim numbers are vectors
for jj = 1:2
    stims{jj} = reshape(stims{jj},1,nstims(jj));
end

% Generate random mixing matrix between stims and maskers if necessary
if all(nstims)
    for jj = 1:nrepeats
% Can't use the random sparse matrices; instead, need to use
% trial-by-trial tables
%         if diff(nstims)
%             random_mixing = gen_sparsemat(nstims,ntrials);
%         else
%             random_mixing = make_rand_sparse_mat(round(mean(nstims)),ntrials);
%         end
%         [matches,backmatches] = find(random_mixing);
%         matchnumbers = reshape(matches,ntrials,nstims(2));
%         backmatchnumbers = reshape(backmatches,ntrials,nstims(1));
        [backmatchnumbers,matchnumbers] = make_rand_mix_tables(nstims,ntrials);
        
        % Convert mixing matrix into pairs of stims etc.
        for kk = 1:ntrials
            base_seq = ...
                [zeros(size(stims{2}))   stims{1}                stims{1}(backmatchnumbers(kk,:))    bos{1}
                 stims{2}                zeros(size(stims{1}))   stims{2}(matchnumbers(kk,:))        bos{2}];
            order = randperm(npresentations);
            output_range = (jj-1)*ntrials*npresentations +...
                (kk-1)*npresentations + [1:npresentations];
            sequence(:,output_range) = base_seq(:,order);
        end
    end
else
    % Figure out which set has stims
    has_stims = find(nstims);
    npresentations = nstims(has_stims);
    
    % Create alternate sequence with stimnumber = 0 for all non-type presentations
    base_seq = zeros(1,nstims(has_stims));
    base_seq(1,:) = stims{has_stims};
    for jj = 1:nrepeats
        for kk = 1:ntrials
            order = randperm(npresentations);
            output_range = (jj-1)*ntrials*npresentations +...
                (kk-1)*npresentations + [1:npresentations];
            sequence(has_stims,output_range) = base_seq(order);
        end
    end
end