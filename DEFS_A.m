function [Err,Subset] = DEFS_A(data_tr,data_ts,NP,Ld,classif,GEN,silent)
%% CONTROL PARAMETERS
CR = 0.5; % crossover constant
NF = size(data_tr,2) - 1; % high boundary constraint (-1 for class label)
a1 = 1; % coeeficient of first term in dist. formula
F = 0.4;  % scale factor in DE
c1 = 0.7; % parameter for dynamic scale factor
mu_delta =  0.001; % mutation momentum for number of selected features
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
Err = zeros(1, GEN); % saving best fitness of each generation

%% INITIALIZATION
Pop = pop_initialize(Ld, NF, NP);
% evaluate fitness of initial population
Fit = evaluate(Pop, data_ts, data_tr, classif);
% saving index of best individual
[~, iBest] = min(Fit);

if ~silent
    fprintf('Iter: %d \t Err: %.4f \t Subset Selected: %s\n',...
        1,Fit(iBest)*100,num2str(Pop(end-1,iBest)));
end
% ploting params...
% close all;
% figure;hold on; % start figure
% xlim([0, GEN]);
% ylim([0, 1.3]);
Err(1) = Fit(iBest) * 100;
%% Main Loop (Optimization)
for g = 2:GEN % for each generation
    % plot
%     plot(Pop(end-1,:)/size(Pop,1),Fit/100,'.r');
%     m = mean(Pop(end-1,:));
%     s = std(Pop(end-1,:));
%     plot(g,m,'.b');
%     plot(g,s,'.r');
%     pause(0.001);
    
    % parent selection
    parents = tournament(Fit, NP, 2);
    
    % creating new population through recombination
    NewPop = recombination(Pop,parents,CR,c1,mu_delta);
    
    % evaluating fitness of new population
    NewFit = evaluate(NewPop, data_ts, data_tr, classif);
    
    % each new individual is competeing for survival with its parent
%     dist_t = crowding([Pop NewPop],[Fit NewFit],8);
%     Dist = dist_t(1:NP);
%     NewDist = dist_t(NP+1:end);


    % elitism pair-wise selection
%     for i = 1:NP
%         if (NewFit(i) < Fit(parents(i)))
%             Pop(:,parents(i)) = NewPop(:,i);
%             Fit(parents(i)) = NewFit(i);            
%         elseif ((NewFit(i) == Fit(parents(i)))&&(NewDist(i) > Dist(i)))
%             Pop(:,parents(i)) = NewPop(:,i);
%             Fit(parents(i)) = NewFit(i);
%         end
%     end

    [Pop, Fit] = select(Pop,Fit,NewPop,NewFit);
    
    % output bes individual
    [~, iBest] = min(Fit);
%     fprintf('%f ', Pop(:,iBest));
%     fprintf('\n');
    if ~silent
        fprintf('Iter: %d \t Err: %.4f \t Subset Selected: %s\n',...
            g,Fit(iBest)*100,num2str(Pop(end-1,iBest)));
    end
    Err(g) = (Fit(iBest)) * 100;
end

% final subset of features
Subset = get_features(Pop(:,iBest));