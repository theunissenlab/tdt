function s = stream(b,stream_name)
% Return the streamstore object with the given name from the block

global ttank

stream_code = ttank.StringToEvCode(stream_name);
access(b);

s = streamstore(b,stream_name,stream_code);
s = get_specs(s);

ttank.ReleaseServer;