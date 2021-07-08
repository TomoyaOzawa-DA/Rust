function P0 = func_Lambda(X, M, V, THETA, beta)

%推移確率行列
F0 = func_transition_prob(M, THETA, 0);
F1 = func_transition_prob(M, THETA, 1);

%効用関数
u0 = -0.001*THETA(2)*X;
u1 = -THETA(1)*ones(M, 1);

R0 = u0 + beta*F0*V;
R1 = u1 + beta*F1*V;

P0 = exp(R0)./(exp(R0) + exp(R1));
end