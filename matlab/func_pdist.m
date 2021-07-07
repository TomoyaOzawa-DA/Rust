function pdist = func_pdist(dat1, dat2)
pdist = sqrt(sum((dat1 - dat2).^2));

