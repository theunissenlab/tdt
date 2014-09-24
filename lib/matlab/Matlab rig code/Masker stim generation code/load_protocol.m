function [Outfiles,Stims,WARNING] = load_protocol(input_dir)

%% Construct output structures

% Construct Outfiles struct
Outfiles.stimwav = fullfile(input_dir,'stim.wav');
Outfiles.maskwav = fullfile(input_dir,'mask.wav');
Outfiles.protocol = fullfile(input_dir,'protocol.txt');
Outfiles.setnumbers = fullfile(input_dir,'setnumbers.txt');
Outfiles.wavpts = fullfile(input_dir,'wavpts.txt');
Outfiles.wavptsstart = fullfile(input_dir,'wavptsstart.txt');
Outfiles.nstims = fullfile(input_dir,'nStims.f32');
Outfiles.nsets = fullfile(input_dir,'nSets.f32');
Outfiles.searchseq = fullfile(input_dir,'srchseq.f32');
Outfiles.maskstimseq = fullfile(input_dir,'maskstimseq.f32');
Outfiles.maskseq = fullfile(input_dir,'maskseq.f32');
Outfiles.selseq = fullfile(input_dir,'selseq.f32');
Outfiles.callseq = fullfile(input_dir,'callseq.f32');

%% Read in files from srch

Srch = struct;
Srch.name = 'Srch';
Srch.dir = fullfile(input_dir,Srch.name);

% Get list of wav files in this directory
set = struct;
set.dir = Srch.dir;
wavfiles = dir(fullfile(Srch.dir,'*.wav'));
set.stims = {wavfiles.name};
Srch_exist=(~isempty(set.stims));

% Put set into Srch struct
Srch.sets = set;

%% Read in files from mask

Mask = struct;
Mask.name = 'Mask';
Mask.dir = fullfile(input_dir,Mask.name);
Mask.sets = struct('dir',{},'stims',{},'maskers',{});

% Get list of directory and find subdirectories
dirlist = dir(Mask.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);
if n_subdir ~=0
    
    % Make subsets
    for jj = 1:n_subdir
        set.dir = fullfile(Mask.dir,names{jj});
    
        % Get stims
        stim_dir = fullfile(set.dir,'stim');
        wav_files = dir(fullfile(stim_dir,'*.wav'));
        set.stims = {wav_files.name};
        
        % Get maskers
        mask_dir = fullfile(set.dir,'masker');
        wav_files = dir(fullfile(mask_dir,'*.wav'));
        set.maskers = {wav_files.name};
    
        Mask.sets(jj) = set;
    end
    set = Mask.sets(1);
    Mask_exist = (~isempty(set.stims));
else
    Mask_exist = 0;
end

%% Read in files from selectivity

Sel = struct;
Sel.name = 'Sel';
Sel.dir = fullfile(input_dir,Sel.name);
Sel.sets = struct('name',{},'dir',{},'stims',{});

dirlist = dir(Sel.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);

if n_subdir ~=0

    % Get always stims
    always = struct;
    always.name = 'always';
    always.dir = fullfile(Sel.dir,always.name);
    wav_files = dir(fullfile(always.dir,'*.wav'));
    always.stims = {wav_files.name};
    Sel_always_exist = (~isempty(always.stims));
    Sel_exist = Sel_always_exist;
    Sel.sets(1) = always;

    % Get sometimes stims
    sometimes = struct;
    sometimes.name = 'sometimes';
    sometimes.dir = fullfile(Sel.dir,sometimes.name);
    wav_files = dir(fullfile(sometimes.dir,'*.wav'));
    sometimes.stims = {wav_files.name};
    Sel_sometimes_exist = (~isempty(sometimes.stims));
    if Sel_sometimes_exist ~=0
        Sel.sets(2) = sometimes;
    end
else
    Sel_exist = 0;
end

%% Read in files from Call

Call = struct;
Call.name = 'Call';
Call.dir = fullfile(input_dir,Call.name);
Call.sets = struct('name',{},'dir',{},'stims',{});

dirlist = dir(Call.dir);
is_subdir = [dirlist.isdir] & ~strncmpi('.',{dirlist.name},1);
names = {dirlist(is_subdir).name};
n_subdir = length(names);

if n_subdir ~=0

    % Get familiar stims
    familiar = struct;
    familiar.name = 'wavfiles_Familiar_calls';
    familiar.dir = fullfile(Call.dir,familiar.name);
    wav_files = dir(fullfile(familiar.dir,'*.wav'));
    familiar.stims = {wav_files.name};
    Call_familiar_exist = (~isempty(familiar.stims));
    Call_exist = Call_familiar_exist;
    Call.sets(1) = familiar;

    % Get stranger stims
    stranger = struct;
    stranger.name = 'wavfiles_Stranger_calls';
    stranger.dir = fullfile(Call.dir,stranger.name);
    wav_files = dir(fullfile(stranger.dir,'*.wav'));
    stranger.stims = {wav_files.name};
    Call_stranger_exist = (~isempty(stranger.stims));
    if Call_stranger_exist ~=0
        Call.sets(2) = stranger;
    end
else
    Call_exist = 0;
end
    

%% Return sets
WARNING=[Srch_exist,Mask_exist,Sel_exist,Call_exist,Sel_sometimes_exist,Call_stranger_exist];


if (Srch_exist==1) && (Mask_exist==1) && (Sel_exist==1) && (Call_exist==1)
    Stims = [Srch;Mask;Sel;Call];
end

