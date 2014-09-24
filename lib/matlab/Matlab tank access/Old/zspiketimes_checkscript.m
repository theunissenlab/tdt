% this script checks zeroed and unzeroed spiketimes

for jj = 1:nstims
    for kk = 1:ntrials
        first{jj}(kk) = min(spikedata{jj}.spiketimes{kk});
        last{jj}(kk) = max(spikedata{jj}.spiketimes{kk});
        
        zfirst{jj}(kk) = min(zeroed_spikedata{jj}.spiketimes{kk});
        zlast{jj}(kk) = max(zeroed_spikedata{jj}.spiketimes{kk});
    end
end