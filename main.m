clc;
clear;
close all;
rng('default');
load('../defs/heart.mat');
%load('../defs/tumors_11.mat');

% parameters
pbs = 0; % plots best size in each generation
pbe = 0; % plots best error in each generation 
NRun = 10;  % number of runs
K = 5; % number of folds
NGen = 100; % number of generations
file_prefix = strcat('re_defs_a_');

run_err = zeros(K,NRun);  % best error of each fold and each run
gen_err = zeros(K,NGen);  % least error in each generation
gen_size = zeros(K,NGen); % best size in each generation
fs = zeros(K,size(data,2));   % selected features in each fold
fm=zeros(K,NRun);
for r = 1:NRun
    fprintf('*****  run num %d  *****\n', r);
    % create cross-validation partitions
    cv_indx = cvpartition(size(data,1), 'kfold', K);
    for i = 1:cv_indx.NumTestSets
       ts_idx = cv_indx.test(i);
       tr_idx = cv_indx.training(i);
       [gen_err(i,:),gen_size(i,:), sub_set] = DEFS_A(data(tr_idx,:),data(ts_idx,:),100,0,'NB',NGen,1,pbs);
       fprintf('fold: %d \t Err: %.4f \t Size=(%d)\t Subset Selected: %s \n',i,gen_err(i,end),length(sub_set),num2str(sub_set'));
       run_err(i,r) = gen_err(i,end);
       fm(i,r) = fmeasure(sub_set,data(ts_idx,:),data(tr_idx,:),'NB');
       %% plot
       if pbe
           figure; % create a new figure
           plot(1:NGen,gen_err(i,:),'-b','LineWidth',2);
           title('Adaptive DEFS');
           xlabel('generations');
           ylabel('error (best solution)');
           ylim([0 100]);
       end
       fs(i,1:length(sub_set)) = sub_set;
    end
    out_file_name = strcat(file_prefix,'run_',num2str(r),'.csv');
    csvwrite(out_file_name, gen_err);
    out_file_name = strcat(file_prefix,'_size_run_',num2str(r),'.csv');
    csvwrite(out_file_name, gen_size);
    out_file_name = strcat(file_prefix,'_set_run_',num2str(r),'.csv');
    csvwrite(out_file_name, fs);
    fprintf('mean accuracy: %f std: %f\n',mean(100 - run_err(:,r)),std(100 - run_err(:,r)));
end

csvwrite(strcat(file_prefix,'all.csv'), run_err);
csvwrite(strcat(file_prefix,'fm_bn.csv'),fm);

fprintf('total mean: %f\n',100 - mean(mean(run_err)));
