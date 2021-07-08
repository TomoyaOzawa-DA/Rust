% 楠田(2018)　図5　再現
% パラメータが真値の時の選択確率の推移を可視化. Inner-loopの挙動チェック

clear

beta = 0.975;

% 真のパラメータ設定
RC = 11.7257;
theta11 = 2.4569;
theta30 = 0.0937;
theta31 = 0.4475;
theta32 = 0.4459;
theta33 = 0.0127;
theta34 = 0.0002;

THETA_TRUE = [RC, theta11, theta30, theta31, theta32, theta33, theta34]';

M = 175; % xのグリッドの数
XMAX = 5000; % 最大マイル数

% N = 5; %バスの数
% T = 120; % 期間
% 
% % パラメターの真値を使ってデータを生成する
% [x, a] = func_data(M, XMAX, N, T, THETA_TRUE, beta);

%inner-loop
    
iterMAX = 100; % inner-loopの最大計算回数
ERROR = 1e-12; % 収束を終了させる値
X = linspace(0, XMAX, M)' ; % M個のグリッドに分割
    
% 箱の準備
P0 = zeros(M, iterMAX+1);
P1 = zeros(M, iterMAX+1);
V = zeros(M, iterMAX);
    
% P0の初期値
P0(:, 1) = ones(M, 1)*0.6;
    
for iter = 1:iterMAX
    V(:, iter) = func_Phi(X, M, P0(:, iter), THETA_TRUE, beta);
    P0(:, iter+1) = func_Lambda(X, M, V(:, iter), THETA_TRUE, beta);
    P1(:, iter+1) = 1 - P0(:, iter+1);
    
    if (func_pdist(P0(:, iter), P0(:, iter+1)) < ERROR)
        Vbar = V(:, iter);
        break
    end
end

% Plot
figure
plot(P1(2:M, 2:iter+1)) %図5








