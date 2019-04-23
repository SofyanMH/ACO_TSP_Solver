%ACO_TSP_Solver.m Takes an input excel file which contains two columns of x
%and y coordinates and solves a Eucilidean Symmetric TSP
clc
clear

%Read problem
xy_path= uigetfile('*.xlsx','Select The Problem Data File');
xy=xlsread(xy_path);

x=xy(:,1);
y=xy(:,2);
x=transpose(x);
y=transpose(y);

%Parameters
z=input('Input the maximum number of iterations ');
nants=input('Input the number of ants ');
pr=input('Input the pheromone rate ');
alpha=input('Input alpha ');
beta=input('Input beta ');

%Distance calculation
dis=distancematrixcalculator(x,y);
n=length(x);

vm=1./dis; %Visibility matrix

%Initialise pheromone matrix
ph=ones(n,n);

%Optimisation

%Iteration loop
for iteration = 1:z

%Ant loop    
for ant = 1:nants
    
antpath=0;
antpath(1)=randi ([1 n]);

%Decesion loop
    for it=1:(n-1)
        index=antpath(end);
        phe=(ph(index,:).^alpha).*(vm(index,:).^beta);
        phe(antpath)=0;
        phe=phe/sum(phe);
        wr=fitness_proportionate_selection(phe);
        antpath=[antpath wr];
    end
    
%ant path length
pathl=pathlength(antpath,dis);
sols(ant,:)=pathl;
paths(ant,:)=antpath;

%Local pheromone update
for it = 1:(length(antpath)-1)
    a=antpath(it);
    b=antpath(it+1);
    ph(a,b)=ph(a,b)+pr*(1/(pathl));
    ph(b,a)=ph(b,a)+pr*(1/(pathl));
end
a=antpath(1);
b=antpath(end);
ph(a,b)=ph(a,b)+pr*(1/(pathl));
ph(b,a)=ph(b,a)+pr*(1/(pathl)); %closing the cycle

%evaboration
ph=ph*(1-pr);
end

gsols(iteration,:)=min(sols);
solsindex= find(sols==gsols(iteration,:));
solsindex=solsindex(end);
gpaths(iteration,:)=paths(solsindex,:);

%Global pheromone update
for it = 1:(length(antpath)-1)
    a=antpath(it);
    b=antpath(it+1);
    ph(a,b)=ph(a,b)+pr*(1/(min(sols)));
    ph(b,a)=ph(b,a)+pr*(1/(min(sols)));
end
a=antpath(1);
b=antpath(end);
ph(a,b)=ph(a,b)+pr*(1/(min(sols)));
ph(b,a)=ph(b,a)+pr*(1/(min(sols))); %closing the cycle


end

%Obtaining best solution
sol = min(gsols);
solindex= find(gsols==sol);
solindex=solindex(1);
pathn=gpaths(solindex,:);

%Displaying results
pathn =pathn
sol =sol
itr=1:1:length(gsols);
figure (1)
plot(itr,gsols);
xlabel('Iteration')
ylabel('Tour Length')
figure (2)
xp=x(pathn);
xp=[xp xp(1)];
yp=y(pathn);
yp=[yp yp(1)];
p=plot(xp,yp,':',xp,yp,'x');
xlabel('x')
ylabel('y')
p(1).LineWidth=1.5;
p(2).MarkerSize=8;