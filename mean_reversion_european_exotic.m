function f = mean_reversion_european_exotic(BinTree,Strike,rate,p_up,p_down)

    treeLength = length(BinTree);
    OptPrice(:,treeLength) = power((exp(BinTree(:,treeLength)) - Strike),2);
    for i = treeLength-1:-1:1
        for j=1:i
            OptPrice(j,i) = (OptPrice(j,i+1)*p_up(j,i+1) + OptPrice(j+1,i+1)*p_down(j+1,i+1))/(1+rate);
        end
    end
    f = OptPrice(1,1);
end