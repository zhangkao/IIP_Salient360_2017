function [salmat] = HeadEyeSal(img)
	
    if ( strcmp(class(img),'char') == 1 ) img = im2double(imread(img)); end
	if ( strcmp(class(img),'uint8') == 1 ) img = im2double(img); end
	[img_h,img_w,~] = size(img);
    resize_h = 1000;resize_w = 2000;
	wkimg = imresize(img,[resize_h,resize_w]);
    
    H = fspecial('gaussian',[5,5],1);
    wkimg=imfilter(wkimg,H,'same');
    
	load('dic_ksvd.mat');
	Dict=Dictionary;
	
	Region_Size=8;
	T0=1/64;
	a=0.106;
	e2=2.3;
	f=25;
	
    [X,numRow,numCol,index]=preprocessing(wkimg,Region_Size); 
    centerRow = ceil(numRow / 2);
    centerCol = ceil(numCol / 2);

    alpha=OMPerr(Dict,X,0.05);
       
    view_dis = 4*size(wkimg,1);  

    Dist = tan( (2 * pi) / (2 * 180) ) * 2 * view_dis;  
    numpatch = numCol * ceil(Dist / Region_Size);  
     
    alpha_w = size(alpha,2);
    sal=zeros(alpha_w,1);
    for i = 1:alpha_w
        
        j1 = i - numpatch;
        if ( j1 < 1) j1 = 1; end
        
        j2 = i + numpatch;
        if ( j2 > alpha_w) j2 = alpha_w; end

        for j = j1 : j2
            if(i~=j)              
                distance=Region_Size*sqrt((index(i,1)-index(j,1))^2+(index(i,2)-index(j,2))^2);                 
                if(distance <= Dist)
                    theta=atan((distance/2)/view_dis)*2*180/pi;
                    c=1/(T0*exp(a*f*(theta+e2)/e2));
                    contrast_d=norm(alpha(:,i)-alpha(:,j)); 
                    sal(i)=sal(i)+c*contrast_d;
                end
            end
        end

    end
    sal2=sal;
   
    salmap=zeros(numRow,numCol);
    salmapbias=salmap;
    for k=1:alpha_w

        patbias=sqrt((index(k,1) - centerRow) ^2 + (index(k ,2 ) - centerCol) ^2);
        sigma = 20;
        centerbias = exp((-1) * patbias /sigma );
        
        salmap(index(k,1),index(k,2))= sal2(k);
        salmapbias(index(k,1),index(k,2))=centerbias * sal2(k);
    end

    cmap = getCmap(5000,400);
    cmap = mat2gray(imresize(cmap,[img_h,img_w]));
	bmap = mat2gray(imresize(salmap,[img_h,img_w]));
    
	smap = mat2gray(bmap.*cmap+bmap+cmap);
	salmat = smap/sum(smap(:));

end

function cmap = getCmap(h,s)
	x=1:1:h;
	y=gaussmf(x,[s h/2]);
	y = mat2gray(y);
	
	ncbmap = zeros(h,2*h);
	for i = 1:h
		ncbmap(i,:)=y(i);
	end
	cmap = ncbmap;
end


function [I,numRow,numCol,index] = preprocessing(img,region_size)

	height=size(img,1);
	width=size(img,2);
	numRow=floor(height/region_size);
	numCol=floor(width/region_size);
	initRow=floor(mod(height,region_size)/2);
	initCol=floor(mod(width,region_size)/2);
	vectorSet = zeros(region_size*region_size*3,numRow * numCol);
	index=zeros(numRow*numCol,2);
	for row = 1:numRow
		for col = 1:numCol
	
		pat1=reshape(img((row-1)*region_size+1+initRow:row*region_size+initRow,(col-1)*region_size+1+initCol:col*region_size+initCol,1),region_size^2,1); 
		pat2=reshape(img((row-1)*region_size+1+initRow:row*region_size+initRow,(col-1)*region_size+1+initCol:col*region_size+initCol,2),region_size^2,1);
		pat3=reshape(img((row-1)*region_size+1+initRow:row*region_size+initRow,(col-1)*region_size+1+initCol:col*region_size+initCol,3),region_size^2,1);
		mpatch=[pat1;pat2;pat3];
		vectorSet(:,(row-1) * numCol + col) = mpatch;
		index((row-1)*numCol+col,:)=[row,col];
		end
		
	end
	
	I=vectorSet;
end