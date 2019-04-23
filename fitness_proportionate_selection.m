function wr=fitness_proportionate_selection(phe)

r=rand;
a=cumsum(phe);
wr=find(r<=a,1);
x =isempty(wr);

if x==1
    wr=0;
end

end