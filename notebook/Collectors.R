#Condensed dataframe of specimen and collectors - DONE
SpeciesCollectors = function(DataFrameSpecies, DataFrameCol1, DataFrameCol2, 
                              DataFrameCol3, DataFrameCol4) {
  Specimen <<- DataFrameSpecies
  Collector1 <<- DataFrameCol1
  Collector2 <<- DataFrameCol2
  Collector3 <<- DataFrameCol3
  Collector4 <<- DataFrameCol4
  Collectors <<- NA
  CollectorData <<- cbind(Specimen, Collector1, Collector2, Collector3, Collector4)
  CollectorData <<- as.data.frame(CollectorData)
  OnlySpecies <<- as.data.frame(Specimen)
  OnlySpecies <<- OnlySpecies %>% distinct()
  CheckSpecies <<- OnlySpecies$Specimen
  CheckSpecimen <<- CollectorData$Specimen
  OnlySpecies$Collectors <<- NA
  print(paste("Number of species:", nrow(OnlySpecies)))
  for (CheckSpecies in 1:nrow(OnlySpecies)) {
    CollectorList <<- NA
    print(paste("Species:", CheckSpecies, OnlySpecies[CheckSpecies, "Specimen"]))
    for (CheckSpecimen in 1:nrow(CollectorData)) {
      if (CollectorData[CheckSpecimen, "Specimen"] == OnlySpecies[CheckSpecies, "Specimen"]) {
        FirstCollector <<- CollectorData[CheckSpecimen, "Collector1"]
        SecondCollector <<- CollectorData[CheckSpecimen, "Collector2"]
        ThirdCollector <<- CollectorData[CheckSpecimen, "Collector3"]
        FourthCollector <<- CollectorData[CheckSpecimen, "Collector4"]
        CollectorList <<- c(CollectorList, FirstCollector, SecondCollector, ThirdCollector, FourthCollector)
      }
    }
    CollectorList <<- sort(CollectorList)
    CollectorList <<- as.data.frame(CollectorList)
    CollectorList <<- CollectorList %>% distinct()
    RemoveBlanks <<- grepl(" ", CollectorList$CollectorList)
    CollectorList <<- CollectorList %>% filter(RemoveBlanks)
    CollectorList <<- as.vector(CollectorList)
    OnlySpecies[CheckSpecies,]$Collectors <<- CollectorList
  }
}

#Get CSV of species with only one collector
OneCollectorCSV = function() {
  OneCollector = !grepl("c()", OnlySpecies$Collectors)
  OnlyOneCollector <<- OnlySpecies %>% filter(OneCollector)
  OnlyOneCollector <<- apply(OnlyOneCollector,2,as.character)
  colnames(OnlyOneCollector)[1] = "Species"
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/OneCollector.csv", sep = "")
  write.csv(OnlyOneCollector, FileName, row.names=FALSE)
}

#Get CSV of species with many collectors
AllCollectorsCSV = function() {
  ManyCollectors = grepl("c()", OnlySpecies$Collectors)
  AllCollectors <<- OnlySpecies %>% filter(ManyCollectors)
  AllCollectors <<- apply(AllCollectors,2,as.character)
  colnames(AllCollectors)[1] = "Species"
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/AllCollectors.csv", sep = "")
  write.csv(AllCollectors, FileName, row.names=FALSE)
}


SpeciesCollectors(MossesFull$SCIENTIFICNAME, MossesFull$COLLECTOR1, MossesFull$COLLECTOR2, MossesFull$COLLECTOR3, MossesFull$COLLECTOR4)
OneCollectorCSV()

