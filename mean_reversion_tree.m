function [BinTree,rate,p_up,p_down] = mean_reversion_tree(stock_price,std_dev,NumPeriods,cont_rate,option_maturity,reversion_speed,reversion_level)
    %u = exp(std_sp_500_returns*sqrt(3/NumPeriods));
    %d = 1/u;
    time_step = option_maturity/NumPeriods;
    BinTree = zeros(NumPeriods+1);
    p_up = zeros(NumPeriods+1);
    %%build tree by hand
    for i = 1:NumPeriods+1
        for j=1:i
            BinTree(j,i) = reversion_level * (1-exp(-reversion_speed*(i-1)*time_step)) ...
            + log(stock_price)*exp(-reversion_speed*(i-1)*time_step)...
            + (i-2*j+1)*std_dev*sqrt(time_step);
            
            %p_up(j,i) = 0.5 * (1+...
            %(-BinTree(j,i)*sqrt(time_step)*reversion_speed)/sqrt(power(reversion_speed*BinTree(j,i),2)*time_step+power(std_dev,2)));
            p_up(j,i) = 0.5*(1 + reversion_speed * sqrt(time_step) * (reversion_level - BinTree(j,i))/std_dev);
        end
        
    end
    
    rate = exp(cont_rate*time_step)-1;
    p_down = 1-p_up;
end