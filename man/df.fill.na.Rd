% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Utils.R
\name{df.fill.na}
\alias{df.fill.na}
\title{Replaces NA values in dataframe for closest price}
\usage{
df.fill.na(df.in)
}
\arguments{
\item{df.in}{DAtaframe to be fixed}
}
\value{
A fixed dataframe.
}
\description{
Helper function for BatchGetSymbols. Replaces NA values and returns fixed dataframe.
}
\examples{

df <- data.frame(price.adjusted = c(NA, 10, 11, NA, 12, 12.5, NA ), volume = c(1,10, 0, 2, 0, 1, 5))

df.fixed.na <- df.fill.na(df)

}
