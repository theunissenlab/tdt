function s = scalar(b,scalar_name)
% Return the streamstore object with the given name from the block

global ttank

scalar_code = ttank.StringToEvCode(scalar_name);
access(b);

s = scalarstore(b,scalar_name,scalar_code);
s = get_specs(s);

ttank.ReleaseServer;