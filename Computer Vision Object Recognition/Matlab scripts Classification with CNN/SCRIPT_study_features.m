% Parameters
Compute.load='yes';

if strcmp(Compute.load,'yes')
    % Reset matlab and load paths
    clear variables
    if ~exist('listing','var')
        load('./Processed_data/listing.mat')
    end
    addpath('./fun')
    currentpath=pwd;
    
    % Load forward features
    histograms_forward=[];
    histograms_backward_rev=[];
    for i=1:length(listing.forward)
        load([listing.forward{i,1}.dirpath '/Features']);
        index.forward(i,1)=size(histograms_forward,2)+1;
        histograms_forward=[histograms_forward Features'];
        index.forward(i,2)=size(histograms_forward,2);
        sizeFeatures_forward(i)=size(Features,1);
    end
    for i=1:length(listing.backward)
        load([listing.backward{i,1}.dirpath '/Features_rev']);
        index.backward_rev(i,1)=size(histograms_backward_rev,2)+1;
        histograms_backward_rev=[histograms_backward_rev Features_rev'];
        index.backward_rev(i,2)=size(histograms_backward_rev,2);
        sizeFeatures_backward_rev(i)=size(Features_rev,1);
    end
    % Load backward features
    histograms_backward=[];
    histograms_forward_rev=[];
    for i=1:length(listing.backward)
        load([listing.backward{i,1}.dirpath '/Features']);
        index.backward(i,1)=size(histograms_backward,2)+1;
        histograms_backward=[histograms_backward Features'];
        index.backward(i,2)=size(histograms_backward,2);
        sizeFeatures_backward(i)=size(Features,1);
    end
    for i=1:length(listing.forward)
        load([listing.forward{i,1}.dirpath '/Features_rev']);
        index.forward_rev(i,1)=size(histograms_forward_rev,2)+1;
        histograms_forward_rev=[histograms_forward_rev Features_rev'];
        index.forward_rev(i,2)=size(histograms_forward_rev,2);
        sizeFeatures_forward_rev(i)=size(Features_rev,1);
    end
end

HF=mean(histograms_forward,2);
HFr=mean(histograms_forward_rev,2);
HB=mean(histograms_backward,2);
HBr=mean(histograms_backward_rev,2);
MAP=histograms_forward-histograms_forward_rev;
MAPt=MAP;
MAPt(abs(MAP)<7)=0;
figure(1),subplot(2,1,1)
CNNspe=sum(abs(MAPt),2);
plot(CNNspe,'k');
xlabel 'FC8 neurone responses differences'
ylabel 'Amplitude [a.u.]'
subplot(2,1,2)
tmp=sum(abs(MAPt),1);
for i=1:length(index.forward)
    VIDspe(i)=sum(tmp(index.forward(i,1):index.forward(i,2)));
end
plot(VIDspe,'k');
xlabel 'Videos responses differences'
ylabel 'Amplitude [a.u.]'