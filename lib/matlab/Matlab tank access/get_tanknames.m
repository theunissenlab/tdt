function [tanknames,ntanks] = get_tanknames(actxname)

%======================================================
% This script loops over all the tanks on the current
% server and returns an array with their names and
% indices
%======================================================
global servername clientname

tanknames = cell(0);
tankname = 'foo';
tankidx = 0;
jj = 1;
stopflag = 0;

%connect_server;
actxname.ConnectServer(servername,clientname);

while stopflag == 0
    tankname = actxname.GetEnumTank(tankidx);
    if length(tankname) > 0
        tanknames{jj}.idx = tankidx;
        tanknames{jj}.name = tankname;
        jj = jj+1;
        tankidx = tankidx + 1;
    else
        stopflag = 1;
    end
end

actxname.ReleaseServer;

ntanks = length(tanknames);