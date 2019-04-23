function pathl=pathlength(antpath,dis)
pathl=0;
for it =1:(length(antpath)-1)
    d=dis(antpath(it),antpath(it+1));
    pathl=pathl+d;
end
pathl=pathl+dis(antpath(1,1),antpath(1,end)); %closing the circle
end