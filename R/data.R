#' Example specimen dataset
#' 
#' Includes example specimens with ScientificName and WatsonianViceCounty
#' 
#' @format A data frame with 48 rows and 5 variables
#' \describe {
#'  \item{ScientificName}{Specimen scientific name}
#'  \item{WatsonianViceCounty}{Specimen vice county}
#'  \item{Collector1}{First collector}
#'  \item{Collector2}{Second collector}
#'  \item{Collector3}{Third collector}
#' }
#' 
#' @source Created in house to serve as an example
#' 
#' @examples
#' data(ExampleData)
"ExampleData"

#' Example specimen dataset
#' 
#' Example data base from NMW Herbarium bryophyte collection where collector names have been replaced due to GDPR.
#' 
#' @format A data frame with 21715 rows and 29 variables
#' \describe {
#' \item{ACCESSION.NO.}{ACCESSION.NO.}
#' \item{COLLECTIONNAME}{COLLECTIONNAME}
#' \item{COLLECTORGNUMBER}{COLLECTORGNUMBER}
#' \item{TAXONGROUP}{TAXONGROUP}
#'  \item{SCIENTIFICNAME}{SCIENTIFICNAME}
#'  \item{UKSI}{UKSI}
#'  \item{SCIENTIFICNAME2}{SCIENTIFICNAME2}
#'  \item{PREVIOUS.NAME}{PREVIOUS.NAME}
#'  \item{PREVIOUS.NAME.NOTES}{PREVIOUS.NAME.NOTES}
#'  \item{INDENTIFICATIONTYPE}{IDENTIFICATIONTYPE}
#'  \item{INDENTIFIEDBY}{INDENTIFIEDBY}
#'  \item{DATEIDENTIFIED}{DATEIDENTIFIED}
#'  \item{LOCALITY}{LOCALITY}
#'  \item{COUNTY}{COUNTY}
#'  \item{WATSONIANVICECOUNTY}{WATSONIANVICECOUNTY}
#'  \item{COUNTRY}{COUNTRY}
#'  \item{COORDINATES1}{COORDINATES1}
#'  \item{COORDINATES2}{COORDINATES2}
#'  \item{COORDINATES3}{COORDINATES3}
#'  \item{COLLECTOR1}{COLLECTOR1}
#'  \item{COLLECTOR2}{COLLECTOR2}
#'  \item{COLLECTOR3}{COLLECTOR3}
#'  \item{COLLECTOR4}{COLLECTOR4}
#'  \item{FIELDNOTES}{FIELDNOTES}
#'  \item{VERBATUMCOLLECTINGDA}{VERBATUMCOLLECTINGDA}
#'  \item{ATTRIBUTES1}{ATTRIBUTES1}
#'  \item{ATTRIUBUTES2}{ATTRIUBUTES2}
#'  \item{STATUS}{STATUS}
#'  \item{PHYSICALDESCRIPTION}{PHYSICALDESCRIPTION}
#' }
#' 
#' @source Created in house to serve as an example
#' 
#' @examples
#' data(ExampleData)
"ExampleDataFull"

#' British Bryological Society Census Catalogue 2021
#' 
#' Census data used for producing distribution maps and finding the closest vice county to differences in specimen data
#' 
#' @format A data frame with 71879 rows and 6 variables
#' \describe {
#'  \item{CC.number.long.form}{Census Catalogue Number}
#'  \item{CC.number.short.form}{Census Catalogue Number}
#'  \item{Name}{Species Name}
#'  \item{VC_numeric}{Vice County Numeric Number}
#'  \item{VC_printed}{Vice County Printed Number}
#'  \item{Status}{Status of species in vice county}
#' }
#' 
#' @source British Bryological Society (https://www.britishbryologicalsociety.org.uk/publications/census-catalogue/)
#' @examples
#' data(ExampleCenusData)
"ExampleCensusData"

#' Biological Records Centre Watsonian Vice County Boundaries
#' 
#' Shapefile containing vice county boundaries for Britain.
#' 
#' @format A data frame with 1102774 rows and 7 variables
#' \describe {
#'  \item{long}{Longitude}
#'  \item{lat}{Latitude}
#'  \item{order}{Order}
#'  \item{hole}{Hole}
#'  \item{piece}{Piece}
#'  \item{id}{ID}
#' }
#' 
#' @source Biological Records Centre (https://github.com/BiologicalRecordsCentre/vice-counties)
#' @examples
#' data(MapData)
"MapData"




