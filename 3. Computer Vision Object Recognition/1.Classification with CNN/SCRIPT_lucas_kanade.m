% Notes: Ok for all forward
%        Ok for all backward
% Reset matlab and load paths
impath='/Users/mathildebateson/Documents/MVA/Recvis/Project/Data/OpticalFlows'
if ~exist('listing','var')
    load('./Processed_data/listing.mat')
end
if ~exist('net','var')
    load('./Processed_data/net.mat')
end
addpath('./fun')
currentpath=pwd;
if exist('opticFlow','var')
    reset(opticFlow);
end
clear Optical_flow
clear Optical_flow_rev

% Parameters
NoiseThreshold=0.0009;
draw_opticalflow='no';
Compute.ini.forward='no';
Compute.ini.backward='yes';
Compute.rev.forward='no';
Compute.rev.backward='no';

% Optical flow computation
opticFlow = opticalFlowLKDoG('NoiseThreshold', NoiseThreshold);
if strcmp(Compute.ini.forward,'yes')
    for j=floor(length(listing.forward)/4):floor(length(listing.forward)/4)*2
     %for j=1:2
        fprintf('Forward %d/%d \n',j,length(listing.forward))
        for i=1:listing.forward{j,1}.im_number
            C = strsplit(listing.forward{j,1}.dirpath,'/');
            % Load image
            im=imread([listing.forward{j,1}.dirpath '/' listing.forward{j,1}.im_names{i,1}]);
            % Compute optical flow
            frameGray = rgb2gray(im);
            flow = estimateFlow(opticFlow,frameGray);
            % Display optical flow
            if strcmp(draw_opticalflow,'yes')
                imshow(im)
                hold on
                plot(flow,'DecimationFactor',[5 5],'ScaleFactor',100)
                hold off
                title(sprintf('%d/%d',i,listing.forward{j,1}.im_number))
                drawnow
            end
            if mod(i,50)==0
                fprintf('Flow %d/%d \n',i,listing.forward{j,1}.im_number)
            end
            if i~=1
                tempflow=image_preprocessing(flow,net);
                for kk=1:3
                    tmp=tempflow(:,:,kk);
                    tmp=(tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));
                    tempflow(:,:,kk)=tmp;
                end
                imwrite(tempflow,char(strcat(impath,'/001.forward/001.',C(12),'.',num2str(i),'.jpg')));
                Optical_flow{i-1,1}=tempflow;
            end
        end
%         cd(listing.forward{j,1}.dirpath)
%         save('Optical_flow','Optical_flow')
%         cd(currentpath)
        reset(opticFlow)
        clear Optical_flow
    end
end
if strcmp(Compute.ini.backward,'yes')
    for j=1:length(listing.backward)
    %for j=1:2
        fprintf('Backward %d/%d \n',j,length(listing.backward))
        for i=1:listing.backward{j,1}.im_number
            C = strsplit(listing.backward{j,1}.dirpath,'/');
            % Load image
            im=imread([listing.backward{j,1}.dirpath '/' listing.backward{j,1}.im_names{i,1}]);
            % Compute optical flow
            frameGray = rgb2gray(im);
            flow = estimateFlow(opticFlow,frameGray);
            % Display optical flow
            if strcmp(draw_opticalflow,'yes')
                imshow(im)
                hold on
                plot(flow,'DecimationFactor',[5 5],'ScaleFactor',100)
                hold off
                title(sprintf('%d/%d',i,listing.backward{j,1}.im_number))
                drawnow
            end
            if mod(i,50)==0
                fprintf('Flow %d/%d \n',i,listing.backward{j,1}.im_number)
            end
            if i~=1
                tempflow=image_preprocessing(flow,net);
                for kk=1:3
                    tmp=tempflow(:,:,kk);
                    tmp=(tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));
                    tempflow(:,:,kk)=tmp;
                end
                imwrite(tempflow,char(strcat(impath,'/002.backward/002.',C(12),'.',num2str(i),'.jpg')));
                Optical_flow{i-1,1}=tempflow;
            end
        end
        cd(listing.backward{j,1}.dirpath)
        save('Optical_flow','Optical_flow')
        cd(currentpath)
        reset(opticFlow)
        clear Optical_flow
    end
end
if strcmp(Compute.rev.forward,'yes')
    for j=1:length(listing.forward)
        fprintf('Rev. Forward %d/%d \n',j,length(listing.forward))
        for i=listing.forward{j,1}.im_number:-1:1
            % Load image
            im=imread([listing.forward{j,1}.dirpath '/' listing.forward{j,1}.im_names{i,1}]);
            % Compute optical flow
            frameGray = rgb2gray(im);
            flow = estimateFlow(opticFlow,frameGray);
            % Display optical flow
            if strcmp(draw_opticalflow,'yes')
                imshow(im)
                hold on
                plot(flow,'DecimationFactor',[5 5],'ScaleFactor',100)
                hold off
                title(sprintf('%d/%d',i,listing.forward{j,1}.im_number))
                drawnow
            end
            if mod(i,50)==0
                fprintf('Flow %d/%d \n',i,listing.forward{j,1}.im_number)
            end
            if i~=1
                Optical_flow_rev{i-1,1}=image_preprocessing(flow,net);
            end
        end
%        cd(listing.forward{j,1}.dirpath)
%        save('Optical_flow_rev','Optical_flow_rev')
%        cd(currentpath)
        reset(opticFlow)
        clear Optical_flow_rev
    end
end
if strcmp(Compute.rev.backward,'yes')
    for j=1:length(listing.backward)
        fprintf('Rev. Backward %d/%d \n',j,length(listing.backward))
        for i=listing.backward{j,1}.im_number:-1:1
            % Load image
            im=imread([listing.backward{j,1}.dirpath '/' listing.backward{j,1}.im_names{i,1}]);
            % Compute optical flow
            frameGray = rgb2gray(im);
            flow = estimateFlow(opticFlow,frameGray);
            % Display optical flow
            if strcmp(draw_opticalflow,'yes')
                imshow(im)
                hold on
                plot(flow,'DecimationFactor',[5 5],'ScaleFactor',100)
                hold off
                title(sprintf('%d/%d',i,listing.backward{j,1}.im_number))
                drawnow
            end
            if mod(i,50)==0
                fprintf('Flow %d/%d \n',i,listing.backward{j,1}.im_number)
            end
            if i~=1
                Optical_flow_rev{i-1,1}=image_preprocessing(flow,net);
            end
        end
        cd(listing.backward{j,1}.dirpath)
        save('Optical_flow_rev','Optical_flow_rev')
        cd(currentpath)
        reset(opticFlow)
        clear Optical_flow_rev
    end
end