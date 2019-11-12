function f = mean_reversion_put(BinTree,Strike,rate,p_up,p_down)

    treeLength = length(BinTree);
    OptPrice(:,treeLength) = max(0,Strike - exp(BinTree(:,treeLength)));
    for i = treeLength-1:-1:1
        for j=1:i
            OptPrice(j,i) = (OptPrice(j,i+1)*p_up(j,i+1) + OptPrice(j+1,i+1)*p_down(j+1,i+1))/(1+rate);
        end
    end
    f = OptPrice(1,1);
end