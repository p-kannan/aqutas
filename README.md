Instructions for running AQuTAS tool on MATLAB 


TABLE OF CONTENTS
-------------------------------------------------------------------------------------
    A. Prerequisites for use
    B. Instructions for running tool
    C. Troubleshooting/improvement requests


### A. PREREQUISITES FOR USE

Image format: 
- currently tested formats are .tif or .png 

Images: 
- please note that that tool requires single spheroid per image for quantification.
If your images contain multiple spheroids, use the cropping function in the tool to 
generate single spheroids


### B. INSTRUCTIONS FOR RUNNING TOOL

1. Add source code to MATLAB's path

- Launch the AQuTAS.fig file
- On the main display window (in purple color), click the button "Select folder with code" 
- In the dialog box, navigate to the folder "AQuTAS_source_code" and click ok. 

2. Crop single spheroids from microscopy images, if necessary. The tool automatically generates 
cropped images of spheroids for analysis and saves the original files in a new folder

- On the main display window (in purple color), click the button "Crop single images". 
- In the window ("Select a folder") that pops up, navigate to the folder containing the images and click ok. 
- In the window ("Define file extension") that pops up, type in the extension of your file format with 
an asterisk in front (e.g., *.tif). Click ok.
- Hover the mouse over the window "Figure 1" until a cross appears. The window can be maximized 
for improved visibility.
- Click and drag the rectangle to define the boundaries of a spheroid. 
- The rectangle can be moved around if needed or readjusted in size
- Double click the rectangle to select the area
- Continue defining rectangles until all spheroids have been defined. Note: we advise against 
selecting spheroids on the edge of the well or those not in focus
- Press Esc when finished with selecting spheroids from that well image
- A dialog window displays "Crop complete!" when the cropping is finished.
- Cropped images can be found in a subfolder called "Cropped", while original images can be found 
in a subfolder called "Original". 

3. Quantify sprouting parameters of individual spheroid sprouts

- On the main display window (in purple color), click the button "Analyze sprouts (FL)". 
- In the window ("Select a folder") that pops up, navigate to the folder containing the CROPPED images and click ok. 
- In the window ("Define file extension") that pops up, type in the extension of your file format with 
an asterisk in front (e.g., *.tif). Click OK
- When the tool completes the quantification, a new window pops up "Enter name of Excel file"
- Enter the name you wish for your results file. Click ok
- A dialog window displays "Analysis complete!" 

4. Close program

- On the main display window (in purple color), click the button "Close program" to exit the tool. 


### C. TROUBLESHOOTING/IMPROVEMENT REQUESTS

1. Code does not run
- Please add source code to the path (see instruction B.1)

2. Quantification seems funny
- Please test the code on the "AQuTAS_test_data" folder, which contains a sample image for testing the code
- Ensure that the file formats are tif or png
- Contact the author directly 
- Create a pull request 

