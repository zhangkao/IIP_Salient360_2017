clear, close all

wkdir = fullfile('E:\Code\image-saliency\Salient360_ZK\data\Salient360\Results\Scores\');
outdir = fullfile('E:\Code\image-saliency\Salient360_ZK\data\Salient360\Results\');

d = dir([wkdir, '*.mat']);
imgFiles = {d(~[d.isdir]).name};
fileNum = length(imgFiles);

% meanS = zeros(fileNum);
for i = 1:fileNum
    temName = [wkdir imgFiles{i}];
    S = load(temName);
    S = S.scores;
    
    tms = mean(S(:,2:5));
    
    mS(i).name = imgFiles{i}(8:end-4);
    mS(i).msKL = tms(1);
    mS(i).msCC = tms(2);
    mS(i).msNSS = tms(3);
    mS(i).msAUC = tms(4);
    mS(i).scores = S;
        
end

save([outdir 'mS.mat'],'mS');