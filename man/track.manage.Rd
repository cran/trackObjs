\name{track.manage}
\alias{track}
\alias{track.assign}
\alias{untrack}
\alias{track.remove}
\alias{track.save}
\alias{track.resave}
\alias{track.flush}
\alias{track.forget}
\alias{track.load}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Manage how objects are handled in a tracking session }
\description{
  Functions to start and stop tracking objects, remove them, load objects from
  RData files, and manage cached and saved copies of objects.  These
  functions should not be needed in plain vanilla use of the track
  package.

  For an introduction to the track package, see \link[=track-package]{Overview}.
}
\usage{
track(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL, exclude = TRUE)
track.assign(x, value, pos = 1, envir = as.environment(pos), flush = TRUE)
untrack(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL, all = FALSE, keep.in.db = FALSE)
track.remove(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL, all = FALSE, force = TRUE)
track.save(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL,
        all = missing(expr) && missing(list) && missing(pattern) && missing(glob))
track.resave(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL,
        all = missing(expr) && missing(list) && missing(pattern) && missing(glob))
track.flush(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL,
        all = missing(expr) && missing(list) && missing(pattern) && missing(glob),
        force = FALSE)
track.forget(expr, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL, all = FALSE)
track.load(files, pos = 1, envir = as.environment(pos), list = NULL,
        pattern = NULL, glob = NULL, cache = FALSE, clobber = FALSE,
        time.of.file = TRUE, warn = TRUE)
}

\arguments{
  \item{expr}{ An unquoted variable name }
  \item{pos}{ The search path position of the environment being tracked
    (default is 1 for the global environment)}
  \item{envir}{ The environment being tracked.  This is an alternate way
    (to the use of \code{pos=})
  of specifying the environment being tracked, but should be rarely needed.}
  \item{list}{ A character vector of variable names to operate upon }
  \item{pattern}{ A regular expression specifying variable names to operate upon }
  \item{glob}{ A regular expression specifying variable names to operate upon }
  \item{all}{If \code{TRUE}, operate upon all elegible variables.  The
  default is \code{FALSE} for functions that can change data, and
  \code{TRUE} for functions that merely control whether data is in
  memory or file or both.}
  \item{exclude}{Controls exclusion of particular variables by pattern
  matching against a vector of regular expressions in the
  \code{autoTrackExcludePattern} option value.  If \code{exclude==TRUE} (the default),
  exclude variables that match. If \code{exclude==FALSE}, ignore the
  exclusion patterns.}
  \item{keep.in.db}{If \code{TRUE}, the variable is left in the
    tracking database, though the link to it is broken (it becomes masked)}
  \item{files}{ A vector of names of RData files (any file saved by \code{save()})}
  \item{cache}{ \code{TRUE} or \code{FALSE} indicating whether to keep the tracked
    object cached in memory }
  \item{clobber}{ \code{TRUE} or \code{FALSE} indicating whether to
    overwrite existing objects of the same name}
  \item{force}{ If \code{TRUE}, for \code{track.remove} remove orphaned
  tracked variables; for \code{track.flush} flush out variables that
  would normally be kept in cache. }
  \item{time.of.file}{ If \code{TRUE}, use the access times on the file
    to populate the access time fields in the tracking summary.}
  \item{warn}{ If \code{TRUE}, issue warnings about object not acted
    upon.}
  \item{x}{A variable name, as a character vector of length 1}
  \item{value}{The value to assign}
  \item{flush}{Logical value, specifying whether to flush the assigned
  object out of memory}
}
\details{
  These functions are executed for their side effects:
  \itemize{
  \item \code{track}: start tracking the specified variables
  \item \code{track.assign}: assign a value to a variable (start
  tracking variable if it is not already tracked.)  Optionally flush the
  value out of memory.
  \item \code{untrack}: stop tracking the specified variables, leaving the object in \code{envir} so that it can
    still be used.  If \code{keep.in.db=TRUE}, the variable is left
    in the tracking environment (but is masked), if
    \code{keep.in.db=FALSE} (the default),
    all trace of the variable is completely removed from the tracking
    environment.
  \item \code{track.remove}: completely remove all
  traces of a tracked variable (also removes untracked variables)
  \item \code{track.save}: write unsaved variables to disk
  \item \code{track.flush}: write unsaved variables to disk, and remove from memory
  \item \code{track.forget}: delete cached
  versions without saving to file (file version will be retrieved next
  time the variable is accessed)
  \item \code{track.rescan}: reload variable
  values from disk (can forget all cached vars, remove no-longer existing tracked vars)
  \item \code{track.load}: load variables from a
  saved RData file into the tracking session - if \code{list} is
  supplied, only these variables are loaded in.  Already existing
  variables will be skipped and not overwritten unless \code{clobber=TRUE} is supplied.
}
  The variables to be acted upon are specified either
  in \code{expr} (a variable name, unquoted) or \code{list} (character
  vector containing names of variables), or by regular expression \code{pattern}
  or shell pattern \code{glob}.  If no specification is given, all
  variables are acted upon.
}
\value{
  The value returned from these functions is invisible and typically contains the names
  of objects acted upon.

    \item{track:}{a character vector containing the names of
      objects added to the tracking environment}
    \item{untrack, track.remove, track.save, track.flush, track.forget, track.rescan:}{a
      character vector containing the names of
      objects in the tracking environment that were acted upon}
    \item{track.load:}{a list with two components:
      \itemize{
        \item \code{loaded}: names of objects that were loaded from \code{file}
        \item \code{skipped}: names of objects in \code{file} that
          were not loaded
    }
  }
}
\author{Tony Plate <tplate@acm.org>}
\seealso{ \link[=track-package]{Overview} and \link[=track.design]{design} of the \code{track} package. }
\examples{
##############################################################
# Warning: running this example will cause variables currently
# in the R global environment to be written to .RData files
# in a tracking database on the filesystem under R's temporary
# directory, and will cause the variables to be removed temporarily
# from the R global environment.
# It is recommended to run this example with a fresh R session
# with no important variables in the global environment.
##############################################################

library(trackObjs)
track.start(dir=file.path(tempdir(), 'rdatadir5'))
x <- 33
X <- array(1:24, dim=2:4)
Y <- list(a=1:3,b=2)
X[2] <- -1
track.summary(time=0, access=1, size=FALSE)
y1 <- 2
y2 <- 3
z1 <- 4
z2 <- 5
z3 <- 6
untracked()
track.summary(time=0, access=1, size=FALSE)
ls(all=TRUE)
track.stop(pos=1)
ls(all=TRUE)
a <- 7
b <- 8
save(list=c("a", "b"), file=file.path(tempdir(), "ab.rda"))
remove(list=c("a", "b"))
track.start(dir=file.path(tempdir(), 'rdatadir5'))
track.summary(time=0, access=1, size=FALSE)
track.load(file.path(tempdir(), "ab.rda"))
track.summary(time=0, access=1, size=FALSE)
track.status()
# Would normally not call track.stop(), but do so here to clean up after
# running this example.
track.stop(pos=1, keepVars=TRUE)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ data }
