# Mapping-pick-drop-points
Assignment on mapping and anlysing pick up and drop of university transport service

## Background
[Stingerette](https://www.pts.gatech.edu/shuttles/stingerette/) is a demand-response, shared-ride transportation service for Georgia Tech students – available seven days a week from 8:00 PM to 3:15 AM (excluding Institute holidays and during home football games) – aimed to provide safe and efficient evening transportation on Georgia Tech’s campus and the neighborhoods in-between. 

The rides are requested via website or android app. Each vehicle is equipped to note all the requests and the status of the request as entered by the driver.

## Data Available:
- Trip ID
- Date of entry
- Time of entry
- Pick up location (address)
- Drop off location (address)
- No. of passengers

for the month of January, 2018

## Analysis Method
- Geocoding of pick up location and drop off location ([using Batch Geocoding with R and Google maps](https://www.shanelynn.ie/massive-geocoding-with-r-and-google-maps/))
- Creation of zones within university campus to categorise locations (based on Atlanta Regional Commission (ARC) Traffic Analysis Zone (TAZ) boundaries, major street lines and land use patterns)
- Assigning of locations to zones (using ArcGIS)
- Creating OD matrix and flow map of pick ups and drops

## Result
![image](https://user-images.githubusercontent.com/29395793/202447832-9b9e65c7-c15d-45de-bf52-00899e247eff.png)

---
Team members: Pooja Rao, Chris McIntosh, Rebecca Van Dyke, John Saxton
