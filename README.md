# SuspectSpecimensPackage

R package to find potentially misidentified specimens using 3 analyses. The output of these analyses can be viewed by the user to determine if a specimen has been misidentified. 

This R package was built to look at bryophyte specimens and to compare the collection data against that of the British Bryological Society Census Catalogue. However, the functions can also be used on any data of any species. See below for how data should be formatted.

The R package can be downloaded from this repository using:

```
library(devtools)
install_github("SophieARoberts/SuspectSpecimensPackage")
```

## 1. Species Distribution

This analysis uses **Watsonian Vice Counties** which can be found [here](https://www.brc.ac.uk/article/british-vice-counties).
Each specimen should be assigned a vice county as a numeric (e.g. 14).
This analysis will produce distribution maps based of which vice counties a species is found in and the frequency of specimens for each vice county. **Currently this is only for British species**.

To begin this analysis first build a list of suspect species which have a frequency of 1 for any vice county they are found in using the function `SuspectSpeciesList`:

```
SuspectSpeciesList(MossData$ScientificName, MossData$ViceCounty)
```

This function requires the arguments `SpecimenColumn` which is the column with the specimen names and `VCColumn` which is the column with the vice county number.
*The name can either include authors or not*.
This function will produce a dataframe `SuspectSpecies` which will include a list of species which have a frequency of 1 for any of the vice counties it is found in.
Once this list has been made a number of different functions can be run which will produce distribution maps.

Firstly `DistributionMapNoCensus`:

```
DistributionMapNoCensus()
```

This function will run through each species in `SuspectSpecies` and produce a map showing the frequency for each vice county the species is found in.
The function prompts the user in the console to either produce the map (`Y`), skip to the next species (`N`) or stop (`END`).
If you would like the function to not start from the first record, specify this in the arguments:

```
DistributionMapNoCensus(10)
```


Secondly `SpecificDistributionMapNoCensus`. This produces a distribution map for only the species specified:

```
SpecificDistributionMapNoCensus(4)
```

This function requires the argument `Record` which is the record number of the species from the `SuspectSpecies` list. For example, here a distribution map for the 4th species in the list will be produced.

### Using British Bryological Society Census Catalogue 2021 Data

If you are looking at bryophyte data then a comparison between your collection data and the census data from the BBS can be produced.
The census data can be found [here](https://www.britishbryologicalsociety.org.uk/publications/census-catalogue/). 
Use instead the function `DistributionMap` which will produce a distribution map for your data and for the census data. This function works in the exact same way as `DistributionMapNoCensus` (see above).
**The scientific name used in your data must be the same as that of the 2021 census**.
*The name can either include authors or not*.

```
DistributionMap()
```
The function `SpecificDistributionMap` works also in the exact same way as `SpecificDistributionMapNoCensus` see above:

```
SpecificDistributionMap(4)
```
The last function that can be used alongside the BBS census data is `CompareCollectionCensus`. This function will produce the dataframe `ViceCountyDifferences` with a list of species, the vice county that is different between your data and the census data and the closest vice county from the census data.

```
CompareCollectionCensus(MossData$ScientificName, MossData$ViceCounty)
```
This function requires the arguments `SpecimenColumn` which is the column with the specimen names and `VCColumn` which is the column with the vice county number.

## 2. Collectors

This analysis finds species which only have one collector and creates the dataframe `OneCollector`.

```
SpeciesCollectors(MossData$ScientificName, MossData$Collector1, MossData$Collector2, MossData$Collector3)
```
This function requires the arguments `SpecimenColumn` which is the column with the specimen names and any columns that contain collector names. *The name can either include authors or not*. Collector names should all be in the same format.

## 3. Orphan Species & Specimens

These next two functions find genera with only one species in the data and species with only one specimen in the data.

The first function `OneSpecies` produces the dataframe `OneSpeciesList` which contains the list of genera with one species.

```
OneSpecies(MossData$ScientificName)
```

The second function `OneSpecimen` produces the dataframe `OneSpecimenList` which contains the list of species with one specimen.


```
OneSpecimen(MossData$ScientificName)
```

Both of these function requires `SpecimenColumn` which is the column with the specimen names and any columns that contain collector names. *The name can either include authors or not*.

#### Example Data Set

The example data set `ExampleData` contains a list of moss species with example vice counties and collector names. This data set can be used with the above functions to see how they work.


