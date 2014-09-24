function [names,codes] = stream_names(b)
% Return the names of all stream stores for the block

global ttank

stream_typecode = string2evtypecode('Stream');
access(b)
codes = ttank.GetEventCodes(stream_typecode);

names = {};

for jj = 1:length(codes)
	names{jj} = ttank.CodeToString(codes(jj));
end
ttank.ReleaseServer