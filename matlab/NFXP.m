% NFXP アルゴリズム

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

N = 5; %バスの数
T = 120; % 期間

% パラメターの真値を使ってデータを生成する
[x, a] = func_data(M, XMAX, N, T, THETA_TRUE, beta);


%推定
% パラメータの初期値を設定する
% RC = 12;
% theta11 = 3;
% THETA3 = THETA_TRUE(3:7); % 本来はデータから頻度を数えて導く。今回は省略
% THETA(:, 1) = [RC, theta11, THETA3]';
% 
% % outer-loop
% tic %計算時間の計測開始
% kMAX = 200; % outer-loopの最大計算回数
% logL = ones(1, kMAX)*(-1e+12); %対数尤度の初期値
% 
% for k = 1:kMAX
%     
%     fprintf('NFXP:     k = %d,    logL = %f\n', k, logL(k));
%     
%     % inner-loop
%     % P0の初期値
%     P0(:, 1) = ones(M, 1)*0.6;
%     
%     iterMAX = 100; % inner-loopの最大計算回数
%     ERROR = 1e-12; % 収束を終了させる値
%     X = linspace(0, XMAX, M)' ; % M個のグリッドに分割
%     
%     % 箱の準備
%     P0 = zeros(M, iterMAX+1);
%     V = zeros(M, iterMAX+1);
%     
%     % P0の初期値
%     P0(:, 1) = ones(M, 1)*0.6;
%     
%     for iter = 1:iterMAX
%         
%         V(:, iter) = func_Phi(X, M, P0(:, iter), THETA(:, k), beta);
%         P0(:, iter+1) = func_Lambda(X, M, V(:, iter), THETA(:, k), beta);
%         
%         if (func_pdist(P0(:, iter), P0(:, iter+1)) < ERROR)
%             Vbar = V(:, iter);
%             break
%         end
%     end
% end
    % inner-loop end
    
    % 勾配ベクトルとヘッセ行列の計算
    



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

