#Distribution of genus
GenusDistribution = function(Genus, DataFrameSpecies, DataFrameVC) {
  Specimen = DataFrameSpecies
  VCSplit <<- strsplit(DataFrameVC, split = ": ")
  VC <<- sapply(VCSplit, "[", 2 )
  GenusSplit = strsplit(DataFrameSpecies, split = " ")
  GenusName = sapply(GenusSplit, "[", 1)
  AllSpecimens <<- cbind(GenusName, Specimen, VC)
  AllSpecimens <<- as.data.frame(AllSpecimens)
  FilterGenus <<- grepl(Genus, AllSpecimens$Genus)
  GetGenus <<- AllSpecimens %>% filter(FilterGenus)
  colnames(GetGenus)[3] = "id"
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  MapData <<- tidy(ShapeFile, region="VCNUMBER")
  MapData <<- join(MapData, GetGenus, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=GenusName))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(Genus)
  print(MapPlot)
}
  

GenusDistribution("Philonotis", MossesFull$SCIENTIFICNAME, 
                  MossesFull$WATSONIANVICECOUNTY)



  

#Distribution of genus
GenusDistributionCensus = function(Genus, DataFrameSpecies, DataFrameVC) {
  Specimen = DataFrameSpecies
  VC <<- DataFrameVC
  GenusSplit = strsplit(DataFrameSpecies, split = " ")
  GenusName = sapply(GenusSplit, "[", 1)
  AllSpecimens <<- cbind(GenusName, Specimen, VC)
  AllSpecimens <<- as.data.frame(AllSpecimens)
  FilterGenus <<- grepl(Genus, AllSpecimens$Genus)
  GetGenus <<- AllSpecimens %>% filter(FilterGenus)
  colnames(GetGenus)[3] = "id"
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  MapData <<- tidy(ShapeFile, region="VCNUMBER")
  MapData <<- join(MapData, GetGenus, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=GenusName))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(Genus)
  print(MapPlot)
}

GenusDistributionCensus("Philonotis", CensusData$Name, 
                  CensusData$VC_printed)


#DONE
# 1. Compare collection to census data
  # a. Get list of vice counties for collection species
  # b. Get list of vice counties for census species
  # c. Compare the two lists
  # d. If lists differ put into dataframe = super suspect species
# 2. Find closest vice county in census data 
CompareCollectionCensus = function() {
  Species = AllSpecies$Specimen
  Specimen = VC$Species
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
    for (Specimen in 1:nrow(VC)) {
      SpecimenName = VC[Specimen, ]$Specimens
      if (SpeciesName == SpecimenName) {
        x[Specimen] <<- VC[Specimen, ]$VC
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

CompareCollectionCensus()

#DONE
ClosestVC = function() {
  Species = Differences$SpeciesName
  CensusName = CensusData$Name
  y = NA
  VC = NA
  SpeciesName = NA
  CloseVC = NA
  ClosestCounties <<- cbind(SpeciesName, VC, CloseVC)
  ClosestCounties <<- as.data.frame(ClosestCounties)
  I = 1
  
  for (Species in 2:nrow(Differences)) {
    SpeciesName = Differences[Species, ]$SpeciesName
    SplitName = strsplit(SpeciesName, split = " ")
    SpeciesNameSimple = paste(SplitName[[1]][1], SplitName[[1]][2])
    print(paste(Species, "/", nrow(Differences), ":", SpeciesName))
    VC = Differences[Species, ]$VCDiff
    LengthVC = length(VC[[1]])
    if (LengthVC == 1) {
      VC = as.numeric(VC)
      Count = 1
      for (CensusName in 1:nrow(CensusData)) {
        SpecimenName = CensusData[CensusName, ]$Name
        if (SpeciesNameSimple == SpecimenName) {
          y[Count] = CensusData[CensusName, ]$VC_printed
          Count = Count + 1
        }
      }
      y = as.numeric(y)
      y = y[!is.na(y)]
      Output = which(abs(y - VC) == min(abs(y - VC)))
      CloseVC = y[Output]
      CloseVC = unique(CloseVC)
      for (i in CloseVC) {
        if (i != VC) {
          ClosestCounties[I, ] <<- list(SpeciesName, VC, i)
          I = I + 1
        }
      }
    }
    else {
      VC = as.data.frame(VC)
      County = VC[1]
      for (County in 1:nrow(VC)) {
        c = as.numeric(VC[County, ])
        Count = 1
        for (CensusName in 1:nrow(CensusData)) {
          SpecimenName = CensusData[CensusName, ]$Name
          if (SpeciesNameSimple == SpecimenName) {
            y[Count] = CensusData[CensusName, ]$VC_printed
            Count = Count + 1
          }
        }
        y = as.numeric(y)
        y = y[!is.na(y)]
        Output = which(abs(y - c) == min(abs(y - c)))
        CloseVC = y[Output]
        CloseVC = unique(CloseVC)
        for (i in CloseVC) {
          if (i != c) {
            ClosestCounties[I, ] <<- list(SpeciesName, c, i)
            I = I + 1
          }
        }
        
      }
    }
  }
}

ClosestVC()



DifferencesCSV = function() {
  Differences = apply(Differences,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/Differences.csv", sep = "")
  write.csv(Differences, FileName, row.names=FALSE)
}

ClosestCountiesCSV = function() {
  ClosestCounties = apply(ClosestCounties,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/ClosestCounties.csv", sep = "")
  write.csv(ClosestCounties, FileName, row.names=FALSE)
}

DifferencesCSV()
ClosestCountiesCSV()

