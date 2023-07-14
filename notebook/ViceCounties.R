#split vice county string into usable vice county and get specimens. 
#Put into condensed data frame VC - DONE
ViceCounty = function(DataFrameVC, DataFrameSpecies) {
  VCSplit <<- strsplit(DataFrameVC, split = ": ")
  VC <<- sapply(VCSplit, "[", 2 )
  Specimens <<- DataFrameSpecies
  VC <<- cbind(Specimens, VC)
  VC <<- as.data.frame(VC)
}

#Get list of specimens with frequency of one for vice county - DONE
SpecimenFrequency = function() {
  Table <<- table(VC$Specimens, VC$VC)
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

#Get list of suspect species where species have frequency of one for any vice county - DONE
SuspectSpeciesList = function() {
  Species = FilterZeros$Specimen
  for (Species in FilterZeros) {
    SuspectSpecies <<- ifelse (FilterZeros$FrequencyOne, FilterZeros$Specimen, NA) 
  }
  SuspectSpecies <<- as.data.frame(SuspectSpecies)
  SuspectSpecies <<- SuspectSpecies %>% distinct()
  SuspectSpecies <<- na.omit(SuspectSpecies)
  
}

#Produce distribution map for each suspect species - DONE
DistributionMap = function(Record = 1) {
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  SpeciesToMap = SuspectSpecies$SuspectSpecies
  for (SpeciesToMap in Record:nrow(SuspectSpecies)) {
    SpeciesName = SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies = readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping:", SpeciesName))
      data = filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
      colnames(data)[2] = "id"
      MapData = tidy(ShapeFile, region="VCNUMBER")
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

#Produce distribution map for specific record - DONE
SpecificDistributionMap = function(RecordNumber) {
  SpeciesName = SuspectSpecies$SuspectSpecies[RecordNumber]
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  #ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  print(paste("Mapping:", RecordNumber, SpeciesName))
  data = filter(FilterZeros, FilterZeros$Specimen == SpeciesName)
  colnames(data)[2] = "id"
  MapData = tidy(ShapeFile, region="VCNUMBER")
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


ViceCounty(MossesFull$WATSONIANVICECOUNTY, MossesFull$SCIENTIFICNAME)
SpecimenFrequency()
SuspectSpeciesList()
DistributionMap(601)
SpecificDistributionMap(154)




