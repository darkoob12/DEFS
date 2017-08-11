function f = fitness_ind(Ind, data_ts, data_tr, classif)
    feats = get_features(Ind);
    Ac1 = zeros(size(data_ts,1),1);
    switch classif
        case 'LDA'
            %LDA classifier
            Ac1 = classify(data_ts(:,feats), data_tr(:,feats), data_tr(:,end), 'quadratic');
        case 'KNN'
            %kNN classifier
            Ac1 = knnclassify(data_ts(:,feats),data_tr(:,feats),data_tr(:,end),3);
        case 'RegTree'
            str_class = num2str(data_tr(:,end));
            t = classregtree(data_tr(:,feats),str_class);
            Ac1 = cell2mat(eval(t,data_ts(:,feats)));  Ac1 = str2num(Ac1);
        case 'NB'
            O1 = NaiveBayes.fit(data_tr(:,feats),data_tr(:,end));%,'dist',F);
            Ac1 = O1.predict(data_ts(:,feats));
        case 'SVM'
            svmStruct = svmtrain(data_tr(:,feats),data_tr(:,end));
            Ac1 = svmclassify(svmStruct,data_ts(:,feats));
        otherwise
            % put your own classifier if needed
    end
    f = sum(Ac1~=data_ts(:,end)) / size(data_ts,1); % calcualte accuracy
end