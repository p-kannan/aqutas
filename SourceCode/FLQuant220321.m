% Last updated: 21 March 2022
% Authors: Pavitra Kannan, Martin Schain
%
% This code quantifies HUVEC spheroid sprouting in fibrin gels

%% Select directory for batch processing

%Select directory
% [name] = uigetdir('','Select a directory');
% if isequal(name, 0) 
%     dName= '';
% else
%     dName = [name];
%     cd(dName);
% end

%% Create list in directory using file extensions
prompt = {'Enter the file extension of the cropped image files (e.g., *.tif or *.png'};
dlg_title = 'Define file extension';
num_lines = 1;
def = {'*.tif'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
gfpCropDir=dir(answer{1});

%% Segment and skeletonize cropped files

%Set thresholds
sf = 100;
count = 0;

%%Perform segmentation and skeletonization on each file
for m = 1:length(gfpCropDir)
    count = count + 1;
    
    %%Read images and filter
    gfp1 = imread(gfpCropDir(m).name); %reads in invididual file
    filtgfp=medfilt2(gfp1,[1 1]); %applies median filtering. Images MUST BE grayscale(i.e., not RGB)
    gfp2 = adapthisteq(filtgfp); %normalizes image histogram
        
    %%Create mask for entire spheroid including sprouts
    noise=nonzeros(double(gfp2)); %calculates background values
    level = graythresh(gfp2); %uses Otsu's thresholding method
    SproutTh=median(noise)+(level*std(noise)); %calculates threshold for binarization for image
    TotalMask=(segProtein210430(gfp2,SproutTh,sf)); %generates binary spheroid mask
       
    %%Remove small objects from the Total Mask
    cc1 = bwconncomp(TotalMask); 
    stats = regionprops(cc1);
    statsthreshold = 10; %number can be altered depending on pixels that need removing
    removeMask = [stats.Area]<statsthreshold; %removes pixels smaller than 10
    TotalMask(cat(1,cc1.PixelIdxList{removeMask})) = false;
    TotalPxls=length(find(TotalMask>0));

    %%Create mask for center of spheroid
    filtgfp1=medfilt2(filtgfp,[10 10]); % smooth out noise to find center mass
    BW = imbinarize(filtgfp1); %binarize spheroid center
    Centre = imfill(BW, 'holes'); %fill holes
    se = strel('diamond',10);
    dilatedCentre0 = imdilate(Centre,se); %dilate spheroid center mask
    dilatedCentre1 = bwareafilt(dilatedCentre0, 1); %keeps the largest object in the image
    SproutArea=TotalMask-dilatedCentre1; %remove center from total mask to find sprouting area
    SproutAreaPxls=length(find(SproutArea>0));
    
    %%Create initial skeleton (includes both body and sprouting area)
    BinarySproutMask = logical(SproutArea);
    SproutSkeleton = bwskel(logical(TotalMask), 'MinBranchLength', 1); %skeletonize sprout
    
    %%Pruning skeleton (dilate centre to remove more of the body from skeleton)
    se1 = strel('disk',2); 
    dilatedCentre2 = imdilate(dilatedCentre1,se1);
    SubtractedSproutMask = SproutSkeleton-dilatedCentre2; %subtracts the center from the sprout skeleton
    IntermediateSproutMask1 = SubtractedSproutMask > 0;

    %%Count number of sprouts, length of sprouts from Sprout Skeleton
    cc = bwconncomp(IntermediateSproutMask1,8); 
    S = regionprops(cc,'Area','MajorAxisLength', 'PixelList'); 
    statsthreshold1 = 2; 
    removeMask1 = [S.Area]<statsthreshold1;
    IntermediateSproutMask1(cat(1,cc.PixelIdxList{removeMask1})) = false;
    imwrite(IntermediateSproutMask1, ['Skel_' num2str(gfpCropDir(m).name)],'png'); 
    
    %%Recount number of sprouts after filtering out small ones
    cc2 = bwconncomp(IntermediateSproutMask1);
    TotalNumExtensions = cc2.NumObjects;
    S2 = regionprops(cc2,'Area','MajorAxisLength', 'PixelList'); %find length and ID of each sprout
    labeledImage = labelmatrix(cc2);
    coloredLabels = label2rgb(labeledImage, 'hsv', 'k', 'shuffle');
    SumOfSprouts = sum([S2(:).MajorAxisLength]);
  
    %%Dilate original centre mask once more to find nodes
    se3 = strel('disk',3);
    dilatedCentre3 = imdilate(dilatedCentre2,se3);
    edgeMask = edge(dilatedCentre3,'sobel');
    
    %%Dilate edge mask to enhance overlap with nodes
    se4 = strel('square',2);
    edgeMask1 = imdilate(edgeMask,se4);
    
    %%Find overlap areas between dilated centre and sprouts vs migrated cells
    NumOfMigratedCells = 0;
    NumOfSprouts = 0;
    
    uniqueValues = unique(labeledImage);
    uniqueValues(uniqueValues == 0) = []; %removes 0 (the background)
    
    for ii = 1:length(uniqueValues)
        i = uniqueValues(ii);
        newImage = labeledImage*0;
        newImage(labeledImage==i) = 1;
          
       %%find overlap:
        summedImage = newImage + uint8(edgeMask1);
        if max(summedImage(:)) == 1
            NumOfMigratedCells = NumOfMigratedCells+1;
            continue
        elseif max(summedImage(:)) == 2
            sproutLength(i) = sum(newImage(:));
            NumOfSprouts = NumOfSprouts+1;
        else
            error ('Some weird annotation in the image')
        end

        %%Create plots for each image
        f=figure('visible','off');
        subplot(2,4,1);
        imagesc(gfp1);
        title('Original image scaled');

        subplot(2,4,2);
        imshow(TotalMask);
        title('Segmentation');

        subplot(2,4,3);
        imshow(SproutSkeleton);
        title('Initial skeleton');

        subplot(2,4,4);
        imshow(dilatedCentre1);
        title('Spheroid centre');

        subplot(2,4,5);
        imshow(SproutArea);
        title('Sprout area');

        subplot(2,4,6);
        imshow(IntermediateSproutMask1);
        title('Final skeleton');

        subplot(2,4,7);
        imagesc(coloredLabels);
        title('All extensions');

        subplot(2,4,8);
        imagesc(summedImage);
        title('Test image');

        saveas(f, ['Plot_' num2str(gfpCropDir(m).name)],'tiff');
    
        %%Save subplot images
        imwrite(TotalMask, ['Seg_' num2str(gfpCropDir(m).name)],'png'); 
        
      end

    %%Define measurement outputs
    output{1+m,2} = TotalPxls;
    output{1+m,3} = SproutAreaPxls;
    output{1+m,4} = NumOfMigratedCells;
    output{1+m,5} = NumOfSprouts;
    output{1+m,6} = SumOfSprouts;

 end


%% Move files into respsective folders

%%Makes three new folders
mkdir Segmented
mkdir Plots
mkdir Skeletons

%%Move segmented files, skeletons, and plots
movefile('Seg*', 'Segmented');
movefile('Plot*', 'Plots');
movefile('Skel*', 'Skeletons');

%% Write CSV file

%%Define column titles
output{1,1} =  'Image';
output{1,3} =  'Total pxls';
output{1,4} =  'Sprout pxls';
output{1,5} =  'Number of non-associated sprouts';
output{1,6} =  'Number of associated sprouts';
output{1,7} =  'Cumulative sprout length';

%%Define rows
for s=1:length(gfpCropDir)
    output{1+s,1} = gfpCropDir(s).name;
end

%%Create excel output
prompt = {'Enter name of Excel file'};
dlg_title = 'Name Excel file';
num_lines = 1;
def = {'Measurements'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
cell2csv151006([answer{1} '.csv'],output); 
