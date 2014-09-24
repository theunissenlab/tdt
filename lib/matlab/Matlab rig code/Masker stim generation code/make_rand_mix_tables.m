function [inds1,inds2,loopcount] = make_rand_mix_tables(nstims,ntrials);

if any(nstims == 0)
    inds1 = [];
    inds2 = [];
elseif ~diff(nstims)
    inds1 = repmat(1:nstims(1),ntrials,1);
    inds2 = zeros(ntrials,nstims(2));
    inds2(1,:) = randperm(nstims(2));
    loopcount = zeros(1,ntrials);

    for jj = 2:ntrials
        repeats = zeros(ntrials-1,nstims(2));
        bad_match = 1;
        while bad_match
            trial_seq = randperm(nstims(2));

            % Check against previous trials
            for kk = 1:jj-1
                repeats(kk,:) = trial_seq == inds2(kk,:);
            end
            bad_match = any(any(repeats));
            loopcount(jj) = loopcount(jj) + 1;
        end
        inds2(jj,:) = trial_seq;
    end
else
    error('Number of stims must be the same');
end