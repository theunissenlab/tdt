function [names,codes] = scalar_names(b)
% Return the names of all stream stores for the block

global ttank

scalar_typecode = string2evtypecode('scalar');
access(b);
codes = ttank.GetEventCodes(scalar_typecode);

names = {};

if ~isnan(codes)
    for jj = 1:length(codes)
        names{jj} = ttank.CodeToString(codes(jj));
    end
end
ttank.ReleaseServer