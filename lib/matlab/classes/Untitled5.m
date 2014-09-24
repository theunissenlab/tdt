servername = 'Local';
clientname = 'MatlabTankExport';
Open_TTank;

[tanknames,ntanks] = get_tanknames(ttank,servername);
goodnames = [1:22,23:29];

for jj = 1:length(goodnames)
    tanks{jj} = tank(tanknames{goodnames(jj)}.name,'Local');
end

myblocks = tdt_blocks(tanks{end});