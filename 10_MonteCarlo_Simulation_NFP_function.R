function_utility <- function(grid, params_theta_1, method = "linear"){
  # Objective: 効用関数の値を出力する関数
  
  # Input: 
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params_theta_1: 費用関数のパラメータベクトル。第1要素にはRC(エンジン交換費用)
  ## method: 費用関数の形状の指定。まずはlinearのみ。
  
  # Output:
  ## cost_matrix: 行列 (grid * 2)
  
  
  cost_matrix <- matrix(0, nrow = grid, ncol = 2)
  
  if(method == "linear"){
      cost_matrix[, 1] <- params_theta_1[2]*seq(from = 1, to = grid, by = 1) # メンテナンス費用
      cost_matrix[, 2] <- params_theta_1[1] # エンジン交換費用
    }

  return(-cost_matrix)
}




function_transition_prob <- function(grid, params_theta_3, action){
  # Objective: 推移確率行列を出力する関数
  
  # Input: 
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params_theta_3: 推移確率のパラメータベクトル。
  ## action: i, エンジンを交換した場合は1, しなi\い場合は0
  
  # Output:
  ## TransitionProb: 行列 (grid * grid)
  
  TransitionProb <- matrix(0, nrow= grid, ncol = grid)
  
  if (action == 0){
    for (i in 1:grid) {
      # 推移0の時
      if(i < 90){
        TransitionProb[i, i] <- params_theta_3[1]
      }else{
        TransitionProb[i, i] <- 1
      }
      
      # 推移1の時
      if(i < 89){
        TransitionProb[i, i +1] <- params_theta_3[2]
      }else if(i == 89){
        TransitionProb[i, i +1] <- 1 - params_theta_3[1]
      }
      
      # 推移2の時
      if(i < 89){
        TransitionProb[i, i + 2] <- params_theta_3[3]
      } 
    }
  }
  else{
    #TransitionProb[1, 1:3] <- params_theta_3[1:3]
    TransitionProb[, 1] <- 1 
  }
  
  return(TransitionProb)
}



function_EV <- function(EV_base, grid, params_theta_1, method = "linear", beta, params_theta_3){
  # Objective: 期待価値関数を出力する関数
  
  # Input: 
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params_theta_1: 費用関数のパラメータベクトル。第1要素にはRC(エンジン交換費用)
  ## method: 費用関数の形状の指定。まずはlinearのみ。
  ## beta: 割引率
  ## params_theta_3: 推移確率のパラメータベクトル。
  
  # Output:
  ## out: 列ベクトル(grid*1)
  
  out <- log(exp(function_utility(grid, params_theta_1, method = "linear")[, 2] + beta*function_transition_prob(grid, params_theta_3, action = 1)%*%EV_base) +
    exp(function_utility(grid, params_theta_1, method = "linear")[, 1] + beta*function_transition_prob(grid, params_theta_3, action = 0)%*%EV_base))
  
  return(out)
}




function_choice_prob0 <- function(EV_fixed, grid, params_theta_1, method = "linear", params_theta_3){
  # Objective: 交換しない選択をする確率, p(i = 0 | x)を出力する関数
  
  # Input: 
  ## EV_fixed: 写像の不動点, 価値関数の値
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params_theta_1: 費用関数のパラメータベクトル。第1要素にはRC(エンジン交換費用)
  ## method: 費用関数の形状の指定。まずはlinearのみ。
  ## params_theta_3: 推移確率のパラメータベクトル。
  
  # Output:
  ## choice_prob0: 行列 (grid * 1)
  
  
  choice_prob0 <- matrix(0, grid, 1)
  numerator_0 <- exp(function_utility(grid, params_theta_1, method = "linear")[, 1] + beta*function_transition_prob(grid, params_theta_3, action = 0)%*%EV_fixed) # i = 0の時の分子
  numerator_1 <- exp(function_utility(grid, params_theta_1, method = "linear")[, 2] + beta*function_transition_prob(grid, params_theta_3, action = 1)%*%EV_fixed) # i = 1の時の分子
  denominator <- numerator_0 + numerator_1
  choice_prob0 <- numerator_0 / denominator # i = 0
  
  return(choice_prob0)
}



function_inner_loop <- function(grid, params_theta_1, method = "linear", beta, params_theta_3,threshold = 1e-6){
  # Objective: 与えられたパラメータのもとで、積分価値関数の不動点を計算して、交換しない選択をする確率, p(i = 0 | x)を計算する関数
  
  # Input: 
  ## EV_fixed: 写像の不動点, 価値関数の値
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params_theta_1: 費用関数のパラメータベクトル。第1要素にはRC(エンジン交換費用)
  ## method: 費用関数の形状の指定。まずはlinearのみ。
  ## params_theta_3: 推移確率のパラメータベクトル。
  ## beta: 割引率
  ## threshold: 不動点を計算する際に使う閾値
  
  # Output:
  ## prob0: 行列 (grid * 1)
  
  
  iteration_max <- 1000 # 繰り返し回数の最大値
  achieved <- FALSE
  
  EV <- matrix(0, grid, iteration_max) 
  
  #不動点の計算
  for (i in 1: (iteration_max - 1)){
    EV[, i+1] <- function_EV(EV[, i], grid, params_theta_1, method = "linear", beta, params_theta_3) 
    
    if (sqrt(sum((EV[, i+1] - EV[, i])^2)) < threshold){ # 差分が閾値より下回れば不動点に達したとみなす。
      position <- i+1
      cat("Convergence achieved in ",i+1," iterations")
      achieved <- TRUE
      break
    }
    
  }
  
  if(!achieved){
    cat("Convergence NOT achieved in ",sqrt(sum((EV[, iteration_max] - EV[, iteration_max-1])^2))) # 繰り返し回数の最大値を超えても収束しなかった場合に警告する
  }
  
  prob0 <- function_choice_prob0(EV[, position], grid, params_theta_1, method = "linear", params_theta_3) # 求めた価値関数から選択確率, i = 0を計算
  
  return(prob0)
  
}

















