#' Species With One Collector
#' 
#' Get a list of species which only have one collector.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @param ... All the columns which contain collector names, separated by (,)

#' @return Dataframe OneCollector with list of species and collector name which only have one collector
#' @examples
#' SpeciesCollectors(ExampleData$ScientificName, ExampleData$Collector1, ExampleData$Collector2, ExampleData$Collector3)
#' @export
#' @import plyr
SpeciesCollectors <- function(SpecimenColumn, ...) {
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
  Collector <- NA
  OneCollector <<- cbind(Species, Collector)
  OneCollector <<- as.data.frame(OneCollector)
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
    if(CollectorListLength == 1) {
      OneCollector[N, ] <<- list(Species, CollectorList[1,])
      N <- N + 1
    }
  }
}


