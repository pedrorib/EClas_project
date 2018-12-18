function [u] = test_t(pi,b,f,lim) %f is to plot the figure markov of chain
%Fix Specific Transition Probabilities
%Generate a Markov chain characterized by a partially random transition matrix. 
%Also, decrease the number of feasible transitions.
%Generate a 400-by-400 matrix of missing (NaN) values, which represents the transition matrix.
states = lim*lim;
P = NaN(states);

x_lim = sqrt(states);
%Specify that state x transitions to state x with probability;
v_d = 1;
v_u = x_lim;

for i=1:states
    if (i > x_lim + 1) && (i ~= v_u + x_lim) && (i ~= v_d + x_lim) && (i < states - x_lim + 2)
        P(i,i+1) = 1/8;
        P(i,i+x_lim+1) = 1/8;
        P(i,i+x_lim) = 1/8;
        P(i,i+x_lim-1) = 1/8;
        P(i,i-1) = 1/8;
        P(i,i-x_lim-1) = 1/8;
        P(i,i-x_lim) = 1/8;
        P(i,i-x_lim+1) = 1/8;
    end
    if (i==1)   %position inicial
        P(i,i+1) = 1/3;
        P(i,i+x_lim+1) = 1/3;
        P(i,i+x_lim) = 1/3;
    end
    if (2 <= i) && (i< x_lim)   %lado esquerdo
        P(i,i+1) = 1/5;
        P(i,i+x_lim+1) = 1/5;
        P(i,i+x_lim) = 1/5;
        P(i,i-1+x_lim) = 1/5;
        P(i,i-1) = 1/5;
    end
    if (i == x_lim)             %ultima posicao do lado esquerdo
        P(i,i+x_lim) = 1/3;
        P(i,i+x_lim-1) = 1/3;
        P(i,i-1) = 1/3;
    end
    if (i == v_d + x_lim) && (i ~= states - x_lim + 1)  %lado down
       v_d = i;
       P(i,i+1) = 1/5;
       P(i,i+1+x_lim) = 1/5;
       P(i,i+x_lim) = 1/5;
       P(i,i-x_lim) = 1/5;
       P(i,i-x_lim+1) = 1/5;
    end   
    if (i == states - x_lim + 1)   %inicio da ultima coluna
        P(i,i+1) = 1/3;
        P(i,i-x_lim) = 1/3;
        P(i,i+1-x_lim) = 1/3;
    end
    if (i == v_u + x_lim) && (i ~= states)  %lado up
        v_u = i;
        P(i,i+x_lim) = 1/5;
        P(i,i-1+x_lim) = 1/5;
        P(i,i-1) = 1/5;
        P(i,i-1-x_lim) = 1/5;
        P(i,i-x_lim) = 1/5;
    end
    if (i == states)  %last position
        P(i,i-1) = 1/3;
        P(i,i-x_lim-1) = 1/3;
        P(i,i-x_lim) = 1/3;
    end
    if (states - x_lim + 1 < i) && (i ~=states)  %lado direito
        P(i,i+1) = 1/5;
        P(i,i-1) = 1/5;
        P(i,i-1-x_lim) = 1/5;
        P(i,i-x_lim) = 1/5;
        P(i,i+1-x_lim) = 1/5;
    end
end

%Create a Markov chain characterized by the partially known transition matrix. 
%For the remaining unknown transition probabilities,  specify that five transitions 
%are infeasible for 5 random transitions.  An infeasible transition is a transition 
%whose probability of occurring is zero.
%rng(1); % For reproducibility
mc = mcmix(states,'Fix',P);
%mc is a dtmc object. With the exception of the fixed elements (1,2) and (2,1) of the transition matrix, 
%mcmix places five zeros in random locations and generates random probabilities for the 
%remaining nine locations. The probabilities in a particular row sum to 1.

%Display the transition matrix and plot a digraph of the Markov chain. In the plot, 
%indicate transition probabilities by specifying edge colors.
P = mc.P;

n=length(P(1,:));
m = [];
i=0;
for i=1:n        %it is initilization
    m(i) = b(i)*pi(i);
end

for j=1:n
    z=0;
    for i=1:n
        z=z+P(i,j)*m(i);
    end
    u(1,j)=z*b(j);
end

%for j=1:n
%    z=0;
%    for i=1:n
%        z=z+P(i,j);
%    end
%    u(1,j)=z;
%end

if f == 1
    figure;
    graphplot(mc,'ColorEdges',true);  %markov chain graph
    
    %f = figure('Name', 'Transition matrix');
    %h = heatmap(f, flipud(P));
    %h.CellLabelFormat = '%.4f';
    %h.ColorbarVisible = 'on';
    %h.FontSize = 8;
end

%ta = reshape(u,[x_lim,x_lim]); %convert vetor to matrix

%f1 = figure('Name', 'Uncertainty matrix');
%h = heatmap(f1, flipud(ta));
%h.CellLabelFormat = '%.4f';
%h.ColorbarVisible = 'on';
%h.FontSize = 8;
