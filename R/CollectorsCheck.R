#' Species and Collectors
#' 
#' Get a list of species which have specified number of collectors.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' #' @param NoCollectors The specified number of collectors. Default is 1.
#' @param ... All the columns which contain collector names, separated by (,)
#' @return Dataframe GetCollectors with list of species and collector name for specified number of collectors.
#' @examples
#' SpeciesCollectors(ExampleData$ScientificName, ExampleData$Collector1, ExampleData$Collector2, ExampleData$Collector3, 2)
#' @export
#' @import plyr
SpeciesCollectors <- function(SpecimenColumn, NoCollectors = 1, ...) {
  Collectors <- list(...)
  CollectorData <- data.frame(SpecimenColumn)
  i <- 1
  for (c in Collectors) {
    CollectorNumber = paste("Collector", i, sep = "")
    i <- i + 1
    CollectorData[CollectorNumber] <- c
  }
  N <- 1
  Species <- NA
  Collectors <- NA
  GetCollectors <<- cbind(Species, Collectors)
  GetCollectors <<- as.data.frame(GetCollectors)
  OnlySpecies <- data.frame(SpecimenColumn)
  OnlySpecies <- OnlySpecies %>% distinct()
  CheckSpecies <- OnlySpecies$SpecimenColumn
  CheckSpecimen <- CollectorData$SpecimenColumn
  print(paste("Number of species:", nrow(OnlySpecies)))
  CollectorList <- NA
  
  for (CheckSpecies in 1:nrow(OnlySpecies)) {
    Species <- OnlySpecies[CheckSpecies, "SpecimenColumn"]
    print(paste("Species:", CheckSpecies, Species))
    CollectorList <- NA
    for (CheckSpecimen in 1:nrow(CollectorData)) {
      Specimen <- CollectorData[CheckSpecimen, "SpecimenColumn"]
      if (Specimen == Species) {
        for(c in 2:ncol(CollectorData)) {
          CollectorList <- append(CollectorList, 
                                 CollectorData[c][CheckSpecimen, ])
        }
      }
    }
    CollectorList <- sort(CollectorList)
    CollectorList <- data.frame(CollectorList)
    CollectorList <- CollectorList %>% distinct()
    RemoveBlanks <- grepl(" ", CollectorList$CollectorList)
    CollectorList <- CollectorList %>% filter(RemoveBlanks)
    CollectorListLength <- nrow(CollectorList)
    if(CollectorListLength <= NoCollectors) {
      CollectorList <- as.list(CollectorList)
      GetCollectors[N, ] <<- list(Species, CollectorList)
      N <- N + 1
    }
  }
}


