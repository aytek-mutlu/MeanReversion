%%%Assignment1 Q2

%%MEAN REVERSION

%%BINOMIAL TREE

%parameters
std_dev = 0.1424;
stock_price = 2978.4;
NumPeriods = 63;
int_rate = 0.01;
compound_freq = 0.25;
option_maturity = 0.25;
cont_rate = log(power((1+int_rate*compound_freq),1/compound_freq));
reversion_speed = 0.05;
reversion_level = log(stock_price); 

[BinTree,rate,p_up,p_down] = mean_reversion_tree(stock_price,std_dev,NumPeriods,cont_rate,option_maturity,reversion_speed,reversion_level);

%%3000 strike european call
europ_call_3000 = mean_reversion_call(BinTree,3000,rate,p_up,p_down);

%%%european put strike 3000
europ_put_3000 = mean_reversion_put(BinTree,3000,rate,p_up,p_down);

%%option prices for all strikes
strikes = 2500:100:3500;
call_prices = zeros(1,length(strikes));
put_prices = zeros(1,length(strikes));
strike_count=1;

for strike=strikes
    call_prices(1,strike_count) = mean_reversion_call(BinTree,strike,rate,p_up,p_down);
    put_prices(1,strike_count) = mean_reversion_put(BinTree,strike,rate,p_up,p_down);
    strike_count = strike_count+1;
end

%%%european exotic
strikes = 2500:250:3500;
european_exotic_prices = zeros(1,length(strikes));
strike_count=1;
for strike=strikes
    european_exotic_prices(1,strike_count) = mean_reversion_european_exotic(BinTree,strike,rate,p_up,p_down);
    strike_count = strike_count+1;
end

%%MONTE-CARLO
M = 100000;
time_step = option_maturity/NumPeriods;
discount  = exp(-cont_rate*option_maturity);

MC_matrix = zeros(M,NumPeriods);
MC_matrix(:,1) = log(stock_price);

for i=2:NumPeriods
    brownian = randn(M,1);
    MC_matrix(:,i) = MC_matrix(:,i-1) + reversion_speed * (reversion_level - MC_matrix(:,i-1)) * time_step + std_dev*brownian*sqrt(time_step);
end

MC = exp(MC_matrix(:,NumPeriods));

%%%%3000 strike european call
europ_call_3000_mc =  mean(discount * max(MC-3000,0));

%%%%3000 strike european put
europ_put_3000_mc =  mean(discount * max(3000-MC,0));

%%option prices for all strikes
strikes = 2500:100:3500;
call_prices_mc = zeros(1,length(strikes));
put_prices_mc = zeros(1,length(strikes));
strike_count=1;

for strike=strikes
    call_prices_mc(1,strike_count) = mean(discount * max(MC-strike,0));
    put_prices_mc(1,strike_count) = mean(discount * max(strike-MC,0));
    strike_count = strike_count+1;
end

%%%european exotic
strikes = 2500:250:3500;
european_exotic_prices_mc = zeros(1,length(strikes));
strike_count=1;
for strike=strikes
    european_exotic_prices_mc(1,strike_count) = mean(discount * power((strike-MC),2));
    strike_count = strike_count+1;
end


