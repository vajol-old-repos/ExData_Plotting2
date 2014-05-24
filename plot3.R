## This script gives an answer, of all four source types (point, nonpoint, onroad, nonroad)
## which ones have seen decrease or increase of emissions from PM2.5 in the city of Baltimore 
## from 1999 to 2008? A plot showis the total PM2.5 emission from all sources per year and source type.

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

## Create a subset of NEI data set, selecting only rows related to Baltimore (fips=24510) 
neibal <- nei[nei$fips == "24510", ]

## Summarize emissions per year and source type (point, nonpoint, onroad, nonroad)
balsum <- aggregate(neibal$emissions, by = list(neibal$year, neibal$type), FUN = sum)

## Define more user friendly coulmn names for summarized data set
names(balsum) <- c("year", "type", "total")

## Initialize graphics device
png(filename = "plot3.png", width=480, height=480)

## Create a plot showing total emissions per year and source type for city of Baltimore
qplot(year, total, data = balsum, facets = type~ ., binwidth = 2, geom="line", 
      main = "Total emissions in Baltimore per year and source type", xlab="Year", ylab= "PM emissions")

## Close graphics device
dev.off()