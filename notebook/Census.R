NameCensusMap = function(Name) {
  SpeciesName = Name
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  print(paste("Mapping Census Data:", SpeciesName))
  data = filter(CensusData, CensusData$Name == SpeciesName)
  colnames(data)[2] = "id"
  MapData <<- tidy(ShapeFile, region="VCNUMBER")
  MapData <<- join(MapData, data, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=Name))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(Title)
  print(MapPlot)
}


NameIrishCensusMap = function(Name) {
  SpeciesName = Name
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="All_Irish_Vice_Counties_irish_grid")
  print(paste("Mapping Census Data:", SpeciesName))
  data = filter(CensusData, CensusData$Name == SpeciesName)
  colnames(data)[2] = "id"
  MapData <<- tidy(ShapeFile, region="ref")
  MapData <<- join(MapData, data, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=Name))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(Title)
  print(MapPlot)
}

SpecificCensusMap = function(RecordNumber) {
  SpeciesName = SuspectSpecies$SuspectSpecies[RecordNumber]
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="County_3mile_region")
  print(paste("Mapping Census Data:", RecordNumber, SpeciesName))
  SplitName = strsplit(SpeciesName, split = " ")
  SpeciesNameSimple = paste(SplitName[[1]][1], SplitName[[1]][2])
  data <<- filter(CensusData, CensusData$Name == SpeciesNameSimple)
  colnames(data)[2] = "id"
  MapData <<- tidy(ShapeFile, region="VCNUMBER")
  MapData <<- join(MapData, data, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=Name))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(paste(RecordNumber, ":", Title))
  print(MapPlot)
}

SpecificIrishCensusMap = function(RecordNumber) {
  SpeciesName = SuspectSpecies$SuspectSpecies[RecordNumber]
  Title = stringi::stri_encode(SpeciesName, "UTF-8")
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="All_Irish_Vice_Counties_irish_grid")
  print(paste("Mapping Census Data:", RecordNumber, SpeciesName))
  SplitName = strsplit(SpeciesName, split = " ")
  SpeciesNameSimple = paste(SplitName[[1]][1], SplitName[[1]][2])
  data = filter(CensusData, CensusData$Name == SpeciesNameSimple)
  colnames(data)[2] = "id"
  MapData = tidy(ShapeFile, region="ref")
  MapData = join(MapData, data, by="id")
  MapPlot = ggplot() +
    geom_map(data=MapData, map=MapData,
             aes(map_id=id, group=group,
                 x=long, y=lat, fill=Name))+
    scale_fill_manual(values=c("darkgreen"))+
    coord_fixed(1) +
    theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
    theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())+
    ggtitle(paste(RecordNumber, ":", Title))
  print(MapPlot)
}

AllCenusMaps = function(Record = 1) {
  Directory = getwd()
  ShapeFile <<- readOGR(dsn=Directory, layer="County_3mile_region")
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  SpeciesToMap = SuspectSpecies$SuspectSpecies
  for (SpeciesToMap in Record:nrow(SuspectSpecies)) {
    SpeciesName <<- SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies = readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping Census Data:", SpeciesName))
      SplitName <<- strsplit(SpeciesName, split = " ")
      SpeciesNameSimple <<- paste(SplitName[[1]][1], SplitName[[1]][2])
      data = filter(CensusData, CensusData$Name == SpeciesNameSimple)
      colnames(data)[2] = "id"
      MapData <<- tidy(ShapeFile, region="VCNUMBER")
      MapData <<- join(MapData, data, by="id")
      Title = stringi::stri_encode(SpeciesName, "UTF-8")
      MapPlot = ggplot() +
        geom_map(data=MapData, map=MapData,
                 aes(map_id=id, group=group,
                     x=long, y=lat, fill=Name))+
        scale_fill_manual(values=c("darkgreen"))+
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

AllIrishCenusMaps = function() {
  Directory = getwd()
  ShapeFile = readOGR(dsn=Directory, layer="All_Irish_Vice_Counties_irish_grid")
  print(paste("Number of suspect species: ", nrow(SuspectSpecies)))
  SpeciesToMap = SuspectSpecies$SuspectSpecies
  for (SpeciesToMap in 1:nrow(SuspectSpecies)) {
    SpeciesName <<- SuspectSpecies[SpeciesToMap, ]
    print(paste("Species:", SpeciesToMap, "/", nrow(SuspectSpecies), SpeciesName))
    MapSpecies = readline(prompt="Map Species? (Y/N/END): ")
    if (MapSpecies == "Y") {
      print(paste("Mapping Census Data:", SpeciesName))
      SplitName <<- strsplit(SpeciesName, split = " ")
      SpeciesNameSimple <<- paste(SplitName[[1]][1], SplitName[[1]][2])
      data <<- filter(CensusData, CensusData$Name == SpeciesNameSimple)
      colnames(data)[2] = "id"
      MapData <<- tidy(ShapeFile, region="ref")
      MapData <<- join(MapData, data, by="id")
      Title = stringi::stri_encode(SpeciesName, "UTF-8")
      MapPlot = ggplot() +
        geom_map(data=MapData, map=MapData,
                 aes(map_id=id, group=group,
                     x=long, y=lat, fill=Name))+
        scale_fill_manual(values=c("darkgreen"))+
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

SpecificCensusMap(12)
SpecificIrishCensusMap(2)
AllCenusMaps(728)
AllIrishCenusMaps()
NameCensusMap("Didymodon umbrosus")
NameIrishCensusMap("Cephalozia crassifolia")



