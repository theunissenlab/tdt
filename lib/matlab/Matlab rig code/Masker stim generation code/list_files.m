function [stim_list,masker_list,Stims] = list_files(Stims)

stim_idx = 0;
mask_idx = 0;
stim_list = struct('name',{},'md5',{},'out_name',{},'out_md5',{});
masker_list = stim_list;

for jj = 1:length(Stims)
    Stim = Stims(jj);
    
    for kk = 1:length(Stim.sets)
        set = Stim.sets(kk);
        
        % Check if we need further subdirectories
        if isfield(set,'maskers') && exist(fullfile(set.dir,'stim'))
            set_dir = fullfile(set.dir,'stim');
        else
            set_dir = set.dir;
        end
        
        % List stims
        n_stims = length(set.stims);
        Stim.sets(kk).stim_indices = stim_idx + (1:n_stims);
        for mm = 1:n_stims
            stim_idx = stim_idx + 1;
            stim.name = fullfile(set_dir,set.stims{mm});
            stim.md5 = '';
            stim.out_name = '';
            stim.out_md5 = '';
            stim_list(stim_idx) = stim;
        end
            
        % List maskers if needed
        if isfield(set,'maskers')
            set_dir = fullfile(set.dir,'masker');
            n_maskers = length(set.maskers);
            Stim.sets(kk).mask_indices = mask_idx + (1:n_maskers);
            for mm = 1:n_maskers
                mask_idx = mask_idx + 1;
                masker.name = fullfile(set_dir,set.maskers{mm});
                masker.md5 = '';
                masker.out_name = '';
                masker.out_md5 = '';
                masker_list(mask_idx) = masker;
            end
        end
    end
    
    Stims(jj) = Stim;
end