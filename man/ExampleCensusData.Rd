% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ExampleCensusData}
\alias{ExampleCensusData}
\title{British Bryological Society Census Catalogue 2021}
\format{
A data frame with 71879 rows and 6 variables
\describe {
 \item{CC.number.long.form}{Census Catalogue Number}
 \item{CC.number.short.form}{Census Catalogue Number}
 \item{Name}{Species Name}
 \item{VC_numeric}{Vice County Numeric Number}
 \item{VC_printed}{Vice County Printed Number}
 \item{Status}{Status of species in vice county}
}
}
\source{
British Bryological Society (https://www.britishbryologicalsociety.org.uk/publications/census-catalogue/)
}
\usage{
ExampleCensusData
}
\description{
Census data used for producing distribution maps and finding the closest vice county to differences in specimen data
}
\examples{
data(ExampleCenusData)
}
\keyword{datasets}
