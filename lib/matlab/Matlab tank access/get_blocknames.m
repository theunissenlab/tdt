function [blocknames,nblocks] = get_blocknames(actxname,tankname)

%======================================================
% This script loops over all the blocks on the current
% server and returns an array with their names and
% indices
%======================================================

global servername clientname

blocknames = cell(0);
blockname = 'foo';
blockidx = 0;
jj = 1;
stopflag = 0;

% Connect to server and select tank
tank_access;

while stopflag == 0
    blockname = actxname.QueryBlockName(blockidx);
    if length(blockname) > 0
        blocknames{jj}.idx = blockidx;
        blocknames{jj}.name = blockname;
        jj = jj+1;
        blockidx = blockidx + 1;
    else
        stopflag = 1;
    end
end

actxname.ReleaseServer;

nblocks = length(blocknames);