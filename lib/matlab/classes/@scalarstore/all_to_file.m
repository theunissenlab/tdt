function res = all_to_file(s,out_dir)
% Save all channels from the store to binary files

%% Defaults, globals, setup

% Default to not verbose
if nargin < 3
	verbose = false;
end

% Create output directory if necessary
fiatdir(out_dir);

% Initialize output
res = 0;

%% Loop over channels and save data

% We are only looking at scalars that are 1 dimensional
res = tofile(s, out_dir, 1);
% for jj = 1:256
% 	res = res + (tofile(s,out_dir,jj));
% 	if res > 0
% 		break
% 	end
% end