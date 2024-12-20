function [minval,maxval] = full_fva_milp(milp, params)
% FVA_MILP  Flux Variability for COBRA MILP structures

n = size(milp.A,2);
minval = zeros(n,1);
maxval = zeros(n,1);

for i = 1:n
    milp.c(:) = 0;
    milp.c(i) = 1;
    
    milp.osense = 1; % minimize
    sol = solveCobraMILP(milp, params);
    assert(sol.stat == 1, ...
           sprintf('No solution for minimizing variable %i',i));
    minval(i) = sol.full(i);
    
    milp.osense = -1; % maximize
    sol = solveCobraMILP(milp, params);
    assert(sol.stat == 1, ...
           sprintf('No solution for maximizing variable %i',i));
    maxval(i) = sol.full(i);
    if mod(i, 100) == 0
        fprintf('FVA finishes ... %.2f\n',i/n)
    end
end
