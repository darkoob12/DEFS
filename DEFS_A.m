function [Err,SS,Subset] = DEFS_A(data_tr,data_ts,NP,Ld,classif,GEN,silent,pbs)
%% CONTROL PARAMETERS
CR = 0.5; % crossover constant
NF = size(data_tr,2) - 1; % high boundary constraint (-1 for class label)
c1 = 0.7; % parameter for dynamic scale factor
e = 0.1;

% Ld
if nargin < 4 || isempty(Ld),
    Ld = 0;
end
if nargin < 5 || isempty(classif),
    classif = 0;
end
if nargin < 6 || isempty(GEN),
    GEN = 400; % number of generations=iterations
end
if nargin < 7 || isempty(silent),
    silent = 1;
end
if nargin < 8 || isempty(pbs),
    pbs = 0;
end
Err = zeros(1, GEN); % saving best fitness of each generation
SS = zeros(1,GEN); % saving best size of each generation

%% INITIALIZATION
Pop = pop_initialize(Ld, NF, NP);
% evaluate fitness of initial population
Fit = evaluate(Pop, data_ts, data_tr, classif);
% effective fitness wieghted sum with size
%Eff_Fit = Fit + w * Pop(end,:)/NF;
% saving index of best individual
[~, iBest] = min(Fit);

if ~silent
    fprintf('Iter: %d \t Err: %.4f \t Subset Selected: %s\n',...
        1,Fit(iBest)*100,num2str(get_features(Pop(:,iBest))));
end

%ploting params...
if pbs
   figure;
   hold on;
   title('Best Size')
   xlim([0 GEN]);
   ylim([1 NF]);
   xlabel('generations');
   ylabel('# of selected features');
end
Err(1) = Fit(iBest) * 100;
SS(1) = round(Pop(end,iBest)); 

%% Main Loop (Optimization)
for g = 2:GEN % for each generation

    % parent selection
    parents = tournament(Fit, NP, 2);
    
    % creating new population through recombination
    NewPop = recombination(Pop,parents,CR,c1);

    % evaluating fitness of new population
    NewFit = evaluate(NewPop, data_ts, data_tr, classif);

    %update epsilon
    e = g/10000;
    
    % each new individual is competeing for survival with its parent
    for i = 1:NP
        if (NewFit(i) < Fit(parents(i)) - e)||...
           ((NewFit(i) <= Fit(parents(i)))&&...
           (NewPop(end,i) < Pop(end, parents(i))))  % select according to last parameter which is size of chromosome
           
            Pop(:,parents(i)) = NewPop(:,i);
            Fit(parents(i)) = NewFit(i);            
        end
    end

    
    % output bes individual
    [~, iBest] = min(Fit);

    if ~silent
        fprintf('Iter: %d \t Err: %.4f \t Size=(%d)\t Subset Selected: %s\n',...
            g,Fit(iBest)*100,round(Pop(end,iBest)),num2str(get_features(Pop(:,iBest)')));
    end
    
    % plot
    if pbs
       plot(g,Pop(end,iBest),'.r','MarkerSize',10); 
       plot(g,mean(Pop(end,:)),'.b','MarkerSize',10); 
       pause(0.001);
    end
    
    Err(g) = (Fit(iBest)) * 100;
    SS(g) = round(Pop(end,iBest));
end

% plot params 
if pbs
   hleg = legend('Best', 'Mean'); 
end

% final subset of features
Subset = get_features(Pop(:,iBest));