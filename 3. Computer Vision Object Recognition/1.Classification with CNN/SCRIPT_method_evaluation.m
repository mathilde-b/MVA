% Reset matlab and load paths
clear variables
if ~exist('listing','var')
    load('./Processed_data/listing.mat')
end
addpath('./fun')
currentpath=pwd;
setup_vlfeat;

% Parameters
nbTrainF=155-52;
nbTrainB=25-8;
nbTestF=52;
nbTestB=8;
ind1f=1:51;
ind1b=1:9;
ind2f=52:103;
ind2b=10:17;
ind3f=104:155;
ind3b=18:25;

% Load forward features (label 1)
ind=[ind1f ind3f ind2f];
histograms=[];
labels=[];
count=1;
for i=1:nbTrainF
    load([listing.forward{ind(i),1}.dirpath '/Features']);
    index_train(i,1)=size(histograms,2)+1;
    histograms=[histograms Features'];
    labels=[labels; ones(size(Features,1),1)];
    index_train(i,2)=size(histograms,2);
end
testHistograms=[];
testLabels=[];
for i=nbTrainF+1:nbTrainF+nbTestF
    load([listing.forward{ind(i),1}.dirpath '/Features']);
    index_test(i-nbTrainF,1)=size(testHistograms,2)+1;
    testHistograms=[testHistograms Features'];
    testLabels=[testLabels; ones(size(Features,1),1)];
    index_test(i-nbTrainF,2)=size(testHistograms,2);
end

% Load backward features (label -1)
ind=[ind1b ind3b ind2b];
for i=1:nbTrainB
    load([listing.backward{ind(i),1}.dirpath '/Features']);
    index_train(i+nbTrainF,1)=size(histograms,2)+1;
    histograms=[histograms Features'];
    labels=[labels; -ones(size(Features,1),1)];
    index_train(i+nbTrainF,2)=size(histograms,2);
end
for i=nbTrainB+1:nbTrainB+nbTestB
    load([listing.backward{ind(i),1}.dirpath '/Features']);
    index_test(i-nbTrainB+nbTestF,1)=size(testHistograms,2)+1;
    testHistograms=[testHistograms Features'];
    testLabels=[testLabels; -ones(size(Features,1),1)];
    index_test(i-nbTrainB+nbTestF,2)=size(testHistograms,2);
end

% count how many images are there
fprintf('Number of training images: %d forward, %d backward\n', ...
    sum(labels > 0), sum(labels < 0)) ;
fprintf('Number of testing images: %d forward, %d backward\n', ...
    sum(testLabels > 0), sum(testLabels < 0)) ;

% L2 normalize the histograms before running the linear SVM
histograms= bsxfun(@times, histograms, 1./sqrt(sum(histograms.^2,1))) ;
testHistograms = bsxfun(@times, testHistograms, 1./sqrt(sum(testHistograms.^2,1))) ;

% Train the linear SVM. The SVM paramter C should be
% cross-validated. Here for simplicity we pick a valute that works
% well with all kernels.
C = 10 ;
[w, bias] = trainLinearSVM(histograms, labels, C) ;

% Evaluate the scores on the training data
scores = w' * histograms + bias ;

% Test the linear SVM
testScores = w' * testHistograms + bias ;

% Exctract results
for i=1:size(index_train,1)
    trainResults(i)=mean(scores(index_train(i,1):index_train(i,2)));
    trainTruth(i)=labels(index_train(i,1));
end
for i=1:size(index_test,1)
    testResults(i)=mean(double(testScores(index_test(i,1):index_test(i,2))));
    testTruth(i)=testLabels(index_test(i,1));
end
subplot(1,2,1),bar(trainResults)
subplot(1,2,2),bar(testResults),title(sprintf('correct: %d/%d',sum((abs(sign(testResults)+testTruth))/2),length(testTruth)));
result=sum((abs(sign(testResults)+testTruth))/2)/length(testTruth)

figure
plot(testScores,'k')
hold on
for i=1:size(index_test,1)
    plot([index_test(i,1) index_test(i,2)],[testResults(i) testResults(i)],'r','Linewidth',1)
end
plot([0 index_test(end,2)],[0 0],'b','Linewidth',1)
xlabel 'Optical flow features frame'
ylabel 'Response'