% This script needs matconvnet/initialize.m be executed first.
% Reset matlab and load paths
if ~exist('listing','var')
    load('./Processed_data/listing.mat')
end
if ~exist('net','var')
    load('./Processed_data/net.mat')
end
currentpath=pwd;
addpath('./fun')
clear Features

% Features computation
for j=64:length(listing.forward)
    fprintf('Forward %d/%d \n',j,length(listing.forward))
    % Load Optical flow
    load([listing.forward{j,1}.dirpath '/Optical_flow']);
    %Compute features
    for i=1:length(Optical_flow)
        res = vl_simplenn(net, Optical_flow{i,1});
        Features(i,:)=squeeze(res(20).x); % Take only fc8
        if mod(i,50)==0
            fprintf('Features %d/%d \n',i,listing.forward{j,1}.im_number)
        end
    end
    cd(listing.forward{j,1}.dirpath)
    save('Features','Features')
    clear Features
    cd(currentpath)
end
for j=21:length(listing.backward)
    fprintf('Backward %d/%d \n',j,length(listing.backward))
    % Load Optical flow
    load([listing.backward{j,1}.dirpath '/Optical_flow']);
    %Compute features
    for i=1:length(Optical_flow)
        res = vl_simplenn(net, Optical_flow{i,1});
        Features(i,:)=squeeze(res(20).x); % Take only fc8
        if mod(i,50)==0
            fprintf('Features %d/%d \n',i,listing.backward{j,1}.im_number)
        end
    end
    cd(listing.backward{j,1}.dirpath)
    save('Features','Features')
    clear Features
    cd(currentpath)
end