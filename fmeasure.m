function f = fmeasure(feats, data_ts, data_tr, classif)
%fmeasure train and test a classifier and reports the fmeasure on test data
    predicted_labels = zeros(size(data_ts,1),1);
    switch classif
        case 'LDA'
            %LDA classifier
            predicted_labels = classify(data_ts(:,feats), data_tr(:,feats), data_tr(:,end), 'quadratic');
        case 'KNN'
            %kNN classifier
            predicted_labels = knnclassify(data_ts(:,feats),data_tr(:,feats),data_tr(:,end),3);
        case 'RegTree'
            str_class = num2str(data_tr(:,end));
            t = classregtree(data_tr(:,feats),str_class);
            predicted_labels = cell2mat(eval(t,data_ts(:,feats)));  
            predicted_labels = str2num(predicted_labels);
        case 'NB'
            O1 = NaiveBayes.fit(data_tr(:,feats),data_tr(:,end));%,'dist',F);
            predicted_labels = O1.predict(data_ts(:,feats));
        case 'SVM'
            svmStruct = svmtrain(data_tr(:,feats),data_tr(:,end));
            predicted_labels = svmclassify(svmStruct,data_ts(:,feats));
        otherwise
            % put your own classifier if needed
    end
    p = data_ts(:,end) == 1;
    tp = sum(predicted_labels == 1 & p);
    fp = sum(predicted_labels == 1 & ~p);
    fn = sum(predicted_labels == 0 & p);
    percision = tp / (tp + fp);
    recall = tp / (tp + fn);
    f = 2 * (percision*recall)/(percision+recall);
    if isnan(f)
        f = 0
    end
end

