clear all; close all; clc;

global tankname servername clientname;
addpath('C:\matlab\TDT\classes\');
addpath('C:\matlab\TDT\Matlab tank access\');
tankname = 'RG3_test';
save_path = 'C:\Documents and Settings\Sepehr\My Documents\MATLAB\songdata\';

servername='Local';
clientname='Me';

Fs_mic=24414.06;
Fs_dec=1525.9;

pplot=1;
psave=1;
pbrowse=1;

%load the stimulus lengths (start with the second row, since row 1 is "Dummy")
stim_len=dlmread(['C:\STIMS\just_mic_09122009\WavPts.txt'],'\n',1,0)/32000;
fid=fopen(['C:\STIMS\just_mic_09122009\stimfilenames.txt']);
stim_fpath=textscan(fid,'%s');

%open the tank
% Open_TTank

% create the TTank object
global ttank;
ttank = actxcontrol('TTank.X');

% connect to the server
ttank.ConnectServer(servername,clientname);

% Open the tank
ttank.OpenTank(tankname, 'R');

%%
%load the block names and number of blocks in that tank
for j=1:100
    blockname = ttank.QueryBlockName(j);
    if ~isempty(blockname)
        block(j).name=blockname;
        block(j).idx=j;
    else break;
    end
end
nblocks=length(block);

%%
%block loop
for b=2:length(block) %block loop

    % select the desired block
    ttank.SelectBlock(block(b).name);
    ttank.CreateEpocIndexing;
    
    ntrials=ttank.ReadEventsV(1000, 'Trl+', 0, 0, 0.0, 0.0, 'ALL');
    
    e=1; t=1; done=0;
    while ~done
        
        ttank.ResetFilters();
        ttank.SetFilterWithDescEx(['Trl+=',num2str(t)]);
        nepochs=ttank.ReadEventsV(1000, 'Swep', 0, 0, 0.0, 0.0, 'FILTERED');
        
        ttank.ResetFilters();
        ttank.SetFilterWithDescEx(['Swep=',num2str(e)]);

        %get the on and off times of this epoch from the filter
        Variant=ttank.GetValidTimeRangesV;
        clear filt_on filt_off;
        try
            filt_on=Variant(1,t);
            filt_off=Variant(2,t);
        catch
            filt_on=-1; filt_off=-1; end
        %check if the filter worked (otherwise we are at the end of a trial)
        nstm=ttank.ReadEventsV(1000,'Stm+',0,0,filt_on,filt_off,'ALL');
        if nstm==0
            if t<ntrials
                t=t+1; e=1;
                ttank.ResetFilters();
                ttank.SetFilterWithDescEx(['Swep=',num2str(e)]);

                Variant=ttank.GetValidTimeRangesV;
                filt_on=Variant(1,t);
                filt_off=Variant(2,t);
            else
                done=1; break;
            end
        end

        fprintf('Block %d (of %d), Trial %d (of %d), Epoch %d (of %d)\n',b,nblocks,t,ntrials,e,nepochs);
        
        %sanity check for the observed trial and epoch
        obs_trl=ttank.QryEpocAtV('Trl+',mean([filt_on,filt_off]),0);
        obs_swep=ttank.QryEpocAtV('Swep',mean([filt_on,filt_off]),0);
        if obs_trl~=t
            disp('Trial mismatch!');
        end
        if obs_swep~=e
            disp('Epoch (Swep) mismatch!');
        end
        
        %stimulus on
        stim_on=ttank.ParseEvInfoV(0,nstm,6);
        %stimulus off
        ttank.ReadEventsV(1000,'Stm-',0,0,filt_on,filt_off,'ALL');
        stim_off=ttank.ParseEvInfoV(0,nstm,6);
        %stimulus codes
        stim_code=ttank.ParseEvInfoV(0,nstm,7);
        trial_stim_fname=stim_fpath{1}{stim_code};
        slash=strfind(trial_stim_fname,'\');
        trial_stim_fname=trial_stim_fname(slash(end)+1:end);

        mic=ttank.ReadWavesOnTimeRangeV('Micr',1);
        stim=ttank.ReadWavesOnTimeRangeV('Stim',1);
        powr=ttank.ReadWavesOnTimeRangeV('Powr',1);
        spk_tims=ttank.ReadEventsV(10000,'EA__',0,0,filt_on,filt_off,'ALL');
        spk_wavs=[];

        tr_dur=filt_off-filt_on; %the trial duration
        tr_samp=floor(tr_dur*Fs_mic); %the number of samples (this trial) in the mic channel
        tr_samp_dec=floor(tr_dur*Fs_dec); %the number of samples in the decimated channels
        mic=mic(1:tr_samp,t);
        stim=stim(1:tr_samp_dec,t);
        powr=powr(1:tr_samp_dec,t);

        if psave
            trial(t).epoch(e).mic=mic;
            trial(t).epoch(e).Fs_mic=Fs_mic;
            trial(t).epoch(e).filt_on=filt_on;
            trial(t).epoch(e).filt_off=filt_off;
            trial(t).epoch(e).stim=stim;
            trial(t).epoch(e).Fs_stim=Fs_dec;
            trial(t).epoch(e).stim_on=stim_on;
            trial(t).epoch(e).stim_off=stim_off;
            trial(t).epoch(e).spk_tims=[];
            trial(t).epoch(e).spk_wavs=[];
            trial(t).epoch(e).stim_fname=trial_stim_fname;
        end

        %% plot everything
        if pplot
            figure(2); clf;

            h(1)=subplot(3,1,1);
            xax_dec=linspace(filt_on,filt_off,size(powr,1));
            %plot microphone power
            plot(xax_dec,powr/abs(max(powr)),'g'); vline(stim_on,'g'); vline(stim_off,'r');
            xlim([filt_on,filt_off]);
            set(gca,'xtick',[]);

            title({['Trial: ',num2str(t),'/',num2str(ntrials),' Epoch: ',num2str(e),'/',num2str(nepochs)],...
                trial_stim_fname});

            h(2)=subplot(3,1,2);
            xax=linspace(filt_on,filt_off,size(mic,1));
            %plot microphone waveform
            plot(xax,mic/abs(max(mic))); vline(stim_on,'g'); vline(stim_off,'r');
            xlim([filt_on,filt_off]);
            set(gca,'xtick',[]);
            out_pos=get(gca,'outerposition'); out_pos(4)=0.364; set(gca,'outerposition',out_pos);

            h(3)=subplot(3,1,3);
            %plot stimulus trace
            plot(xax_dec,stim/abs(max(stim)),'g'); hold on;
            vline(stim_on,'g'); vline(stim_off,'r');
            xlim([filt_on,filt_off]);
            out_pos=get(gca,'outerposition'); out_pos(4)=0.364; set(gca,'outerposition',out_pos);

            linkaxes(h,'x');

            %load the stimulus sound
            [stim_wav,Fs_stim]=wavread(stim_fpath{1}{stim_code});
        end
        if pbrowse
            uicontrol('style','pushbutton','string','prev','position',[40 25 40 20],...
                'callback','e=e-1; uiresume;');
            uicontrol('style','pushbutton','string','next','position',[80 25 40 20],...
                'callback','if e==nepochs, e=1; t=t+1; else, e=e+1; end; uiresume;');
            uicontrol('style','pushbutton','string','done','position',[180 25 40 20],...
                'callback','done=1; uiresume;');
            h_input_t=uicontrol('style','edit','string',num2str(t),'position',[120 25 20 20],...
                'callback','t=str2num(get(h_input_t,''string'')); uiresume;');
            h_input_e=uicontrol('style','edit','string',num2str(e),'position',[140 25 20 20],...
                'callback','e=str2num(get(h_input_e,''string'')); uiresume;');
            uicontrol('style','pushbutton','string','play mic','position',[20 5 60 20],...
                'callback','sound(double(mic),Fs_mic);');
            uicontrol('style','pushbutton','string','play stim','position',[80 5 60 20],...
                'callback','sound(stim_wav/100,Fs_dec);');
            uiwait;
        end
        if ~pplot || ~pbrowse %not pplot
            if e==nepochs, %done all events in the trial
                e=1;
                if t==ntrials %done all trials in the block
                    done=1; break;
                else %not done all trials, move onto next trial
                    t=t+1;
                end
            else %not done all events, move onto next event
                e=e+1;
            end
        end %pplot

    end %epochs
    %% save everything
    if psave
        save(fullfile(save_path,[tankname,'_',block(b).name,'_Data.mat']),'trial');
        clear trial;
    end
end %blocks
% close the tank
ttank.CloseTank;
% release the server
ttank.ReleaseServer;










