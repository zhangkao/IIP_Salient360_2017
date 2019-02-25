clc,clear;

folderName = 'E:\DataSet\image-saliency\ICME2017-Salient360\Salient360';
% salDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\Saliency\');
% outDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\resScores\');

salDir = fullfile('E:\Code2\zk-salient360\data\KSVD_7_7_2\');
outDir = fullfile('E:\Code2\zk-salient360\data\ScoresH\');
if ~exist(outDir, 'dir')  mkdir(outDir); end
MethodNames = {'KVSD'};

HeadImageList=[2,3,4,5,6,7,10,11,12,13,14,15,17,21,22,23,24,25,27,28];
EyeImageList=[29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,51,52,54,55,56,57,58,62,63,64,66,68,76,77,80,81,82,83,84,87,88,89];

NUM_IMG = 20;

mNum = length(MethodNames);
scores = zeros(NUM_IMG,3);
for methodID = 1 : mNum
    iMethodName = MethodNames{methodID};
    fprintf('Processing Method: %s\r', iMethodName);  
    
    outName = [outDir 'scores_' iMethodName '_7_7_2.mat'];
    if (exist(outName, 'file')) continue; end
    
    for imgID = 1:20
        fprintf('%d/%d: \r', imgID, NUM_IMG);
        
        imgNum = HeadImageList(imgID);
                
        salmap_info = imfinfo([folderName '\HeadSalMaps\SH' num2str(imgNum) '.jpg']);
        height = salmap_info.Height;
        width = salmap_info.Width;
        iSalname = ['P' num2str(imgNum) '.png'];
        SalMap2 = im2double(imread([salDir iSalname]));
                
%         if (size(SalMap2, 1)~=height || size(SalMap2, 2)~=width)
%             SalMap2 = imresize(SalMap2, [height,width]);
%         end
        SalMap2 = SalMap2/sum(SalMap2(:));
 
        [scoreKL,scoreCC] = CompareHeadMaps(SalMap2, folderName, imgNum);
        scores(imgID,:) = real([imgNum, scoreKL, scoreCC]);

    end
    save(outName, 'scores');
    mean_scores = mean(scores(:,2:3));
    fprintf('mean scores: mKL,mCC  %.4f,  %.4f  \n',mean_scores); 
end
