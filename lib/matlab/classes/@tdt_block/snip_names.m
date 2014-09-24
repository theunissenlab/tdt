function [names,codes] = snip_names(b)
% Return the names of all stream stores for the block

global ttank

stream_typecode = string2evtypecode('Snip');
access(b)
codes = ttank.GetEventCodes(stream_typecode);

names = {};

for jj = 1:length(codes)
	names{jj} = ttank.CodeToString(codes(jj));
end
ttank.ReleaseServer