dirout = dir;
is_file = 1-[dirout(:).isdir];

to_copy= {dirout(find(is_file)).name};

for jj = 1:length(to_copy);
    copyfile(fullfile(pwd,to_copy{jj}),fullfile('C:\STIMS',to_copy{jj}));
end