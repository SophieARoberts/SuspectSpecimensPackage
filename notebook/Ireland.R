#1. get all vice county data for mosses/liverworts - done(M)
#2. get list of all Irish species for mosses/liverworts - done(M)
#3. get list of differences in vice counties - done(M)
#4. get list of closest vice counties - not doing(M)
#5. produce maps for closest vice counties list
#6. produce distribution maps for closest vice county list
#7. produce list of specimens with one collector
#8. produce list of orphan specimen/species
#9. produce list of varieties


#1. get all vice county data for mosses/liverworts
ViceCounty(MossesFull$WATSONIANVICECOUNTY, MossesFull$SCIENTIFICNAME)

#2. get list of all Irish species for mosses/liverworts
IrishSpecies()

#3. get list of differences in vice counties
#3.a remove H from v county name to get numeric
VCSplit = strsplit(GetIrish$VC, split = "H")
VCNumeric = sapply(VCSplit, "[", 2 )
print(VCNumeric)
GetIrish$VCNumeric = NA

Specimen = GetIrish$Specimens
print(VCNumeric[1])
for (Specimen in 1:nrow(GetIrish)) {
  GetIrish[Specimen, ]$VCNumeric = VCNumeric[Specimen]
}

CompareCollectionCensusIrish()
Differences = apply(Differences,2,as.character)
Directory = getwd()
print(Directory)
FileName = paste(Directory,"/DifferencesIrish.csv", sep = "")
write.csv(Differences, FileName, row.names=FALSE)



#Get differences
CompareCollectionCensusIrish = function() {
  Species = AllSpecies$Specimen
  Specimen = GetIrish$Specimens
  CensusSpecimen = CensusData$Name
  x <<- NA
  y <<- NA
  VCDiff <<- NA
  SpeciesName <<- NA
  Differences <<- cbind(SpeciesName, VCDiff)
  Differences <<- as.data.frame(Differences)
  N = 1
  
  for (Species in 1:nrow(AllSpecies)) {
    SpeciesName = AllSpecies[Species, ]$Specimen
    SplitName = strsplit(SpeciesName, split = " ")
    SpeciesNameSimple = paste(SplitName[[1]][1], SplitName[[1]][2])
    print(paste(Species, "/", nrow(AllSpecies), ":", SpeciesName))
    for (Specimen in 1:nrow(GetIrish)) {
      SpecimenName = GetIrish[Specimen, ]$Specimens
      if (SpeciesName == SpecimenName) {
        x[Specimen] <<- GetIrish[Specimen, ]$VC
      }
    }
    x <<- x[!is.na(x)]
    x <<- as.data.frame(x)
    x <<- x %>% distinct()
    colnames(x)[1] <<- "VC"
    
    for (CensusSpecimen in 1:nrow(CensusData)) {
      SpecimenName = CensusData[CensusSpecimen, ]$Name
      if (SpeciesNameSimple == SpecimenName) {
        y[CensusSpecimen] <<- CensusData[CensusSpecimen, ]$VC_printed
        Name <<- SpecimenName
      }
    }
    y <<- y[!is.na(y)]
    y <<- as.data.frame(y)
    colnames(y)[1] <<- "VC"
    
    if(nrow(x) != 0 && nrow(y) != 0){
      VCDiff <<- setdiff(x, y)
      if(nrow(VCDiff) != 0){
        if (nrow(VCDiff) > 1) {
          print("Adding to list")
          NewVCDiff = as.vector(VCDiff)
          N = N + 1
          Differences[N, ] <<- list(SpeciesName, NewVCDiff)
        }
        else {
          print("Adding to list")
          N = N + 1
          Differences[N, ] <<- list(SpeciesName, VCDiff)
        }
      }
    }
    x <<- NA
    y <<- NA
  }
  view(Differences)
}

#5. produce maps for closest vice counties list
#5.a. separate list into separate rows
install.packages("tidyr")
library(tidyr)
Differences = unnest(Differences, VCDiff) 

Differences = separate_rows(Differences,1,sep = ",")

#create distribution maps for Ireland

IrishSpecies = function() {
  RemoveBritish <<- grepl("H", VC$VC)
  GetIrish <<- VC %>% filter(RemoveBritish)
}

SpecimenFrequencyIreland = function() {
  Table <<- table(GetIrish$Species, GetIrish$VC)
  TableDF <<- data.frame(Table)
  GetZeros <<- !grepl("0", TableDF$Freq)
  FilterZeros <<- TableDF %>% filter(GetZeros)
  colnames(FilterZeros)[1] = "Specimen"
  colnames(FilterZeros)[2] = "ViceCounty"
  colnames(FilterZeros)[3] = "Frequency"
  FrequencyOne <<- grepl("^1$", FilterZeros$Frequency)
  FilterZeros <<- cbind(FilterZeros, FrequencyOne)
  FilterZeros$Specimen <<- as.character(FilterZeros$Specimen)
}

IrishDistributionMap = function() {
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="All_Irish_Vice_Counties_irish_grid")
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  SpeciesToMap = SuspectSpecies$SuspectSpecies
  for (SpeciesToMap in 1:nrow(SuspectSpecies)) {
    SpeciesName = SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies = readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping:", SpeciesName))
      data = filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
      colnames(data)[2] = "id"
      MapData = tidy(ShapeFile, region="ref")
      MapData = join(MapData, data, by="id")
      Title = stringi::stri_encode(SpeciesName, "UTF-8")
      MapPlot = ggplot() +
        geom_map(data=MapData, map=MapData,
                 aes(map_id=id, group=group,
                     x=long, y=lat, fill=Frequency))+
        scale_fill_gradient(low="darkgreen", high="white")+
        coord_fixed(1) +
        theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
        theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
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

SpecificIrishDistributionMap = function(RecordNumber) {
  SpeciesName <<- SuspectSpecies$SuspectSpecies[RecordNumber]
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="All_Irish_Vice_Counties_irish_grid")
  print(paste("Mapping:", RecordNumber, SpeciesName))
  data = filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
  colnames(data)[2] = "id"
  MapData = tidy(ShapeFile, region="ref")
  MapData = join(MapData, data, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=Frequency))+
    scale_fill_gradient(low="darkgreen", high="white")+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(paste(RecordNumber, ":", Title))
  print(MapPlot)
}

IrishSpecies()
SpecimenFrequencyIreland()
SuspectSpeciesList()
SpecificIrishDistributionMap(3)
IrishDistributionMap()
