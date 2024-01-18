# HeatSense

This project creates a flutter application that is capable of showing sensor data from a MoveSense device. The device is used to measure Heartrate and body temperature. The app will use the data to warn the user about heatstrokes and create events that store data from a potential heatstroke.

We will be using the MoveSense API (mdsflutter package) to communicate with the device. The application also uses the permission_handler plugin for flutter to handle permissions mainly about the usage of bluetooth.

## Repro Tour
* [images](images) Screenshots used in Readme.
* [lib](lib) Dart files for the project.
  * [BLoc](lib/BLoc) Business logic for detecting a heatstroke
  * [model](lib/model) The underlying model for the app, contains all the important classes and functionalities. 
  * [view](lib/view) The UI design of the app, only contains code that corresponds to what the user can see in the app.
  * [viewmodel](lib/viewmodel) The viewmodel is used as the link between the model and view of the app.
* [python plotting](python_plotting) Python files for plotting the stored JSON data.


## UX Design

HeatSense consists of a Home Page, a Scan Page, an Event Page and a Profile Page, the Scan Page can be accessed through a button on the Home Page and the user can easily switch between the other pages by clicking on the navigationbar. 


<img src="images/HomePage.jpg" width ="180"> <img src="images/EventPage.jpg" width ="180"> <img src="images/ProfilePage.jpg" width ="180"> <img src="images/ScanPage.jpg" width ="180">  <img src="images/EditEvent.jpg" width ="180"> 

