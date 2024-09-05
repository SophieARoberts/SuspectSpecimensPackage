#' Suspect Species From Frequency
#' 
#' Get list of suspect species which have a specified frequency any vice county they are found in. Also allows you to view a dataframe: FilterZeros containing the frequency for every vice county for a species.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @param VCColumn The column where the vice county is located in the dataset
#' @param Freq The specified frequency. Default is 1.
#' @return Dataframe SuspectSpecies with list of suspect species
#' @examples
#' SuspectSpeciesList(ExampleData$ScientificName, ExampleData$WatsonianViceCounty, 2)
#' @export
#' @import dplyr
SuspectSpeciesList <- function(SpecimenColumn, VCColumn, Freq = 1) {
  VCTable <- table(SpecimenColumn, VCColumn)
  VCDF <- data.frame(VCTable)
  GetZeros <- !grepl("0", VCDF$Freq)
  FilterZeros <<- VCDF %>% filter(GetZeros)
  colnames(FilterZeros)[1] <<- "Specimen"
  colnames(FilterZeros)[2] <<- "ViceCounty"
  colnames(FilterZeros)[3] <<- "Frequency"
  FilterZeros$Specimen <<- as.character(FilterZeros$Specimen)
  GetSuspectSpecies(FilterZeros, Freq)
  SuspectSpecies <<- SuspectSpecies %>% distinct()
  SuspectSpecies <<- SuspectSpecies[order(SuspectSpecies$Species), ]
  SuspectSpecies <<- as.data.frame(SuspectSpecies)
}

#' Suspect Species List
#' 
#' @noRd
#' @import dplyr
GetSuspectSpecies <- function(FilterZeros, Freq) {
  Specimen <- FilterZeros$Specimen
  Species <- NA
  SuspectSpecies <- cbind(Species)
  SuspectSpecies <<- as.data.frame(SuspectSpecies)
  N <- 1
  for (Specimen in 1:nrow(FilterZeros)) {
    if(FilterZeros[Specimen, ]$Frequency <= Freq) {
      SuspectSpecies[N, ] <<- list(FilterZeros[Specimen, ]$Specimen)
      N <- N + 1
    }
  }
}



#' Closest Vice County - Bryophytes
#' 
#' This function uses the 2021 British Bryological Society Census Catalogue. For each species get a list of the vice county that is not in the census data and the closest vice county to that (numerically) from the census data.
#' @param SpecimenColumn The column where the specimen names are located in the dataset
#' @param VCColumn The column where the vice county is located in the dataset
#' @return Dataframe ViceCountyDifferences with list of species, the vice county that is different and the closest vice county
#' @examples
#' CompareCollectionCensus(ExampleData$ScientificName, ExampleData$WatsonianViceCounty)
#' @export
#' @import dplyr
CompareCollectionCensus <- function(SpecimenColumn, VCColumn) {
  AllSpecies <- cbind(SpecimenColumn)
  AllSpecies <- as.data.frame(AllSpecies)
  AllSpecies <- AllSpecies %>% distinct()
  colnames(AllSpecies)[1] = "Species"
  SimpleDF <- cbind(SpecimenColumn, VCColumn)
  SimpleDF <- as.data.frame(SimpleDF)
  colnames(SimpleDF)[1] = "Specimen"
  colnames(SimpleDF)[2] = "VC"
  
  Species <- AllSpecies$Species
  Specimen <- SimpleDF$Specimen
  CensusSpecimen <- CensusData$Name
  x <- NA
  y <- NA
  VCDiff <- NA
  SpeciesName <- NA
  ClosestVC <- NA
  ViceCountyDifferences <<- cbind(SpeciesName, VCDiff, ClosestVC)
  ViceCountyDifferences <<- as.data.frame(ViceCountyDifferences)
  N <- 1
  for (Species in 1:nrow(AllSpecies)) {
    SpeciesName <- AllSpecies[Species, ]
    SplitName <- strsplit(SpeciesName, split = " ")
    SpeciesNameSimple <- paste(SplitName[[1]][1], SplitName[[1]][2])
    print(paste(Species, "/", nrow(AllSpecies), ":", SpeciesName))
    for (Specimen in 1:nrow(SimpleDF)) {
      SpecimenName <- SimpleDF[Specimen, ]$Specimen
      if (SpeciesName == SpecimenName) {
        VC <- suppressWarnings(as.numeric(SimpleDF[Specimen, ]$VC))
        x[Specimen] <- VC
      }
    }
    x <- x[!is.na(x)]
    x <- as.data.frame(x)
    x <- x %>% distinct()
    colnames(x)[1] <- "VC"
    
    for (CensusSpecimen in 1:nrow(CensusData)) {
      SpecimenName <- CensusData[CensusSpecimen, ]$Name
      if (SpeciesNameSimple == SpecimenName) {
        VC <- suppressWarnings(as.numeric(CensusData[CensusSpecimen, ]$VC_printed))
        y[CensusSpecimen] <- VC
        Name <- SpecimenName
      }
    }
    y <- y[!is.na(y)]
    y <- as.data.frame(y)
    colnames(y)[1] <- "VC"

    if(nrow(x) != 0 && nrow(y) != 0){
      VCDiff <- setdiff(x, y)
      VCDiff <- as.data.frame(VCDiff)
      if(nrow(VCDiff) != 0){
        if (nrow(VCDiff) > 1) {
          for (c in 1:nrow(VCDiff)) {
            County <- VCDiff[c, ]
            Output <- which(abs(y - County) == min(abs(y - County)))
            ClosestVC <- y[Output, ]
            ClosestVC <- unique(ClosestVC)
            N <- N + 1
            ViceCountyDifferences[N, ] <<- list(SpeciesName, County, 
                                                ClosestVC)
          }
        }
        else {
          Output <- which(abs(y - VCDiff$VC) == min(abs(y - VCDiff$VC)))
          ClosestVC <- y[Output, ]
          ClosestVC <- unique(ClosestVC)
          N <- N + 1
          ViceCountyDifferences[N, ] <<- list(SpeciesName, VCDiff, ClosestVC)
        }
      }
    }
    x <- NA
    y <- NA
  }
  ViceCountyDifferences <<- na.omit(ViceCountyDifferences)
}

