function scalars = scalars(b)
% Return objects for all scalars in a block

snames = scalar_names(b);
nscalars = length(snames);
scalars = cell(1,nscalars);
for jj = 1:nscalars
    scalars{jj} = scalar(b,snames{jj});
end