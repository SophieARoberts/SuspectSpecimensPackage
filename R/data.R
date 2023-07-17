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
#' data(Census_Catalogue_Data_2021)
"Census_Catalogue_Data_2021"

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




