function TransitionProb = func_transtion_prob(M, THETA, action)

% 推移確率行列を出力する関数
  TransitionProb = zeros(M,M);
  
  if action == 0
    for i = 1:M 
      % 推移0の時
      if i < 90
        TransitionProb(i, i) = THETA(3);
      else
        TransitionProb(i, i) = 1;
      end
      
      % 推移1の時
      if i < 89
        TransitionProb(i, i +1) = THETA(4);
      elseif i == 89
        TransitionProb(i, i +1) = 1 - THETA(3);
      end
      
      % 推移2の時
      if i < 88
        TransitionProb(i, i + 2) = THETA(5);
      elseif i == 88
        TransitionProb(i, i + 2) = 1- sum(THETA(3:4));
      end
      
      % 推移3の時
      if i < 87
        TransitionProb(i, i + 3) = THETA(6);
      elseif i == 87
        TransitionProb(i, i + 3) = 1- sum(THETA(3:5));
      end
      
      % 推移4の時
      if i < 86
        TransitionProb(i, i + 4) = THETA(7);
      elseif i == 86
        TransitionProb(i, i + 4) = 1- sum(THETA(3:6));
      end
    end

  else
    TransitionProb(1, 1:5) = THETA(3:7);
  end
  
end
    
  