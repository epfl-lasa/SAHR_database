# SAHR Project Database
Data recordings from the SAHR project.

## Raw data of each batch of data recording
+ FingerTPS sensor recording (finger pressure sensor)
+ ATI Force/Torque sensor recording (base force/torque sensor)
+ DigiTacts sensor recording (tool pressure sensor)

## MATLAB application to visualize data and perform simple analysis
This data visualization app is available in three format:
+ MATLAB app

To install this version, open MATLAB and navigate to the folder containing the downloaded `.mlappinstall` file, then double-click the file in **Current File**.
Another way to install the app is to click the **Install App** button on the **Apps** tab, and select the `.mlappinstall` file.
A video guide is available [here](https://www.mathworks.com/videos/packaging-and-installing-matlab-apps-101563.html).

+ Standardalone desktop app

To install this version, open the **Application Compiler** from the **MATLAB Toolstrip**, on the **Apps** tab, click the **Application Compiler** icon.
+ Web app

Navigate to the folder containing the **MATLAB Web App Server** installer, and run the installer to install the **MATLAB Web App Server** and **MATLAB Runtime**.
Please refer to the MATLAB ducomentation [Install MATLAB Web App Server](https://www.mathworks.com/help/compiler/webapps/install-matlab-web-app-server.html) and [Configure MATLAB Web App Server](https://www.mathworks.com/help/compiler/webapps/configure-matlab-web-app-server.html) for detailed information.

## A short instruction to use the app

+ There are three tabs corresponding to each type of data recording:
	+ Finger TPS
	+ ATI Force/Torque
	+ DigiTacts

+ Click on one tab, drop down `Recording` to select the batch of the recording and `Subject` to choose the number of subject. For example, to visualize the data file `B03S06.mat`, choose `Recording` as `03`, and `Subject` as `06`.

+ Click `Load` button to load the source data. The length (number of samples) of data and time should appear in the fileds to the right of the button.

+ Fill the number of sample in the `Start` and `End` filds to choose the segment of to visualize. Then click `Set` button.

### **Finger TPS** and **DigiTacts**
+ Cross desired patches to visualize. The mean, variance, and amplitude of the signals should be calculated automatically.

+ Click `Plot` button to plot signals on the left panel.

+ Click `Corrcoef` button to visualize the correlation coefficient matrix on the right panel.

+ Click `Export` button to export the above-selected data segment into an independent `.mat` file.

### **ATI Force/Torque**
+ Cross desired signal channels to visualize. The mean value and standard deviation of the selected signal channel should be calculated automatically.

+ Click `Plot` button to plot signals on the left panel.

+ Click `Scatter` button to scatter recorded data samples on the right panel.

+ Click `Ellipsoid` button to fit the selected data segment using an ellipse (for 2D data) or an ellipsoid (for 3D data).
If you want to calculate the main axes of the fitted ellipse/ellipsoid, first press `Axes` and then click `Ellipsoid`.

+ Click `Export Segment` button to export the above-selected data segment into an independent `.mat` file.