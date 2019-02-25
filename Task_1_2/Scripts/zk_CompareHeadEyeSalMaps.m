function [scoreKL,scoreCC,scoreNSS,scoreROC]=zk_CompareHeadEyeSalMaps(SalMap2,fixationMap, SalMap1)

% This code measures the similarity between two equirectangular format
% saliency maps. It needs 3 parameters as inputs

% SalMap2: The saliency map to be tested against the ground-truth. Ensure
%          that we need this in equirectangular format and it must have 
%          the same dimensions as the input image.
% folderName: The root folder where all scanpaths and head-eye saliency 
%              maps are stored. This folder must have the Scanpaths and 
%              HeadEyeSalMaps nested within it. 
% It outputs 4 different scores.
%imgNum: An integer argument denoting the image Number you want to test.
%scoreKL : The KL-Divergence score between the saliency maps
%scoreCC : The correltion score between the two saliency maps
%scoreNSS : The normalised Scanpath saliency between the two maps
%scoreROC : The ROC score between the two maps



%% add by zk
if size(SalMap2, 1)~=size(fixationMap, 1) || size(SalMap2, 2)~=size(fixationMap, 2)
    SalMap2 = imresize(SalMap2, size(fixationMap));
end

if nargin < 3
    scoreKL = 0;
    scoreCC = 0;
    scoreNSS = NSS(SalMap2, fixationMap);
    [scoreROC,~,~,~] = AUC_Judd(SalMap2, fixationMap);
    return;
end

%% generate regular sampling points over the viewing sphere
N=floor(4*pi*100000);   %we sample the sphere at every 100000 times for every steradian
width=size(SalMap1,2);
height=size(SalMap1,1);
sampPoints=SpiralSampleSphere(N,0);
spOne=zeros(N,1); spTwo=zeros(N,1);
for k=1:N
    ang=atan2(sampPoints(k,2),sampPoints(k,1));
    if ang<0
        ang=ang+(2*pi);
    end;
    xCoord=max(min(1+floor(width*(ang/(2*pi))),width),1);                                                 % mapping the spherical to equirectangular
    yCoord=max(min(1+floor(height*(asin(sampPoints(k,3)/norm([sampPoints(k,:)]))/pi+0.5)),height),1);     % mapping the spherical to equirectangular
    spOne(k)=SalMap1(yCoord,xCoord);
    spTwo(k)=SalMap2(yCoord,xCoord);
end;

%% get the metrics at these sampled points
scoreKL = KLdiv(spOne, spTwo);
scoreCC = CC(spOne, spTwo);
scoreNSS = NSS(SalMap2, fixationMap);
[scoreROC,~,~,~] = AUC_Judd(SalMap2, fixationMap);



