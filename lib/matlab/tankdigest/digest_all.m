% Digest all tanks on the server

Open_TTank;
servername = 'Local';
[tanknames,ntanks] = get_tanknames(ttank,servername);
out_root = 'C:\Documents and Settings\Channing\My Documents\Grad School\Theunissen lab\datafiles';
tanks = cell(1,ntanks);

for jj = 1:ntanks
    out_dir = fullfile(out_root,tanknames{jj}.name);
    fiatdir([out_dir filesep]);
    tanks{jj} = tank(tanknames{jj}.name,servername);
    try
        digest_tank(tanks{jj},out_dir);
    catch
        errstring = sprintf('Error extracting tank %s:\n%s',...
            tanks{jj}.name,lasterr);
        disp(errstring);
    end
end