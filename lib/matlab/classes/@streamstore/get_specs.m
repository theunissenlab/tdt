function s = get_specs(s)
% Query tank server for data specs on stream store

%% Globals and defaults
global ttank

%%

ttank.GetCodeSpecs(s.store_code);
s.samplerate = ttank.EvSampFreq;
s.datasize = ttank.EvDataSize;
s.data_form = ttank.DFromToString(ttank.EvDForm);

ttank.ReleaseServer;