clc,clear;

folderName = 'E:\DataSet\image-saliency\ICME2017-Salient360\Salient360';
salDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\Saliency\');
outDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\resScores\');
if ~exist(outDir, 'dir')  mkdir(outDir); end

MethodNames = {'GBVS','IT','IT2','AWS','UHM', 'AIM', 'BMS', 'CA', 'COV', 'DRFI','DSR', 'FES', 'FT', 'GC','GMR','GR','GU','HC','MC','MSS','PCA', 'RBD','RC','SEG','SeR','SIM','SR','SS',  'SUN','SWD'};

HeadImageList=[2,3,4,5,6,7,10,11,12,13,14,15,17,21,22,23,24,25,27,28];
EyeImageList=[29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,51,52,54,55,56,57,58,62,63,64,66,68,76,77,80,81,82,83,84,87,88,89];

mNum = length(MethodNames);
scores = zeros(40,5);
for methodID = 1 : mNum
    iMethodName = MethodNames{methodID};
    outName = [outDir 'scores_' iMethodName '.mat'];
%     if (exist(outName, 'file')) continue; end
    
    for imgID = 1:40
        imgNum = EyeImageList(imgID);
        iSalname = ['P' num2str(imgNum) '_s_' iMethodName '.png'];
        SalMap2 = im2double(imread([salDir iMethodName filesep iSalname]));
        [scoreKL,scoreCC,scoreNSS,scoreROC] = CompareHeadEyeSalMaps(SalMap2,folderName,imgNum);
		scores(imgID,:) = real([imgNum,scoreKL,scoreCC,scoreNSS,scoreROC]);

    end
    save(outName, 'scores');
    mean_scores = mean(scores(:,2:5));
    fprintf('mean scores: mKL,mCC,mNSS,mROC,  %.4f,  %.4f,  %.4f,  %.4f\n',mean_scores); 
end
