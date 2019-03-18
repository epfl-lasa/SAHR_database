# SAHR Project Database
Data recordings from the SAHR project.

## Database

### Sensor recordings
Each data file corresponds contains the following sensor datas recorded from one subject in each recording batch:
+ FingerTPS sensor recording (finger pressure sensor)
+ ATI Force/Torque sensor recording (base force/torque sensor)
+ DigiTacts sensor recording (tool pressure sensor)

### Motion segmentations
The recorded videos are manually labelled splited into pieces of motion segments, according to the content of the video.
Each row of the `csv` (or `ods`) file contains information of one labelled motion segment: segment label (e.g. `Execution`), start frame, end frame. 
The frame number represents the time from the starting of the video recording (frequency: 50Hz).

## MATLAB Application for Data Visualization and Preliminary Analysis
This data visualization app is available in three format:
+ MATLAB App
+ Standalone Desktop App
+ Web App

## Installation Guide
### MATLAB App
To install this version, open MATLAB and navigate to the folder containing the downloaded `mlappinstall` file, then double-click the file in **Current File**.
Another way to install the app is to click the **Install App** button on the **Apps** tab, and select the `mlappinstall` file.
A video guide is available [here](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-101563.html).

### Standardalone Desktop App
To install this version, open the **Application Compiler** from the **MATLAB Toolstrip**, on the **Apps** tab, click the **Application Compiler** icon.
    
### Web App
Navigate to the folder containing the **MATLAB Web App Server** installer, and run the installer to install the **MATLAB Web App Server** and **MATLAB Runtime**.
Please refer to the MATLAB ducomentation [Install MATLAB Web App Server](https://www.mathworks.com/help/compiler/webapps/install-matlab-web-app-server.html) and [Configure MATLAB Web App Server](https://www.mathworks.com/help/compiler/webapps/configure-matlab-web-app-server.html) for detailed information.

## How to Use This App
### General settings and data loading
1. There are three tabs corresponding to each type of data recording:
	+ Finger TPS
	+ ATI Force/Torque
	+ DigiTacts
Click on one tab, drop down `Recording` to select the batch of the recording and `Subject` to choose the number of subject. For example, to visualize the data file `B03S06.mat`, choose `Recording` as `03`, and `Subject` as `06`.

2. Click `Load` button to load the source data. The length (number of samples) of data and time should appear in the fileds to the right of the button.

3. Fill the number of sample in the `Start` and `End` filds to choose the segment of to visualize. Then click `Set` button.

### _Finger TPS_ and _DigiTacts_
4. Cross desired patches to visualize. The mean, variance, and amplitude of the signals should be calculated automatically.

5. Click `Plot` button to plot signals on the left panel.

6. Click `Corrcoef` button to visualize the correlation coefficient matrix on the right panel.

7. Click `Export` button to export the above-selected data segment into an independent `mat` file.

### _ATI Force/Torque_
4. Cross desired signal channels to visualize. The mean value and standard deviation of the selected signal channel should be calculated automatically.

5. Click `Plot` button to plot signals on the left panel.

6. Click `Scatter` button to scatter recorded data samples on the right panel.

7. Click `Ellipsoid` button to fit the selected data segment using an ellipse (for 2D data) or an ellipsoid (for 3D data).
If you want to calculate the main axes of the fitted ellipse/ellipsoid, first press `Axes` and then click `Ellipsoid`.

8. Click `Export Segment` button to export the above-selected data segment into an independent `mat` file.