#' Species Distribution Maps With Census Data
#' 
#' Produce species distribution heat maps for vice counties in Britain from the species in SuspectSpecies alongside distribution maps from census catalogue data.
#' @param Record The record number for the species in the data to start producing maps for. Default = 1.
#' @return Plots of species distribution maps from collection data and from census catalogue data. Maps are made one from user selection in console.
#' @examples
#' DistributionMap(Directory = "")
#' @export
#' @import tidyverse
#' @import stringi
#' @import sf
#' @import sp
#' @import plyr
#' @import ggpubr
#' @import broom
DistributionMap <- function(Record = 1) {
  dev.new()
  library(ggplot2)
  #ShapeFile <- suppressWarnings(readOGR(dsn=Directory, layer = "County_3mile_region"))
  SpeciesToMap <- SuspectSpecies$SuspectSpecies
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  for (SpeciesToMap in Record:nrow(SuspectSpecies)) {
    SpeciesName <- SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies <- readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping:", SpeciesName))
      Title <- stringi::stri_encode(SpeciesName, "UTF-8")
      SpeciesNameCensus <- iconv(SpeciesName, from = "ISO-8859-1", to = "UTF-8")
      SplitName <- strsplit(SpeciesNameCensus, split = " ")
      SpeciesNameSimple <- paste(SplitName[[1]][1], SplitName[[1]][2])
      
      GetData <<- filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
      dataCensus <<- filter(CensusData, CensusData$Name == SpeciesNameSimple)
      colnames(GetData)[2] <<- "id"
      colnames(MapData)[7] <<- "id"
      colnames(dataCensus)[2] <<- "id"
      #GetData$id <- as.numeric(as.character(GetData$id))
      MapNew <<- join(MapData, GetData, by="id")
      MapDataCensus <<- join(MapData, dataCensus, by="id")
      
      MapPlot <- ggplot() +
        suppressWarnings(geom_map(data = MapNew, map = MapNew,
                                  aes(map_id = id, group = group,
                                      x = long, y = lat, fill = Frequency)))+
        scale_fill_gradient(low = "darkgreen", high = "white")+
        coord_fixed(1) +
        theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
        theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
        ggtitle(paste(SpeciesToMap, ":", Title))
      MapPlotCensus <- ggplot() +
        suppressWarnings(geom_map(data = MapDataCensus, map = MapDataCensus,
                                  aes(map_id = id, group = group,
                                      x = long, y = lat, fill = Name)))+
        scale_fill_manual(values = c("darkgreen"))+
        coord_fixed(1) +
        theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
        theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
        ggtitle("Census Data")
      
      figure <- ggarrange(MapPlot, MapPlotCensus,
                          ncol = 2, nrow = 1)
      print(figure)
    }
    else if (MapSpecies == "END") {
      break
    }
    else {
      print(paste("Next species.."))
    }
  }
}


#' Species Distribution Maps Without Census Data
#' 
#' Produce species distribution heat maps for vice counties in Britain from the species in SuspectSpecies.
#' @param Record The record number for the species in the data to start producing maps for. Default = 1.
#' @return Plots of species distribution maps from collection data. Maps are made one from user selection in console.
#' @examples
#' DistributionMapNoCensus()
#' @export
#' @import tidyverse
#' @import stringi
#' @import broom
#' @import plyr

