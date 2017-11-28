%Inclass 14
%GB comments
1 100 Could run a loop on the threshold parameters and define the “best” mask
2a 100 
2b 100 


%Work with the image stemcells_dapi.tif in this folder

% (1) Make a binary mask by thresholding as best you can
%Xiaotong Lu
 I=imread('stemcells_dapi.tif');
img_bw=I>270;
imshow(img_bw,[])


% (2) Try to separate touching objects using watershed. Use two different
% ways to define the basins. (A) With erosion of the mask (B) with a
% distance transform. Which works better in this case?
%Xiaotong Lu
I=imread('stemcells_dapi.tif');
img_bw=I>270;
imshow(img_bw,[])
%A:work with erosion
CC=bwconncomp(img_bw);
stats=regionprops(CC,'Area');
area=[stats.Area];
AA=mean(area)+std(area);
fusedcandidates=area>AA;
sublist=CC.PixelIdxList(fusedcandidates);
sublist=cat(1,sublist{:});
fusedmask=false(size(I));
fusedmask(sublist)=1;
s=round(1.2*sqrt(mean(area))/pi);
nucmin=imerode(fusedmask,strel('disk',s));
outside=~imdilate(fusedmask,strel('disk',1));
basin=imcomplement(bwdist(outside));
basin=imimposemin(basin,nucmin|outside);
pcolor(basin);shading flat;
L=watershed(basin);
imshow(L,[]);colormap('jet');caxis([0 20]);
newmask=L>1|(img_bw-fusedmask);
imshow(newmask,'InitialMagnification','fit');
%XiaotongLu
%B: work with distance transform
D=bwdist(~img_bw);
D=-D;
D(~img_bw)=-Inf;
L=watershed(D);
L(~img_bw)=0;
rgb=label2rgb(L,'jet',[.5 .5 .5]);
figure;
imshow(rgb,'InitialMagnification','fit');
%Xiaotong Lu
In this case, working with distance transform is better than working with erode. 
