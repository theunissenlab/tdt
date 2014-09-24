% a testing script for loading up tank data and plotting the observables
data_dir = 'C:\export\chronic_acquisition_test';
blockname = 'aug_3_2009_chronic_test1';
mic_file = fullfile(data_dir,sprintf('%s Micr 1 stream.f32',blockname));
fid = fopen(mic_file);
mic_data = fread(fid,'float32');
fclose(fid);

stim_epoc_file = fullfile(data_dir,sprintf('%s epoc Stm+.txt',blockname));
stim_times = dlmread(stim_epoc_file);
stim_samples = int32(round(stim_times(:,2:3) * tdt_25k));