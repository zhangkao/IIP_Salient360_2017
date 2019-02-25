% It takes about 10 min for one image
eyeimg = imread('P29.jpg');
headimg = imread('P2.jpg');

sal_eye = HeadEyeSal(eyeimg);
sal_head = HeadSal(headimg);

figure,imshow(sal_eye,[]);
figure,imshow(sal_head,[]);

imwrite(mat2gray(sal_eye),'P29_sal.png');
imwrite(mat2gray(sal_head),'P2_sal.png');


% clc,clear;
% imgDir = fullfile('E:\Code2\zk-salient360\data\images\');
% outDir = fullfile('E:\Code2\zk-salient360\data\Results\');
% if ~exist(outDir, 'dir')  mkdir(outDir); end
% 
% d = dir([imgDir, '*.jpg']);
% imgFiles = {d(~[d.isdir]).name};
% fileNum = length(imgFiles);
% for index = 1:fileNum
%     fprintf('%d/%d: \r', index, fileNum);
%     tic;
%     imgname = [imgDir imgFiles{index}];
%     outname = [outDir imgFiles{index}(1:end-4) '.png'];
%     if exist(outname, 'file')  continue; end
%     
%     img = imread(imgname);
%     out = HeadEyeSal(img);
%     
%     imwrite(mat2gray(out),outname);    
%     fprintf('time: %.4f s\r', toc);
% end
