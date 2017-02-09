if ~exist('listing','var')
    load('./Processed_data/listing.mat')
end
currentpath=pwd;

% for j=1:length(listing.forward)
%     fprintf('Forward %d/%d \n',j,length(listing.forward))
%     % Load Optical flow
%     load([listing.forward{j,1}.dirpath '/Optical_flow']);
%     Optical_flow(listing.forward{j,1}.im_number:end)=[];
%     cd(listing.forward{j,1}.dirpath)
%     save('Optical_flow','Optical_flow')
%     clear Optical_flow
%     cd(currentpath)
% end
% for j=1:length(listing.backward)
%     fprintf('Backward %d/%d \n',j,length(listing.backward))
%     % Load Optical flow
%     load([listing.backward{j,1}.dirpath '/Optical_flow']);
%     Optical_flow(listing.backward{j,1}.im_number:end)=[];
%     cd(listing.backward{j,1}.dirpath)
%     save('Optical_flow','Optical_flow')
%     clear Optical_flow
%     cd(currentpath)
% end
for j=1:length(listing.forward)
    fprintf('Forward %d/%d \n',j,length(listing.forward))
    % Load Optical flow
    load([listing.forward{j,1}.dirpath '/Optical_flow_rev']);
    tmp=Optical_flow_rev(end-listing.forward{j,1}.im_number+2:end);
    clear Optical_flow_rev
    Optical_flow_rev=tmp;
    cd(listing.forward{j,1}.dirpath)
    save('Optical_flow_rev','Optical_flow_rev')
    clear Optical_flow_rev
    cd(currentpath)
end
for j=1:length(listing.backward)
    fprintf('Backward %d/%d \n',j,length(listing.backward))
    % Load Optical flow
    load([listing.backward{j,1}.dirpath '/Optical_flow_rev']);
    tmp=Optical_flow_rev(end-listing.backward{j,1}.im_number+2:end);
    clear Optical_flow_rev
    Optical_flow_rev=tmp;
    cd(listing.backward{j,1}.dirpath)
    save('Optical_flow_rev','Optical_flow_rev')
    clear Optical_flow_rev
    cd(currentpath)
end