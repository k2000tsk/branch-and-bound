% Main function, calculates the minimum solution made of integers
function [ret1, ret2, ret3] = bb(f, A, B, Aeq, Beq, lb, ub)

    global num_variables;

    [X, v] = linprog(f, A, B, Aeq, Beq, lb, ub);
    flag_int = 1;

    for i =  0:num_variables
        % If not integer
        if (!~mod(X(i,1),1))
            flag_int = 0;
            var_val = floor(X(i,1));
            var_index = i;
        endif;
    endfor;

    % If all elements integer
    if (flag_int == 1)
        if (v == NA)
            ret1 = NA;
            ret2 = 1;
            ret3 = inf;
        else
            ret1 = X;
            ret2 = 1;
            ret3 = v;

            update_graph(X);
        endif
    else
        lb1 = lb;
        lb2 = lb;
        ub1 = ub;
        ub2 = ub;

        lb1(var_index,1) = var_val+1;

        ub2(var_index,1) = var_val;

        [X1, i1, v1] = bb(f, A, B, Aeq, Beq, lb1, ub1);
        [X2, i2, v2] = bb(f, A, B, Aeq, Beq, lb2, ub2);

        if (v1 < v2)
            ret1 = X1;
            ret2 = i1+i2;
            ret3 = v1;
        else
            ret1 = X2;
            ret2 = i1+i2;
            ret3 = v2;
        endif;
    endif;
    return;
endfunction;

