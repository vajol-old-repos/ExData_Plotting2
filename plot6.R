## This Compare emissions from motor vehicle sources in Baltimore City with emissions from
## LA county. A plot shows changes over time in PM emissions in these two cities.

## Check existence of a working directory
setwd("c:/")
if (!file.exists("tmp")) {
  dir.create("tmp")
}

## Set working directory
setwd("c:/tmp")

## Set URL for download
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

## Download zip archive file
download.file(fileUrl, destfile = "nei_data.zip")

## Document a date when the files have been downloaded
dateDownloaded <- date()
print(dateDownloaded)

## Unzip archive file
unzip("nei_data.zip")

## Load NEI the data into table
nei <- readRDS("summarySCC_PM25.rds")

## Load SCC the data into table
scc <- readRDS("Source_Classification_Code.rds")

## Define more user friendly coulmn names for NEI data set
names(nei) <- c("fips", "scc", "pollutant", "emissions", "type", "year")

## Create a list of "vehicle" related SCC's
vehscc <- scc[grep("vehicle",scc$Short.Name,ignore.case = TRUE), ]$SCC

## Subset NEI data set selecting only rows with "vehicle" related SCC's
neiveh <- subset(nei, scc %in% vehscc)

## Subset previous data set, selecting only rows related to Baltimore and LA county(fips 24510 and 06037) 
neivehcty <- neiveh[neiveh$fips %in% c("24510", "06037"), ]

## Summarize emissions per year and city for all "vehicle" related sources 
vehsum <- aggregate(neivehcty$emissions, by = list(neivehcty$year, neivehcty$fips), FUN = sum)

## Define more user friendly coulmn names for summarized data set
names(vehsum) <- c("year", "city", "total" )

## Initialize graphics device
png(filename = "plot6.png", width=480, height=480)

## Create a plot showing total emissions per year and city, for all "vehicle" related sources 
qplot(year, total, data = vehsum, facets = city~ ., binwidth = 2, geom="line", 
      main = "Total emissions from vehicles in Baltimore and LA per year", xlab="Year", ylab= "PM emissions")

## Close graphics device
dev.off()
