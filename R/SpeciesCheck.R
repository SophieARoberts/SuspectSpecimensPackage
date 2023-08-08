#' Oprhan Species
#' 
#' Get a list of genera which have the specified number of species in.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @param Freq The specified number of species in a genera. Default is 1.
#' @return Dataframe OrphanSpeciesList with list of genera with with specified number of species.
#' @examples
#' OrphanSpecies(ExampleData$ScientificName, 2)
#' @export
OrphanSpecies <- function(SpecimenColumn, Freq = 1) {
  SpeciestList(SpecimenColumn)
  FreqTable <- table(AllSpeciestList$Genus)
  FreqTableDF <- data.frame(FreqTable)
  FreqTableDF$Var1 <- as.character(FreqTableDF$Var1)
  
  Genus <- NA
  Frequency <- NA
  SpeciesFreqList <- cbind(Genus, Frequency)
  SpeciesFreqList <- as.data.frame(SpeciesFreqList)
  row <- FreqTableDF$Var1
  N <- 1
  for (row in 1:nrow(FreqTableDF)) {
    GetFreq <- FreqTableDF[row, ]$Freq
    Genus <- FreqTableDF[row, ]$Var1
    if (GetFreq <= Freq) {
      print(Genus)
      SpeciesFreqList[N, ] <- list(Genus, GetFreq)
      N <- N + 1
    }
  }
  Genus <- NA
  Species <- NA
  Frequency <- NA
  OrphanSpeciesList <<- cbind(Genus, Species, Frequency)
  OrphanSpeciesList <<- as.data.frame(OrphanSpeciesList)
  allGenus <- AllSpeciestList$Genus
  genus <- SpeciesFreqList$Genus
  I <- 1
  for (allGenus in 1:nrow(AllSpeciestList)) {
    for (genus in 1:nrow(SpeciesFreqList)) {
      if (AllSpeciestList[allGenus, ]$Genus == SpeciesFreqList[genus, ]$Genus) {
        Genus <- SpeciesFreqList[genus, ]$Genus
        Species <- AllSpeciestList[allGenus, ]$SpecimenColumn
        Frequency <- SpeciesFreqList[genus, ]$Frequency
        OrphanSpeciesList[I, ] <<- list(Genus, Species, Frequency)
        I <- I + 1
      }
    }
  }
  
}




#' Oprhan Specimens
#' 
#' Get a list of species which have the specified number of specimens in.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @param Freq The specified number of specimens in a species Default is 1.
#' @return Dataframe OrphanSpecimensList with list of species with with specified number of specimens
#' @examples
#' OrphanSpecimens(ExampleData$ScientificName, 2)
#' @export
OrphanSpecimens <- function(SpecimenColumn, Freq = 1) {
  FreqTable <- table(SpecimenColumn)
  FreqTableDF <- data.frame(FreqTable)
  FreqTableDF$SpecimenColumn <- as.character(FreqTableDF$SpecimenColumn)
  Species <- NA
  Frequency <- NA
  OrphanSpecimensList <<- cbind(Species, Frequency)
  OrphanSpecimensList <<- as.data.frame(OrphanSpecimensList)
  row <- FreqTableDF$SpecimenColumn
  N <- 1
  for (row in 1:nrow(FreqTableDF)) {
    GetFreq <- FreqTableDF[row, ]$Freq
    Specimen <- FreqTableDF[row, ]$SpecimenColumn
    if (GetFreq <= Freq) {
      print(Specimen)
      OrphanSpecimensList[N, ] <<- list(Specimen, GetFreq)
      N <- N + 1
    }
  }
  
}

#' Species List
#' 
#' @noRd
#' @import plyr
SpeciestList <- function(SpecimenColumn) {
  GenusSplit <- strsplit(SpecimenColumn, split = " ")
  Genus <- sapply(GenusSplit, "[", 1)
  SpecimenList <<- cbind(Genus, SpecimenColumn)
  SpecimenList <<- as.data.frame(SpecimenList)
  AllSpeciestList <<- SpecimenList %>% distinct()
  AllSpeciestList <<- na.omit(AllSpeciestList)
}
