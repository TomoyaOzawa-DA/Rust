function_utility <- function(grid, params_theta_1, method = "linear"){
  # Objective: 効用関数の値を出力する関数
  
  # Input: 
  ## grid: 状態変数xを離散化する際のグリッド数 = x_1, x_2, ... ,x_grid
  ## params: 費用関数のパラメータベクトル。第1要素にはRC(エンジン交換費用)
  ## method: 費用関数の形状の指定。まずはlinearのみ。
  
  # Output:
  ## cost_matrix: 行列 (grid * 2)
  
  
  cost_matrix <- matrix(0, nrow = grid, ncol = 2)
  
  if(method == "linear"){
      cost_matrix[, 1] <- 0.001*params_theta_1[2]*seq(from = 1, to = grid, by = 1) # メンテナンス費用
      cost_matrix[, 2] <- params_theta_1[1] # エンジン交換費用
    }

  return(-cost_matrix)
}




function_transition_prob <- function(grid, params_theta_3, action){
  # 推移確率行列を出力する関数
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
  out <- log(exp(function_utility(grid, params_theta_1, method = "linear")[, 2] + beta*function_transition_prob(grid, params_theta_3, action = 1)%*%EV_base) +
    exp(function_utility(grid, params_theta_1, method = "linear")[, 1] + beta*function_transition_prob(grid, params_theta_3, action = 0)%*%EV_base))
  return(out)
}




function_choice_prob0 <- function(EV_fixed, grid, params_theta_1, method = "linear", params_theta_3){
  choice_prob0 <- matrix(0, grid, 1)
  numerator_0 <- exp(function_utility(grid, params_theta_1, method = "linear")[, 1] + beta*function_transition_prob(grid, params_theta_3, action = 0)%*%EV_fixed)
  numerator_1 <- exp(function_utility(grid, params_theta_1, method = "linear")[, 1] + beta*function_transition_prob(grid, params_theta_3, action = 1)%*%EV_fixed)
  denominator <- numerator_0 + numerator_1
  choice_prob0 <- numerator_0 / denominator # i = 0
  return(choice_prob0)
}



function_inner_loop <- function(grid, params_theta_1, method = "linear", beta, params_theta_3,threshold = 1e-6){

  iteration_max <- 1000
  achieved <- FALSE
  
  EV <- matrix(0, grid, iteration_max)
  
  for (i in 1: (iteration_max - 1)){
    EV[, i+1] <- function_EV(EV[, i], grid, params_theta_1, method = "linear", beta, params_theta_3)
    
    if (sqrt(sum((EV[, i+1] - EV[, i])^2)) < threshold){
      position <- i+1
      cat("Convergence achieved in ",i+1," iterations")
      achieved <- TRUE
      break
    }
    
  }
  
  if(!achieved){
    cat("Convergence NOT achieved in ",sqrt(sum((EV[, iteration_max] - EV[, iteration_max-1])^2)))
  }
  
  prob0 <- function_choice_prob0(EV[, position], grid, params_theta_1, method = "linear", params_theta_3)
  
  return(prob0)
  
}

















