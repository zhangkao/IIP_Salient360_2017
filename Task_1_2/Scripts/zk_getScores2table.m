clc,clear;

folderName = 'E:\DataSet\image-saliency\ICME2017-Salient360\Salient360';

MethodNames = {'SEG', 'IT', 'IT2', 'GBVS', 'AIM', 'SIM','SUN', 'SeR', 'SWD', 'SS', 'CA', 'SR', 'GR', 'MC', 'BMS','COV', 'FES','DSR', 'PCA', 'RBD', 'DRFI'};
salDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\Saliency\');
HeadImageList=[2,3,4,5,6,7,10,11,12,13,14,15,17,21,22,23,24,25,27,28];
EyeImageList=[29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,51,52,54,55,56,57,58,62,63,64,66,68,76,77,80,81,82,83,84,87,88,89];

mNum = length(MethodNames);
scores = struct;
for methodID = 1 : mNum
    iMethodName = MethodNames{methodID};
    outName = [salDir iMethodName filesep 'scores_' iMethodName '.mat'];
%     if (exist(outName, 'file')) continue; end
    
    for imgID = 1:40
        imgNum = EyeImageList(imgID);
        iSalname = ['P' num2str(imgNum) '_s_' iMethodName '.png'];
        SalMap2 = im2double(imread([salDir iMethodName filesep iSalname]));
        [scoreKL,scoreCC,scoreNSS,scoreROC] = CompareHeadEyeSalMaps(SalMap2,folderName,imgNum);
%         scores(imgID,:) = real([imgNum,scoreKL,scoreCC,scoreNSS,scoreROC]);
        scores(imgID).name = imgNum;
        scores(imgID).scoreKL = real(scoreKL);
        scores(imgID).scoreCC = real(scoreCC);
        scores(imgID).scoreNSS = real(scoreNSS);
        scores(imgID).scoreROC = real(scoreROC);
    end
    save(outName, 'scores');
%     mean_scores = mean(scores(:,2:5));
end
