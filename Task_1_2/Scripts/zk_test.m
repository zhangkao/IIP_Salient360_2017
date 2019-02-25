SalMap2 = im2double(imread('E:\DataSet\image-saliency\ICME2017-Salient360\Salient360\cbmap.png'));

folderName = 'E:\DataSet\image-saliency\ICME2017-Salient360\Salient360';
% imgNum = 29;
% 
% [scoreKL,scoreCC,scoreNSS,scoreROC] = CompareHeadEyeSalMaps(SalMap2,folderName,imgNum)

HeadImageList=[2,3,4,5,6,7,10,11,12,13,14,15,17,21,22,23,24,25,27,28];
EyeImageList=[29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,51,52,54,55,56,57,58,62,63,64,66,68,76,77,80,81,82,83,84,87,88,89];

scores = zeros(40,5);
for i = 1:40
    fprintf('%d/%d: \r', i, 40);
    imgNum = EyeImageList(i);
    [scoreKL,scoreCC,scoreNSS,scoreROC] = CompareHeadEyeSalMaps(SalMap2,folderName,imgNum);
    scores(i,:) = real([imgNum,scoreKL,scoreCC,scoreNSS,scoreROC]);
end
save([folderName '\cbscore.mat'], 'scores');
mean_scores = mean(scores(:,2:5));
fprintf('mean scores: mKL,mCC,mNSS,mROC,  %.4f,  %.4f,  %.4f,  %.4f\n',mean_scores);
