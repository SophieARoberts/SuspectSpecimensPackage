#Get list of all species with genus - DONE
GenusSpeciesList = function(DataFrameSpecies) {
  Specimen = DataFrameSpecies
  GenusSplit = strsplit(DataFrameSpecies, split = " ")
  Genus = sapply(GenusSplit, "[", 1)
  AllSpecimens <<- cbind(Genus, Specimen)
  AllSpecimens <<- as.data.frame(AllSpecimens)
  AllSpecies <<- AllSpecimens %>% distinct()
}

#Get CSV of all species
SpeciesCSV = function() {
  AllSpecies = apply(AllSpecies,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/AllSpecies.csv", sep = "")
  write.csv(AllSpecies, FileName, row.names=FALSE)
}

#Get list of genera where there is only one species - DONE
OneSpecies = function() {
  OneSpeciesList <<- subset(AllSpecies, !(duplicated(AllSpecies$Genus)|duplicated(AllSpecies$Genus, fromLast = TRUE)))
}

#Get CSV of genera where there is only one species
OneSpeciesCSV = function() {
  OneSpeciesList = apply(OneSpeciesList,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/OneSpecies.csv", sep = "")
  write.csv(OneSpeciesList, FileName, row.names=FALSE)
}

#Get list of species which only have one specimen - DONE
OneSpecimen = function() {
  OneSpecimenList <<- subset(AllSpecimens, !(duplicated(AllSpecimens$Specimen)|duplicated(AllSpecimens$Specimen, fromLast = TRUE)))
}

#Get CSV of species which have one specimen
OneSpecimenCSV = function() {
  OneSpecimenList = apply(OneSpecimenList,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/OneSpecimen.csv", sep = "")
  write.csv(OneSpecimenList, FileName, row.names=FALSE)
}

#Get list of varieties
Varieties = function() {
  Variety <<- grepl("var. ", AllSpecimens$Specimen)
  AllVarieties <<- AllSpecimens %>% filter(Variety)
  AllVarieties <<- AllVarieties %>% distinct()
  NoVarities <<- AllSpecimens %>% filter(!Variety)
  NoVarities <<- NoVarities %>% distinct()
  SpecimenSplit <<- strsplit(AllVarieties$Specimen, split = "var.")
  SpecimenName <<- sapply(SpecimenSplit, "[", 1)
  SpecimenNames <<- as.data.frame(SpecimenName)
  SpecimenNames <<- SpecimenNames %>% distinct()
  HasSpecies <<- NA
  AllVarieties <<- cbind(AllVarieties, HasSpecies)
  Variety <<- AllVarieties$Specimen
  Species <<- NoVarities$Specimen
  for (Variety in 1:nrow(AllVarieties)) {
    SpecimenName <<- NA
    SpecimenSplit <<- strsplit(AllVarieties$Specimen, split = "var.")
    SpecimenName <<- sapply(SpecimenSplit, "[", 1)
    print(SpecimenName[Variety])
    for (Species in 1:nrow(NoVarities)) {
      print(SpecimenName[Variety])
      print(NoVarities[Species, "Specimen"])
      CheckVariety <<- grepl(SpecimenName[Variety], NoVarities[Species, "Specimen"])
      Check <<- CheckVariety[1]
      if (Check == TRUE) {
        print("true")
        AllVarieties[Variety, ]$HasSpecies <<- NoVarities[Species, "Specimen"]
      }
    }
  }
}

#Get CSV of all varieties
AllVarietiesCSV = function() {
  AllVarieties = apply(AllVarieties,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/AllVarieties.csv", sep = "")
  write.csv(AllVarieties, FileName, row.names=FALSE)
}

#needs fixing??
NoVaritiesCSV = function() {
  No = apply(AllVarieties,2,as.character)
  Directory = getwd()
  print(Directory)
  FileName = paste(Directory,"/AllVarieties.csv", sep = "")
  write.csv(AllVarieties, FileName, row.names=FALSE)
}



GenusSpeciesList(MossesFull$SCIENTIFICNAME)
OneSpecies()
OneSpeciesCSV()
OneSpecimen()
OneSpecimenCSV()
Varieties()
AllVarietiesCSV()



