% skew matrix to start

nstims = [40,40];
popdim = 2;
order = [1:nstims(popdim)]';
ncomb = 4;

randmat = zeros(nstims);
popmat = eye(nstims);

% Tile along columns
for jj = 1:ncomb
    randmat = randmat + popmat(:,order);
    order = circshift(order,1);
end

% shuffle columns and rows randomly
nperms = 100;
for jj = 1:nperms
    coinflip = round(rand);
    if coinflip
    % Shuffle rows
        randmat = randmat(randperm(nstims(popdim)),:);
    else
        % Shuffle columns
        randmat = randmat(:,randperm(nstims(popdim)));
    end
end