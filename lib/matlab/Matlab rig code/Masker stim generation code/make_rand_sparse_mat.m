function out = make_rand_sparse_mat(n_rows,n_each)
% Makes a random matrix of 1s and 0s.  There are "n_rows" rows and columns,
% with "n_each" 1s in each row and each column.
out = zeros(n_rows);

done_count = zeros(1,n_rows);

for jj = 1:n_rows
    p_ones = ((n_each - sum(out))/n_each);
    rand_vect = rand(1,n_rows);
    p_ones = p_ones .* rand_vect;
    [junk,inds] = sort(p_ones);
    out(jj,inds(end:-1:(end-n_each+1))) = 1;
end