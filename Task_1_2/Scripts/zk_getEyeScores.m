clc,clear;

folderName = 'E:\DataSet\image-saliency\ICME2017-Salient360\Salient360';
% salDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\Saliency\');
% outDir = fullfile('E:\Code\image-saliency\Image_Saliency_ZK\data\Salient360\resScores\');

salDir = fullfile('E:\Code2\zk-salient360\data\KSVD_7_7_2\');
outDir = fullfile('E:\Code2\zk-salient360\data\ScoresE\');
if ~exist(outDir, 'dir')  mkdir(outDir); end
MethodNames = {'KSVD'};
% MethodNames = {'GBVS','IT','IT2','AWS','UHM', 'AIM', 'BMS', 'CA', 'COV', 'DRFI','DSR', 'FES', 'FT', 'GC','GMR','GR','GU','HC','MC','MSS','PCA', 'RBD','RC','SEG','SeR','SIM','SR','SS',  'SUN','SWD'};
% MethodNames = {'GBVS','IT','IT2','AWS','COV', 'FES','MC','PCA','SEG','SeR','SIM','SR','SS',  'SUN'};

HeadImageList=[2,3,4,5,6,7,10,11,12,13,14,15,17,21,22,23,24,25,27,28];
EyeImageList=[29,31,32,33,34,35,36,37,38,39,41,42,43,44,45,46,47,49,51,52,54,55,56,57,58,62,63,64,66,68,76,77,80,81,82,83,84,87,88,89];

mNum = length(MethodNames);
scores = zeros(40,5);
for methodID = 1 : mNum
    iMethodName = MethodNames{methodID};
    fprintf('Processing Method: %s\r', iMethodName);  
    
    outName = [outDir 'scores_' iMethodName '_7_7_2.mat'];
    if (exist(outName, 'file')) continue; end
    
    for imgID = 1:40
        fprintf('%d/%d: \r', imgID, 40);
        
        imgNum = EyeImageList(imgID);
       
        fixationMap = load([folderName '\FixationLoc\P' num2str(imgNum) '.mat']);
        fixationMap = fixationMap.fixationMap;
        [height,width] = size(fixationMap);
        
        fileId = fopen([folderName '\HeadEyeSalMaps\SHE' num2str(imgNum) '.bin'], 'rb');        
        buf = fread(fileId, width * height, 'single');
        SalMap1= reshape(buf, [width, height])';
        fclose(fileId);
        
        iSalname = ['P' num2str(imgNum) '.png'];
        SalMap2 = im2double(imread([salDir iSalname]));
 
        [scoreKL,scoreCC,scoreNSS,scoreROC] = zk_CompareHeadEyeSalMaps(SalMap2, fixationMap, SalMap1);
        scores(imgID,:) = real([imgNum, scoreKL, scoreCC, scoreNSS, scoreROC]);

    end
    save(outName, 'scores');
    mean_scores = mean(scores(:,2:5));
    fprintf('mean scores: mKL,mCC,mNSS,mROC,  %.4f,  %.4f,  %.4f,  %.4f\n',mean_scores); 
end
