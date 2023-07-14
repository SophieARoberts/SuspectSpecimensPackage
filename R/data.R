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

