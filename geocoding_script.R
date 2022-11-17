---
title: "Google API"
# credits: Shane Lynn 10/10/2013
output: html_notebook
---

if needed to clear environment
```{r}
rm(list=ls())
```


installing required packages (if not already installed)
```{r}
install.packages("ggmap")
```

loading packages
```{r}
library(ggmap)
```

set working directory
```{r}
setwd("C:/..../Geocoding") #set path
```

get input data
```{r}
infile <- "location"
origAddress <- read.csv(paste0('./', infile, '.csv'), stringsAsFactors = FALSE)
```

append state and country to increase accuracy as required
```{r}
addresses = data$Address
addresses = paste0(addresses, ", USA")
```

```{r}
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
for(i in 1:nrow(origAddress))
{
  # Print("Working...")
  result <- geocode(origAddress$Address[i], output = "latlona", source = "google")
  origAddress$lon[i] <- as.numeric(result[1])
  origAddress$lat[i] <- as.numeric(result[2])
}
# Write a CSV file containing origAddress to the working directory
write.csv(origAddress, "geocoded.csv", row.names=FALSE)
```




Function to process Google's server responses for us
```{r}
getGeoDetails <- function(address){   
   #use the gecode function to query google servers
   geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
   #now extract the bits that we need from the returned list
   answer <- data.frame(lat=NA, long=NA, accuracy=NA, formatted_address=NA, address_type=NA, status=NA)
   answer$status <- geo_reply$status
 
   #if we are over the query limit - want to pause for an hour
   while(geo_reply$status == "OVER_QUERY_LIMIT"){
       print("OVER QUERY LIMIT - Pausing for 1 hour at:") 
       time <- Sys.time()
       print(as.character(time))
       Sys.sleep(60*60)
       geo_reply = geocode(address, output='all', messaging=TRUE, override_limit=TRUE)
       answer$status <- geo_reply$status
   }
 
   #return Na's if we didn't get a match:
   if (geo_reply$status != "OK"){
       return(answer)
   }   
   #else, extract what we need from the Google server reply into a dataframe:
   answer$lat <- geo_reply$results[[1]]$geometry$location$lat
   answer$long <- geo_reply$results[[1]]$geometry$location$lng   
   if (length(geo_reply$results[[1]]$types) > 0){
       answer$accuracy <- geo_reply$results[[1]]$types[[1]]
   }
   answer$address_type <- paste(geo_reply$results[[1]]$types, collapse=',')
   answer$formatted_address <- geo_reply$results[[1]]$formatted_address
 
   return(answer)
}
 
```

control factors
```{r}
#initialise a dataframe to hold the results
geocoded <- data.frame()
# find out where to start in the address list (if the script was interrupted before):
startindex <- 1
#if a temp file exists - load it up and count the rows!
tempfilename <- paste0(infile, '_temp_geocoded.rds')
if (file.exists(tempfilename)){
       print("Found temp file - resuming from index:")
       geocoded <- readRDS(tempfilename)
       startindex <- nrow(geocoded)
       print(startindex)
}
```

Geocoding (max limit 2500 per day)
```{r}
# Start the geocoding process - address by address. geocode() function takes care of query speed limit.
for (ii in seq(startindex, length(addresses))){
   print(paste("Working on index", ii, "of", length(addresses)))
   #query the google geocoder - this will pause here if we are over the limit.
   result = getGeoDetails(addresses[ii]) 
   print(result$status)     
   result$index <- ii
   #append the answer to the results file.
   geocoded <- rbind(geocoded, result)
   #save temporary results as we are going along
   saveRDS(geocoded, tempfilename)
}
```

append lat long to data
```{r}
data$lat <- geocoded$lat
data$long <- geocoded$long
data$accuracy <- geocoded$accuracy
```
 
write output
```{r}
saveRDS(data, paste0("../data/", infile ,"_geocoded.rds"))
write.table(data, file=paste0("../data/", infile ,"_geocoded.csv"), sep=",", row.names=FALSE)
```
