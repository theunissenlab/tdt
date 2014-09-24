function hashseq = hash_sequence(filename,nstims,nrepeats,offset)

%======================================================
% This function generates a hash table for the TDT
% system to use. The table consists of 'nrepeats' sets
% of numbers; each set is a random permutation of the
% numbers 1:nstims. This allows the TDT hardware to run
% sets of permutations rather than totally random sets
%======================================================

% Default offset is 0
if(isempty(offset))
    offset = 0;
end

% File I/O
%filename = fullfile(out_dir,'stimseqhash.f32');
fid = fopen(filename,'w');
%fprintf (fid, '%s\n', 'Dummy');

% Generate the hash matrix
hashseq = [];
for trial = 1:nrepeats 
   hashseq = [hashseq,randperm(nstims)+offset];
end

% Write data to the file and close it
fwrite(fid,hashseq,'float32');
%fwrite(fid,hashseq,'uchar');
fclose(fid);