function TransitionProb = func_transition_prob(M, THETA, action)

% 推移確率行列を出力する関数
  TransitionProb = zeros(M,M);
  
  if action == 0
    for i = 1:M 
      % 推移0の時
      if i < M
        TransitionProb(i, i) = THETA(3);
      else
        TransitionProb(i, i) = 1;
      end
      
      % 推移1の時
      if i < (M-1)
        TransitionProb(i, i +1) = THETA(4);
      elseif i == (M-1)
        TransitionProb(i, i +1) = 1 - THETA(3);
      end
      
      % 推移2の時
      if i < (M-2)
        TransitionProb(i, i + 2) = THETA(5);
      elseif i == (M-2)
        TransitionProb(i, i + 2) = 1- sum(THETA(3:4));
      end
      
      % 推移3の時
      if i < (M-3)
        TransitionProb(i, i + 3) = THETA(6);
      elseif i == (M-3)
        TransitionProb(i, i + 3) = 1- sum(THETA(3:5));
      end
      
      % 推移4の時
      if i < (M-3)
        TransitionProb(i, i + 4) = THETA(7);
      end
 
    end

  else
    TransitionProb(1, 1:5) = THETA(3:7);
    
  end
  
end
    
  