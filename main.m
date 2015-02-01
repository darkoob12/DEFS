clc;
clear;

load('../defs/heart.mat');
%load('../defs/tumors_11.mat');

% parameters
NRun = 1;  % number of runs
K = 10; % number of folds
NGen = 100; % number of generations
file_prefix = strcat('defs_a');

run_err = zeros(K,NRun);
gen_err = zeros(K,NGen);

for r = 1:NRun
    fprintf('*****  run num %d  *****\n', r);
    % create cross-validation partitions
    cv_indx = cvpartition(size(data,1), 'kfold', K);
    for i = 1:cv_indx.NumTestSets
       ts_idx = cv_indx.test(i);
       tr_idx = cv_indx.training(i);
       [gen_err(i,:), sub_set] = DEFS_A(data(tr_idx,:),data(ts_idx,:),50,0,'NB',NGen,0);
       fprintf('fold: %d \t Err: %.4f \t Subset Selected size: %d\t \n',i,gen_err(i,end),length(sub_set));
       run_err(i,r) = gen_err(i,end);
    end
    out_file_name = strcat(file_prefix,'run_',num2str(r),'.csv');
    csvwrite(out_file_name, gen_err);
    fprintf('mean accuracy: %f std: %f\n',mean(100 - run_err(:,r)),std(100 - run_err(:,r)));
end

csvwrite(strcat(file_prefix,'all.csv'), run_err);

fprintf('total mean: %f\n',100 - mean(mean(run_err)));
