# Finding vehicles  

Finding vehicles is application retrieving and display nearby vehicle points  with ability to display one or all of these points on mapview.

## Overview

This sample code project demonstrates how to fetch and display nearby vehicles using Alamofire as network layer, MVVM with coordinator as architecture, in Addition to use binding with RXSwift .


## Loading nearby vehicles from API and displaying it in a table

This part of project demonstrates how to display a list of vehicles using Alomofire and binding it to table view with custom cell.


## Showing one vehicle or all vehicles on a Map

This part of project demonstrates how to display a list of vehicles  and binding it to map view with custom annotation vew to display details of this annotation when user tap on it.

***Features Covered:
- Fetch a list of vehicles by 2 coordinate points . 
- View the vehicle point on map view when select it from list.
- View all vehicles points on map view.
- center mapview region on fetched vehicle points on main thread.
- use objc custom annotation view to display more details about this vehicle.
- Show activity indicator while fetching data .
- re-fetch vehicles list when user changes the map bounds.

**Enhancments in future:
- enhance updating map region when user change map bounds
- more unit testing


