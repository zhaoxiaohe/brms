% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brmsfit-methods.R
\name{loo_predict.brmsfit}
\alias{loo_predict.brmsfit}
\alias{loo_predict}
\alias{loo_linpred}
\alias{loo_predictive_interval}
\alias{loo_linpred.brmsfit}
\alias{loo_predictive_interval.brmsfit}
\title{Compute Weighted Expectations Using LOO}
\usage{
\method{loo_predict}{brmsfit}(object, type = c("mean", "var", "quantile"),
  resp = NULL, probs = 0.5, lw = NULL, cores = 1, wcp = 0.2,
  wtrunc = 3/4, ...)

\method{loo_linpred}{brmsfit}(object, type = c("mean", "var", "quantile"),
  resp = NULL, probs = 0.5, scale = "linear", lw = NULL, cores = 1,
  wcp = 0.2, wtrunc = 3/4, ...)

\method{loo_predictive_interval}{brmsfit}(object, prob = 0.9, lw = NULL,
  ...)
}
\arguments{
\item{object}{An object of class \code{brmsfit}.}

\item{type}{The statistic to be computed on the results. 
Can by either \code{"mean"} (default), \code{"var"}, or
\code{"quantile"}.}

\item{resp}{Optional names of response variables.
If specified, fitted values of these response variables are returned.}

\item{probs}{A vector of quantiles to compute. 
Only used if \code{type = quantile}.}

\item{lw}{An optional matrix of (smoothed) log-weights. If \code{lw} is 
missing then \code{\link[loo]{psislw}} is executed internally, which may be
time consuming for models fit to very large datasets. 
If \code{lw} is specified, arguments passed via \code{...} may be ignored.}

\item{cores}{The number of cores to use for parallelization. 
Default is \code{1}.}

\item{wcp}{Parameters used for 
the Pareto smoothed importance sampling. 
See \code{\link[loo:loo]{loo}} for details.}

\item{wtrunc}{Parameters used for 
the Pareto smoothed importance sampling. 
See \code{\link[loo:loo]{loo}} for details.}

\item{...}{Optional arguments passed to the underlying methods that is 
\code{\link[brms:log_lik.brmsfit]{log_lik}}, as well as
\code{\link[brms:predict.brmsfit]{predict}} or
\code{\link[brms:fitted.brmsfit]{fitted}}.}

\item{scale}{Passed to \code{\link[brms:fitted.brmsfit]{fitted}}.}

\item{prob}{For \code{loo_predictive_interval}, a scalar in \eqn{(0,1)}
indicating the desired probability mass to include in the intervals. The
default is \code{prob = 0.9} (\eqn{90}\% intervals).}
}
\value{
\code{loo_predict} and \code{loo_linpred} return a vector with one 
  element per observation. The only exception is if \code{type = "quantile"} 
  and \code{length(probs) >= 2}, in which case a separate vector for each 
  element of \code{probs} is computed and they are returned in a matrix with 
  \code{length(probs)} rows and one column per observation.
  
  \code{loo_predictive_interval} returns a matrix with one row per 
  observation and two columns. 
  \code{loo_predictive_interval(..., prob = p)} is equivalent to 
  \code{loo_predict(..., type = "quantile", probs = c(a, 1-a))} with 
  \code{a = (1 - p)/2}, except it transposes the result and adds informative 
  column names.
}
\description{
These functions are wrappers around the \code{\link[loo]{E_loo}} function 
of the \pkg{loo} package.
}
\examples{
\dontrun{
## data from help("lm")
ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
d <- data.frame(
  weight = c(ctl, trt), 
  group = gl(2, 10, 20, labels = c("Ctl", "Trt"))
) 
fit <- brm(weight ~ group, data = d)
loo_predictive_interval(fit, prob = 0.8)

## optionally log-weights can be pre-computed and reused
psis <- loo::psislw(-log_lik(fit), cores = 2)
loo_predictive_interval(fit, prob = 0.8, lw = psis$lw_smooth)
loo_predict(fit, type = "var", lw = psis$lw_smooth)
}

}
