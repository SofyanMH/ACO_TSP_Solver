function dis=distancematrixcalculator(x,y)

    dis=zeros(length(x),length(x));
    for it=1:length(x);
        for it2=1:length(x);
            dis(it,it2)= sqrt(((x(it)-x(it2))^2)+((y(it)-y(it2))^2));
        end
    end

end