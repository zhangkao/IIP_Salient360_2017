
Task 1: HeadEyeSal.p
Task 2: HeadSal.p

Run the demo.m to start the models.
It takes about 10 min for one image

%%%%%%%%%%%
eyeimg = imread('P29.jpg');
headimg = imread('P2.jpg');

sal_eye = HeadEyeSal(eyeimg);
sal_head = HeadSal(headimg);

figure,imshow(sal_eye,[]);
figure,imshow(sal_head,[]);

imwrite(mat2gray(sal_eye),'P29_sal.png');
imwrite(mat2gray(sal_head),'P2_sal.png');