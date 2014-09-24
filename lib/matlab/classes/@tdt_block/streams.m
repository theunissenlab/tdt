function streams = streams(b)
% Return objects for all streams in a block

snames = stream_names(b);
nstreams = length(snames);
streams = cell(1,nstreams);
for jj = 1:nstreams
    streams{jj} = stream(b,snames{jj});
end