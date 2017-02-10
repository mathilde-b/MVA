addpath(genpath('/Users/jules/Desktop/MVA/Object recognition/Project/Matlab/cnnFlow-v2.11'));

gpu = 0 ; % ID of the GPU to use, set to 0 to run on CPU
stride = [1 1 4 4 4] ; % Absolute resolution of the feature maps at each layer, relatively to the original input (must be decreasing, except for the very last layer, where a bilinear upsampling is allowed)
nRecurrentIterations = 3 ; % Usually 3 is best (more makes noisy results, fewer is less accurate; ideally you should use the same number for testing as used for training)

% Evaluate the network on the validation (=training in our case) and test splits
flow('modelId',1,'runTrVaTe',[0 1 1],'usegpu',gpu,'batchsize',1,'persistentBatchLoader',false,...
    'nFrames',3,'bidirectionalFlow',false,'maskBorders',false,'saveVisualizations',[0 1 1],...
    'cropInput',false,'leftRightSplit',false,'stride',stride,'continue',true,'nRecurrentIterations',...
    nRecurrentIterations,'fixBordersSmoothing',true,'displayWeights',false) ;
