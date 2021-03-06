\name{plot.MultimodDiagnostic}
\alias{plot.MultimodDiagnostic}
\title{
Plotting Method for Multimodality Diagnostic Objects
}
\description{
The plotting method for objects of the S3 class 'MultimodDiagnostic', which are returned by the function \code{multiSTM()}, which performes a battery of tests aimed at assessing the stability of the local modes of an STM model. 
}
\usage{
\method{plot}{MultimodDiagnostic}(x, ind=NULL, topics=NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{x}{An object of S3 class 'MultimodDiagnostic'. See \code{\link{multiSTM}}.}
\item{ind}{An integer of list of integers specifying which plots to generate (see details). If \code{NULL} (default), all plots are generated.}
\item{topics}{An integer or vector of integers specifying the topics for which to plot the posterior distribution of covariate effect estimates. If \code{NULL} (default), plots are generated for every topic in the S3 object.}
\item{...}{Other arguments to be passed to the plotting functions.}
}
\details{
This methods generates a series of plots, which are indexed as follows. If a subset of the plots is required, specify their indexes using the \code{ind} argument. Please note that not all plot types are available for every object of class 'MultimodDiagnostic':
\enumerate{
  \item Histogram of Expected Common Words: Generates a 10-bin histogram of the column means of \code{obj$wmat}, a K-by-N matrix reporting the number of "top words" shared by the reference model and the candidate model. The "top words" for a given topic are defined as the 10 highest-frequency words.
  \item Histogram of Expected Common Documents: Generates a 10-bin histogram of the column means of \code{obj$tmat}, a K-by-N matrix reporting the number of "top documents" shared by the reference model and the candidate model. The "top documents" for a given topic are defined as the 10 documents in the reference corpus with highest topical frequency.
  \item Distribution of .95 Confidence-Interval Coverage for Regression Estimates: Generates a histogram of \code{obj$confidence.ratings}, a vector whose entries specify the proportion of regression coefficient estimates in a candidate model that fall within the .95 confidence interval for the corresponding estimate in the reference model. This can only be generated if \code{obj$confidence.ratings} is non-\code{NULL}.
  \item Posterior Distributions of Covariate Effect Estimates By Topic: Generates a square matrix of plots, each depicting the posterior distribution of the regression coefficients for the covariate speciefied in \code{obj$reg.parameter.index} for one topic. The topics for which the plots are to be generated are specified by the \code{topics} argument. If the length of \code{topics} is not a perfect square, the plots matrix will include white space. The plots have a dashed black vertical line at zero, and a continuous red vertical line indicating the coefficient estimate in the reference model. This can only be generated if \code{obj$cov.effects} is non-\code{NULL}.
  \item Histogram of Expected L1-Distance From Reference Model: Generates a 10-bin histogram of the column means of \code{obj$lmat}, a K-by-N matrix reporting the L1-distance of each topic from the corresponding one in the reference model.
  \item L1-distance vs. Top-10 Word Metric: Produces a smoothed color density representation of the scatterplot of \code{obj$lmat} and \code{obj$wmat}, the metrics for L1-distance and shared top-words, obtained through a kernel density estimate. This can be used to validate the metrics under consideration.
  \item L1-distance vs. Top-10 Docs Metric: Produces a smoothed color density representation of the scatterplot of \code{obj$lmat} and \code{obj$tmat}, the metrics for L1-distance and shared top-documents, obtained through a kernel density estimate. This can be used to validate the metrics under consideration.
  \item Top-10 Words vs. Top-10 Docs Metric: Produces a smoothed color density representation of the scatterplot of \code{obj$wmat} and \code{obj$tmat}, the metrics for shared top-words and shared top-documents, obtained through a kernel density estimate. This can be used to validate the metrics under consideration.
  \item Maximized Bound vs. Aggregate Top-10 Words Metric: Generates a scatter plot with linear trendline for the maximized bound vector (\code{obj$lb}) and a linear transformation of the top-words metric aggregated by model (\code{obj$wmod/1000}).
  \item Maximized Bound vs. Aggregate Top-10 Docs Metric: Generates a scatter plot with linear trendline for the maximized bound vector (\code{obj$lb}) and a linear transformation of the top-docs metric aggregated by model (\code{obj$tmod/1000}).
  \item Maximized Bound vs. Aggregate L1-Distance Metric: Generates a scatter plot with linear trendline for the maximized bound vector (\code{obj$lb}) and a linear transformation of the L1-distance metric aggregated by model (\code{obj$tmod/1000}).
  \item Top-10 Docs Metric vs. Semantic Coherence: Generates a scatter plot with linear trendline for the reference-model semantic coherence scores and the column means of \code{object$tmat}.
  \item L1-Distance Metric vs. Semantic Coherence: Generates a scatter plot with linear trendline for the reference-model semantic coherence scores and the column means of \code{object$lmat}.
  \item Top-10 Words Metric vs. Semantic Coherence: Generates a scatter plot with linear trendline for the reference-model semantic coherence scores and the column means of \code{object$wmat}.
  \item Same as \code{5}, but using the limited-mass L1-distance metric. Can only be generated if \code{obj$mass.threshold != 1}. 
  \item Same as \code{11}, but using the limited-mass L1-distance metric. Can only be generated if \code{obj$mass.threshold != 1}. 
  \item Same as \code{7}, but using the limited-mass L1-distance metric. Can only be generated if \code{obj$mass.threshold != 1}. 
  \item Same as \code{13}, but using the limited-mass L1-distance metric. Can only be generated if \code{obj$mass.threshold != 1}. 
}
}

\references{
Roberts, M., Stewart, B., & Tingley, D. (Forthcoming). "Navigating the Local Modes of Big Data: The Case of Topic Models. In Data Analytics in Social Science, Government, and Industry." New York: Cambridge University Press.}
\author{
Brandon M. Stewart (Princeton University) and Antonio Coppola (Harvard University)
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{multiSTM}}
}
\examples{

\dontrun{
# Example using Gadarian data

temp<-textProcessor(documents=gadarian$open.ended.response, 
                    metadata=gadarian)
meta<-temp$meta
vocab<-temp$vocab
docs<-temp$documents
out <- prepDocuments(docs, vocab, meta)
docs<-out$documents
vocab<-out$vocab
meta <-out$meta
set.seed(02138)
mod.out <- selectModel(docs, vocab, K=3, 
                       prevalence=~treatment + s(pid_rep), 
                       data=meta, runs=20)

out <- multiSTM(mod.out, mass.threshold = .75, 
                reg.formula = ~ treatment,
                metadata = gadarian)

plot(out)
plot(out, 1)

# One more example using Poliblog data

load(url("http://goo.gl/91KbfS"))
meta <- poliblogPrevFit$settings$covariates$X
out <- multiSTM(poliblogSelect, mass.threshold=.75, 
                reg.formula= ~ ratingLiberal,
                metadata=meta)

plot(out, ind=(1:4), topics=1)
plot(out, 16)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{stm}
\keyword{multimodality}

