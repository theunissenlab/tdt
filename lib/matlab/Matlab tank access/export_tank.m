function export_tank(tankname,spike_snippets,opensorter)
% Simplified version of tank digestion

if nargin < 2
    spike_snippets = 0;
end

if nargin < 3
    opensorter = 0;
end

% Make sure we have all the code we need on our path
addpath('C:\matlab\TDT\classes');
addpath('C:\matlab\TDT\Matlab tank access');

% Define the default output directory
out_dir = fullfile('C:\export',tankname);

% Create a connection with the tank server
Open_TTank;

% Make a tank object from the tank name
t = tank(tankname);

% Export the tank in verbose mode
dlmfile(t,out_dir,spike_snippets,1,opensorter);