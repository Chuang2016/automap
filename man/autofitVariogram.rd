\name{autofitVariogram}
\alias{autofitVariogram}
\title{Automatically fitting a variogram}
\description{
Automatically fitting a variogram to the data on which it is applied. The automatic fitting 
is done through \link[pkg:gstat]{fit.variogram}. In \link[pkg:gstat]{fit.variogram} the user had to supply an initial estimate for the sill, 
range etc. \code{autofitVariogram} provides this estimate based on the data and then calls \link[pkg:gstat]{fit.variogram}.}
\usage{autofitVariogram(formula, 
		 input_data, 
		 model = c("Sph", "Exp", "Gau", "Ste"),
		 kappa = c(0.05, seq(0.2, 2, 0.1), 5, 10), 
		 fix.values = c(NA,NA,NA),
		 verbose = FALSE, 
		 GLS.model = NA)}
\arguments{
	\item{formula}{formula that defines the dependent variable as a linear model
		            of independent variables; suppose the dependent variable has
		            name 'z', for ordinary and simple kriging use the formula
					'z~1'; for simple kriging also define 'beta' (see below); for
		            universal kriging, suppose 'z' is linearly dependent on 'x'
					and 'y', use the formula 'z~x+y'.}
    \item{input_data}{An object of \link[pkg:sp]{SpatialPointsDataFrame-class}.}
    \item{model}{The list of variogrammodels that will be tested.}
    \item{kappa}{Smoothing parameter of the Matern model. Provide a list if you want to check
				more than one value.}
    \item{fix.values}{Can be used to fix a variogram parameter to a certain value. It 
                 consists of a list with a length of three. The items describe the
                 fixed value for the nugget, range and sill respectively. Setting
                 the value to NA means that the value is not fixed. } 
	\item{verbose}{logical, if TRUE the function will give extra feedback on the fitting process}  
	\item{GLS.model}{If a variogram model is passed on through this parameter a Generalized Least Squares 
				 sample variogram is calculated.} 
}
\details{
Geostatistical routines are used from package \code{gstat}.

A few simple choices are made when estimating the inital guess for \code{fit.variogram}. 
The initial sill is estimated as the \code{mean} of the \code{max} and the \code{median}
of the semi-variance. The inital range is defined as 0.10 times the diagonal of the bounding
box of the data. The initial nugget is defined as the \code{min} of the the semi-variance. 

There are five different types of models that are often used: 
\describe{
    \item{Sph}{A shperical model.}
    \item{Exp}{An exponential model.}
    \item{Gau}{A gaussian model.}
    \item{Mat}{A model of the Matern familiy}
	\item{Ste}{Matern, M. Stein's parameterization}
}
A list of all permitted variogram models is available by typing vgm() into the R console.
\code{autofitVariogram} iterates over the variogram models listed in \code{model} and picks the model 
that has the smallest residual sum of squares with the sample variogram. For the Matern model, all the 
kappa values in \code{kappa} are tested. 
}
\value{An object of type \code{autofitVariogram} is returned. This object contains the experimental variogram
and the fitted variogram model}
\note{\code{autofitVariogram} is mostly used indirectly through the function \code{autoKrige}}
\author{Paul Hiemstra, \email{p.hiemstra@geo.uu.nl}}
\seealso{\code{\link[pkg:gstat]{fit.variogram}}, \code{\link{autoKrige}}, \code{\link{posPredictionInterval}}}
\examples{
data(meuse)
coordinates(meuse) =~ x+y
variogram = autofitVariogram(zinc~1,meuse)
plot(variogram)

# Residual variogram
data(meuse)
coordinates(meuse) =~ x+y
variogram = autofitVariogram(zinc ~ soil + ffreq + dist, meuse)
plot(variogram)
}
