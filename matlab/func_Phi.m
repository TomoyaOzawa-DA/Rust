function V = func_Phi(X, M, P0, THETA, beta)

%推移確率行列
F0 = func_transition_prob(M, THETA, 0);
F1 = func_transition_prob( M, THETA, 1);

%効用関数
u0 = -0.001*THETA(2)*X;
u1 = THETA(1)*ones(M, 1);

P1 = 1 - P0;

%P0*F0, P1*F1の計算
PF = zeros(M, M);
for i = 1:M
    PF(i, :) = P0(i).*F0(i, :);
end
P0F0 = PF;

PF = zeros(M, M);
for i = 1:M
    PF(i, :) = P1(i).*F1(i, :);
end
P1F1 = PF;

V = (eye(M) - beta*(P0F0 + P1F1))\(P0.*(u0-log(P0)) + P1.*(u1-log(P1)));
end