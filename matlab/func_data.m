function [x, a] = func_data(M, XMAX, N, T, THETA, beta)

theta30 = THETA(3);
theta31 = THETA(4);
theta32 = THETA(5);
theta33 = THETA(6);

% thetaの初期値のもとで不動点を求める

X = linspace(0, XMAX, M)'; % 0からXMAXまでをM個に分割したもの

iterMAX = 30; %反復計算の最大回数
ERROR = 1e-12; %収束を終了させる値

%　P0P1の初期値
P0 = ones(M, iterMAX+1);
P0(:, 1) = ones(M, 1)*0.6;

V = zeros(M, iterMAX);

for iter = 1:iterMAX
    V(:, iter) = func_Phi(X, M, P0(:, iter), THETA, beta);
    P0(:, iter+1) = func_Lambda(X, M, V(:, iter), THETA, beta);
    P1 = 1 - P0(:, iter+1);
    
    if (func_pdist(P0(:, iter), P0(:, iter+1)) < ERROR)
        break
    end
    
end

% データの生成
Lv_x = ones(N, T);
a = zeros(N, T);

for t = 1:T-1
    for i = 1:N
        
        % データ a
        if rand < P1(Lv_x(i, t)) % 交換確率より乱数が小さければ交換する
            a(i, t) = 1;
        end
        
        r = rand;
        
        if a(i, t) == 0
            
            if Lv_x(i, t) < M-3
                
                if r < theta30
                    Lv_x(i, t+1) = Lv_x(i, t) + 0;
                elseif r < theta30 + theta31
                    Lv_x(i, t+1) = Lv_x(i, t) + 1;
                elseif r < theta30 + theta31 + theta32
                    Lv_x(i, t+1) = Lv_x(i, t) + 2;
                elseif r < theta30 + theta31 + theta32 + theta33
                    Lv_x(i, t+1) = Lv_x(i, t) + 3;
                else
                    Lv_x(i, t+1) = Lv_x(i, t) + 4;
                end
                
            elseif Lv_x(i, t) == M-3
                
                if r < theta30 / (theta30 + theta31 + theta32 + theta33)
                    Lv_x(i, t+1) = Lv_x(i, t) + 0;
                elseif r < (theta30 + theta31) / (theta30 + theta31 + theta32 + theta33)
                    Lv_x(i, t+1) = Lv_x(i, t) + 1;
                elseif r < (theta30 + theta31 + theta32) / (theta30 + theta31 + theta32 + theta33)
                    Lv_x(i, t+1) = Lv_x(i, t) + 2;
                else
                    Lv_x(i, t+1) = Lv_x(i, t) + 3;
                end
                
            elseif Lv_x(i, t) == M-2
                
                if r < theta30 / (theta30 + theta31 + theta32)
                    Lv_x(i, t+1) = Lv_x(i, t) + 0;
                elseif r < (theta30 + theta31) / (theta30 + theta31 + theta32)
                    Lv_x(i, t+1) = Lv_x(i, t) + 1;
                else
                    Lv_x(i, t+1) = Lv_x(i, t) + 2;
                end
                
            elseif Lv_x(i, t) == M-1
                
                if r < theta30 / (theta30 + theta31)
                    Lv_x(i, t+1) = Lv_x(i, t) + 0;
                else
                    Lv_x(i, t+1) = Lv_x(i, t) + 1;
                end
                
            elseif Lv_x(i, t) == M
                Lv_x(i, t+1) = Lv_x(i, t) + 1;
                
            end
            
        else
            
            if r < theta30
                Lv_x(i, t+1) = 1; %交換したらxは1に戻る
            elseif r < theta30 + theta31
                Lv_x(i, t+1) = 2;
            elseif r < theta30 + theta31 + theta32
                Lv_x(i, t+1) = 3;
            elseif r < theta30 + theta31 + theta32 + theta33
                Lv_x(i, t+1) = 4;
            else
                Lv_x(i, t+1) = 5;
            end
        end
    end
end

x = X(Lv_x);
end






