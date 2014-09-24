% [epoch]=segment_sound(s,min_silence,min_epoch,pplot)
% s - sound file
% min_silence - the minimum length of silence that separates two individual
% calls (seconds)
% min_epoch - the minimum length for one sound epoch (seconds)
% pplot - flag for plotting the results
% any parts of the wav file you wish to exclude should be made as NaNs in
% the original wav file

function [epoch,epoch_on]=segment_sound(s,fs,min_silence,min_epoch,exclude_on,exclude_off,pplot)

rem_onset=0; rem_offset=0;

min_silence=min_silence*fs;
min_epoch=min_epoch*fs;
min_baseline=0.; %the minimum baseline value, useful for recordings with
                    %really good SNR where during silence periods even very
                    %quiet sounds pass the threshold
dec_factor=100; %the decimation factor to speed up the threshold calculation
xax=[1/fs:1/fs:numel(s)/fs];

%calculate sound envelope using the Hilbert transform
rms_s=sqrt(s.^2);
h=fdesign.lowpass('Fp,Fst,Ap,Ast',0.01,0.08,1,60);
d=design(h,'equiripple'); %Lowpass FIR filter
rms_s2=filtfilt(d.Numerator,1,rms_s); %zero-phase filtering

%save the excluded segment for plotting later
exclude_seg=xax>exclude_on & xax<exclude_off;
ex_rms_s2=rms_s2(exclude_seg);
ex_xax=xax(exclude_seg);

%exclude any segments that the user did not want to consider
rms_s2(exclude_seg)=NaN;

% %create a moving baseline and threshold
% %decimate the rms and x-axis (time)
% rms_s2_dec=decimate(rms_s2,dec_factor);
% xax_dec=decimate(xax,dec_factor);
% 
% %make a window over which to average rms values
% win=round((fs/2)/dec_factor);
% baseline_dec=conv(rms_s2_dec,ones(1,win))/sum(ones(1,win));
% baseline_dec=baseline_dec(floor(win/2):floor(end-win/2));
% baseline_dec(baseline_dec<min_baseline)=min_baseline;
% baseline=interp1(xax_dec,baseline_dec,xax);
% baseline=baseline';
% 
% %set the threshold to 2 times the baseline value
% thresh=2*baseline;

baseline=nanmean(rms_s2);
if baseline<min_baseline, baseline=min_baseline; end;
thresh=baseline+1*nanstd(rms_s2);

%plot power, baseline, and threshold
if pplot
    plot(xax,rms_s2); hold on;
    plot(ex_xax,ex_rms_s2,'m');
    hline(baseline,'g'); hline(thresh,'r');
end

%define windows of activity by suprathreshold periods
call_epoch=rms_s2>thresh;

d_call_epoch=diff(call_epoch);
onset=find(d_call_epoch==1);
offset=find(d_call_epoch==-1);
if isempty(onset)
    disp('No sound detected!'); plot(xax,rms_s2); epoch=[]; epoch_on=[]; return, end
if isempty(offset)
    offset(1)=numel(s); end

%the first should be an onset
if onset(1)>offset(1)
    rem_offset=1; end
%the last should be an offset
if onset(end)>offset(end)
    rem_onset=1; end
if rem_onset, onset(end)=[]; end
if rem_offset, offset(1)=[]; end

if isempty(onset)
    disp('No sound detected!'); plot(xax,rms_s2); epoch=[]; epoch_on=[]; return, end

%the number of onsets should equal the number of offsets
if numel(onset)~=numel(offset)
    warning('Number of onsets does not equal number of offsets!'); end

%combine suprathreshold periods that are separated by less than the
%mininum allowed silence period
rem_idx1=find([onset(1:end);+inf]-[-inf;offset(1:end)]<min_silence);
onset(rem_idx1)=[]; offset(rem_idx1-1)=[];

%remove suprathreshold periods that are less than the minimum allowed
%epoch period
rem_idx2=find((offset-onset)<min_epoch);
onset(rem_idx2)=[]; offset(rem_idx2)=[];

if isempty(onset)
    disp('No sound detected!'); plot(xax,rms_s2); epoch=[]; epoch_on=[]; return, end

%expand window to include the first baseline crossing on either side of the
%epoch (half of the min_silence period)
for e=1:length(onset)

    if ~isempty(find(rms_s2(1:onset(e))<baseline,1,'last'))
        onset(e)=find(rms_s2(1:onset(e))<baseline,1,'last');
    else
        warning('No return to subthreshold level!  Beginning of sound clip used as end of sound epoch.');
        onset(e)=1;
    end
    
    if ~isempty(find(rms_s2(offset(e):end)<baseline,1,'first'))
        offset(e)=offset(e)+find(rms_s2(offset(e):end)<baseline,1,'first');
        
    else
        warning('No return to subthreshold level!  End of sound clip used as end of sound epoch.');
        offset(e)=numel(rms_s2);
    end

    %expand to 10ms on either side of that
    onset(e)=round(onset(e)-min_silence/2);
    offset(e)=round(offset(e)+min_silence/2);
    onset(onset<1)=1; offset(offset>numel(s))=numel(s);

    %save the sound epoch
    epoch{e}=double(s(onset(e):offset(e)));
end
epoch_on=onset/fs;

if pplot
   vline(onset/fs,'g'); vline(offset/fs,'r');
end