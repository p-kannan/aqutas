function[finalIm] = segProtein210430(im0,threshold,smoothingfactor)

% This is a program for extracting objects from an image.
% Original code authors : Jeny Rajan, Chandrashekar P S
% Modified code authors: Martin Schain, Pavitra Kannan

im1=medfilt2(im0,[10 10]); %Median filtering the image to remove noise%
edgeMask = edge(im1,'sobel'); %finding edges 
[imx,imy]=size(edgeMask);

msk = zeros(smoothingfactor);
msk(2:end-1,2:end-1) = 1;

thIm = im0*0;
thIm(im0>threshold) = 1;

edgeMaskSmth=conv2(double(edgeMask),double(msk),'same');%Smoothing  image to reduce the number of connected components
binMask = edgeMaskSmth*0;
binMask(edgeMaskSmth>0) = 1;

finalIm = double(binMask).*double(thIm);
finalIm(finalIm>0) = 1;


