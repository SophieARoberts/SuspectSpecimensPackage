#' One Specimen List
#' 
#' Get a list of species which only have one specimen for that species.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @return Dataframe OneSpecimenList with list of Species with only one specimen
#' @examples
#' OneSpecimen(ExampleData$ScientificName)
#' @export
#' @import plyr

OneSpecimen <- function(SpecimenColumn) {
  SpeciestList(SpecimenColumn)
  OneSpecimenList <<- subset(SpecimenList,
                             !(duplicated(SpecimenList$SpecimenColumn)|duplicated(SpecimenList$SpecimenColumn, fromLast = TRUE)))
  OneSpecimenList <<- OneSpecimenList[order(OneSpecimenList$SpecimenColumn), ]
  OneSpecimenList <<- as.data.frame(OneSpecimenList)
  
}

#' One Species List
#' 
#' Get a list of genera which only have one species for that genus
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @return Dataframe OneSpeciesList with list of genera with only one species
#' @examples
#' OneSpecies(ExampleData$ScientificName)
#' @export
#' @import plyr

OneSpecies <- function(SpecimenColumn) {
  SpeciestList(SpecimenColumn)
  OneSpeciesList <<- subset(AllSpeciestList, !(duplicated(AllSpeciestList$Genus)|duplicated(AllSpeciestList$Genus, fromLast = TRUE)))
  OneSpeciesList <<- OneSpeciesList[order(OneSpeciesList$SpecimenColumn), ]
  OneSpeciesList <<- as.data.frame(OneSpeciesList)
}