DistributionMapNoCensus <- function(Record = 1) {
  SpeciesToMap <- SuspectSpecies$SuspectSpecies
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  for (SpeciesToMap in Record:nrow(SuspectSpecies)) {
    SpeciesName <- SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies <- readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping:", SpeciesName))
      Title <- stringi::stri_encode(SpeciesName, "UTF-8")
      GetData <- filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
      colnames(GetData)[2] <- "id"
      GetData$id <- as.numeric(as.character(GetData$id))
      MapNew <- join(MapData, GetData, by = "id")

      MapPlot <- ggplot() +
        suppressWarnings(geom_map(data = MapNew, map = MapNew,
                 aes(map_id = id, group = group,
                     x = long, y = lat, fill = Frequency)))+
        scale_fill_gradient(low = "darkgreen", high = "white")+
        coord_fixed(1) +
        theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
        theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
        ggtitle(paste(SpeciesToMap, ":", Title))
      print(MapPlot)
    }
    else if (MapSpecies == "END") {
      break
    }
    else {
      print(paste("Next species.."))
    }
  }
}

#' Species Distribution Maps By Record Number Without Census Data
#' 
#' Produce species distribution heat map for vice counties in Britain for specific species from SuspectSpecies.
#' @param Record The record number for the species in the data to produce map for.
#' @return Plot of species distribution maps from collection data for specific record.
#' @examples
#' SpecificDistributionMapNoCensus(3)
#' @export
#' @import tidyverse
#' @import stringi
#' @import broom
#' @import plyr

SpecificDistributionMapNoCensus <- function(RecordNumber) {
  SpeciesName <- SuspectSpecies$SuspectSpecies[RecordNumber]
  Title <- stringi::stri_encode(SpeciesName, "UTF-8")
  print(paste("Mapping:", RecordNumber, SpeciesName))
  GetData <- filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
  colnames(GetData)[2] <- "id"
  GetData$id <- as.numeric(as.character(GetData$id))
  MapNew <- join(MapData, GetData, by="id")
  MapPlot <- ggplot() +
    suppressWarnings(geom_map(data = MapNew, map = MapNew,
             aes(map_id = id, group = group,
                 x = long, y = lat, fill = Frequency)))+
    scale_fill_gradient(low = "darkgreen", high = "white")+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(paste(RecordNumber, ":", Title))
  print(MapPlot)
}

#' Species Distribution Map By Record Number With Census Data
#' 
#' Produce species distribution heat map for vice counties in Britain for a specific record in SuspectSpecies alongside distribution map from census data.
#' @param Record The record number for the species in the data to produce map for.
#' @return Plot of species distribution maps from collection data for specific record and plot of species distribution from census data.
#' @examples
#' SpecificDistributionMap(3)
#' @export
#' @import tidyverse
#' @import stringi
#' @import broom
#' @import plyr
#' @import ggpubr

SpecificDistributionMap <- function(RecordNumber) {
  dev.new()
  SpeciesName <- SuspectSpecies$SuspectSpecies[RecordNumber]
  SpeciesNameCensus <- iconv(SpeciesName, from = "ISO-8859-1", to = "UTF-8")
  SplitName <- strsplit(SpeciesNameCensus, split = " ")
  SpeciesNameSimple <- paste(SplitName[[1]][1], SplitName[[1]][2])
  Title <- stringi::stri_encode(SpeciesName, "UTF-8")
  print(paste("Mapping:", RecordNumber, SpeciesName))
  GetData <- filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
  dataCensus <<- filter(CensusData, CensusData$Name == SpeciesNameSimple)
  colnames(GetData)[2] <- "id"
  colnames(dataCensus)[2] <- "id"
  GetData$id <- as.numeric(as.character(GetData$id))
  MapNew <<- join(MapData, GetData, by = "id")
  MapDataCensus <<- join(MapData, dataCensus, by = "id")
  
  MapPlot <- ggplot() +
    suppressWarnings(geom_map(data = MapNew, map = MapNew,
             aes(map_id = id, group = group,
                x = long, y = lat, fill = Frequency)))+
    scale_fill_gradient(low = "darkgreen", high = "white")+
    coord_fixed(1) +
    theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(paste(RecordNumber, ":", Title))
  
  MapPlotCensus <- ggplot() +
    suppressWarnings(geom_map(data = MapDataCensus, map = MapDataCensus,
             aes(map_id = id, group = group,
                 x = long, y = lat, fill = Name)))+
    scale_fill_manual(values = c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle("Census Data")
  
  figure <- ggarrange(MapPlot, MapPlotCensus,
                      ncol = 2, nrow = 1)
  print(figure)
}



#' Upload Census Data
#' 
#' Use census data for any organism that uses Watsonian Vice Counties to produce distribution maps and compare collection and census data.
#' @param CensusSpecies The column where the species names are located in the dataset
#' @param CensusVC The column where the vice counties are located in the dataset
#' @return Usuable census data for distribution comparison
#' @examples
#' UploadCensus(ExampleCensusData$Name, ExampleCensusData$VC_printed)
#' @export
UploadCensus <- function(CensusSpecies, CensusVC) {
  CensusData <<- cbind(CensusSpecies, CensusVC)
  colnames(CensusData)[1] <<- "Name"
  colnames(CensusData)[2] <<- "VC_printed"
  CensusData <<- as.data.frame(CensusData)
}
