%this script takes the output of export_tank() and generates text files
%usable by STRPAK (one text file per stimulus, each line containing spike
%times for one trial)
%first, navigate to the directory containing the exported tank files for
%the experiment you wish to convert

clear all; close all; clc;

curr_dir=pwd;
slash=find(curr_dir=='/',1,'last');
tank_name=curr_dir(slash+1:end);
fprintf('----TANK %s----\n\n',tank_name);

files=dir('*wzf1*Freq*.txt'); %find the names of all the blocks from the exported data
for f=1:length(files)
   space=find(files(f).name==' ');
   block_names{f}=files(f).name(1:space-1); 
end

output_folder=['/auto/fdata/robert/processed/',tank_name,'_processed/'];

for b=1:length(block_names) %block loop

block_name=block_names{b};
fprintf('BLOCK %s\n',block_name);

if ~exist([output_folder,block_name],'dir') %the directory does not exist
    mkdir([output_folder,block_name]); end

%oad in the exported tank data
spks=dlmread([block_name,' spikes.txt']);
swep=dlmread([block_name,' epoc Swep.txt']);
freq=dlmread([block_name,' epoc Freq.txt']);
stim=dlmread([block_name,' epoc Stm+.txt']);

%group all cells?
pgroup=0;
if pgroup
    spks(:,4)=1;
end

stim_num=unique(freq(:,1)); %how many stimuli?
cell_num=unique(spks(:,4)); %how many spike templates?

for c0=1:length(cell_num) %cell loop
c1=cell_num(c0);
fprintf('\tCELL #%i\n',c1);
for s0=1:length(stim_num) %stimulus loop
    
    s1=stim_num(s0); %stimulus number (references stimfilenames.txt) 
    
    save_path=[output_folder,block_name,'/cell',num2str(c1),'_resp',num2str(s1),'.txt'];
    
    fid=fopen(save_path,'w');
    idx=stim(:,1)==s1;
    stim_start=stim(idx,2);
    stim_stop=stim(idx,3);
    
    for s2=1:sum(idx) %trial loop
        spike_tims=spks(spks(:,1)>stim_start(s2)...
            & spks(:,1)<stim_stop(s2)...
            & spks(:,4)==c1,1)';
        spike_tims=(spike_tims-stim_start(s2))*1000;
        fprintf(fid,'\n');
        fprintf(fid,'%f ',spike_tims);
    end %trial loop
    fclose(fid);
    
end %stimulus loop

end %cell loop

fprintf('\n');

end %block loop