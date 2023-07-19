# SuspectSpecimensPackage

R package to find potentially misidentified specimens using 3 analyses. The output of these analyses can be viewed by the user to determine if a specimen has been misidentified. 

The R package can be downloaded from this repository using:

```
library(devtools)
install_github("SophieARoberts/SuspectSpecimensPackage")
```

## 1. Species Distribution

This analysis uses **Watsonian Vice Counties** which can be found [here](https://www.brc.ac.uk/article/british-vice-counties).
Each specimen should be assigned a vice county as a numeric (e.g. 14).
This analysis will produce distribution maps based on which vice counties a species is found in and the frequency of specimens for each vice county. **Currently this is only for British species**.

To begin this analysis first build a list of suspect species which have a specified frequency for any vice county they are found in using the function `SuspectSpeciesList`:

```
SuspectSpeciesList(ExampleDataFull$ScientificName, ExampleDataFull$ViceCounty, 2)
```

This function requires the arguments `SpecimenColumn` which is the column with the specimen names and `VCColumn` which is the column with the vice county number.
*The name can either include authors or not*.
The `Freq` argument is the specified frequency of a specimen in a vice county. The default is 1.
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

### Using Census Catalogue Data

If you want a comparison between your collection data and the census data which includes vice county information these can be compared by uploading a census data set:

```
UploadCensus(ExampleCensusData$Name, ExampleCensusData$VC_printed)
```
This function requires `CensusSpecies` which is the column with the species names in the census data and `CensusVC` which is the column with the vice county numbers in the census data.

And then use instead the function `DistributionMap` which will produce a distribution map for your data and for the census data. This function works in the exact same way as `DistributionMapNoCensus` (see above).
**The scientific name used in your data must be the same as that of the census data**.
*The name can either include authors or not*.

```
DistributionMap()
```
The function `SpecificDistributionMap` works also in the exact same way as `SpecificDistributionMapNoCensus` see above:

```
SpecificDistributionMap(4)
```
The last function that can be used alongside the census data is `CompareCollectionCensus`. This function will produce the dataframe `ViceCountyDifferences` with a list of species, the vice county that is your data but not in the census data and the closest vice county from the census data.

```
CompareCollectionCensus(ExampleDataFull$ScientificName, ExampleDataFull$ViceCounty)
```
This function requires the arguments `SpecimenColumn` which is the column with the specimen names and `VCColumn` which is the column with the vice county number.

## 2. Collectors

This analysis finds species which only have a specified number of collectors and creates the dataframe `GetCollectors`.

```
SpeciesCollectors(ExampleDataFull$ScientificName, 3, ExampleDataFull$Collector1, ExampleDataFull$Collector2, ExampleDataFull$Collector3, ExampleDataFull$Collector4)
```
This function requires the arguments `SpecimenColumn` and `NoCollectors` which is the column with the specimen names and the specified number of collectors (default is 1) It also requires any columns that contain collector names. *The specimen name can either include authors or not*. Collector names should all be in the same format.

## 3. Orphan Species & Specimens

These next two functions find genera with a specified number of species in the data and species with a specified number of specimens in the data.

The first function `OrphanSpecies` produces the dataframe `OrphanSpeciesList` which contains the list of genera with the specified number of species.

```
OrphanSpecies(ExampleDataFull$ScientificName, 2)
```

The second function `OrphanSpecimens` produces the dataframe `OrphanSpecimenList` which contains the list of species with the specified number of specimens.


```
OrphanSpecimens(ExampleDataFull$ScientificName, 2)
```

Both of these function requires `SpecimenColumn` which is the column with the specimen names and any columns that contain collector names. *The name can either include authors or not*. The argument `Freq` is the specified number of species/specimens. The default value is 1.

#### Example Data Set

The example data set `ExampleDataFull` represents NMW Herbarium bryophyte collection with collectors names having been changed due to GDPR. This data set can be used with the above functions to see how they work. However it is a large data set and some functions will run slower. To quickly see how functions will run with a very small made up data set use `ExampleData` below.

The example data set `ExampleData` contains a list of moss species with example vice counties and collector names. This data set can be used with the above functions to see how they work.

#### Example Census Data Set

The example data set `ExampleCensusData` contains the British Bryological Society 2021 Census Catalogue. The census data can be found [here](https://www.britishbryologicalsociety.org.uk/publications/census-catalogue/). This data set is used with the functions under the title "Using Census Catalogue Data" above.
