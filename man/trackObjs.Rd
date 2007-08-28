\name{pkg-trackObjs}
\alias{pkg-trackObjs}
\alias{trackObjs}
\docType{package}
\title{
Overview of trackObjs package
}
\description{

The trackObjs package sets up a link between R objects in memory and
files on disk so that objects are automatically resaved to files when
they are changed.  R objects in files are read in on demand and do not
consume memory prior to being referenced.  The trackObjs package also
tracks times when objects are created and modified, and caches some
basic characteristics of objects to allow for fast summaries of objects.

Each object is stored in a separate RData file using the standard
format as used by \code{save()}, so that objects can be manually
picked out of or added to the trackObjs database if needed.

}
\details{
There are three main reasons to use the \code{trackObjs} package:
\itemize{
  \item conveniently handle many moderately-large objects that would
  collectively exhaust memory or be inconvenient to manage in
  files by manually using \code{save()} and \code{load()}
  \item keep track of creation and modification times on objects
  \item get fast summaries of basic characteristics of objects - class,
  size, dimension, etc.
}

There is an option to control whether tracked objects are cached in
memory as well as being stored on disk.  By default, objects are
not cached.  To save time when working with collections of objects that
will all fit in memory, turn on
caching with
\code{\link[=track.options]{track.options(cache=TRUE)}}, or start
tracking with \code{\link[=track.start]{track.start(..., cache=TRUE)}}.

Here is a brief example of tracking some variables in the global environment:

\preformatted{
> library(trackObjs)
> track.start("tmp1")
> x <- 123                  # Not yet tracked
> track(x)                  # Variable 'x' is now tracked
> track(y <- matrix(1:6, ncol=2)) # 'y' is assigned & tracked
> z1 <- list("a", "b", "c")
> z2 <- Sys.time()
> track(list=c("z1", "z2")) # Track a bunch of variables
> track.summary(size=F)     # See a summary of tracked vars
            class    mode extent length            modified TA TW
x         numeric numeric    [1]      1 2007-09-07 08:50:58  0  1
y          matrix numeric  [3x2]      6 2007-09-07 08:50:58  0  1
z1           list    list  [[3]]      3 2007-09-07 08:50:58  0  1
z2 POSIXt,POSIXct numeric    [1]      1 2007-09-07 08:50:58  0  1
> # (TA="total accesses", TW="total writes")
> ls(all=TRUE)
[1] "x"  "y"  "z1" "z2"
> track.stop()              # Stop tracking
> ls(all=TRUE)
character(0)
>
> # Restart using the tracking dir -- the variables reappear
> track.start("tmp1") # Start using the tracking dir again
> ls(all=TRUE)
[1] "x"  "y"  "z1" "z2"
> track.summary(size=F)
            class    mode extent length            modified TA TW
x         numeric numeric    [1]      1 2007-09-07 08:50:58  0  1
y          matrix numeric  [3x2]      6 2007-09-07 08:50:58  0  1
z1           list    list  [[3]]      3 2007-09-07 08:50:58  0  1
z2 POSIXt,POSIXct numeric    [1]      1 2007-09-07 08:50:58  0  1
> z1
[[1]]
[1] "a"

[[2]]
[1] "b"

[[3]]
[1] "c"

> track.status()
    Status InMem FileBase FileExists Saved
x  tracked FALSE        x       TRUE  TRUE
y  tracked FALSE        y       TRUE  TRUE
z1 tracked FALSE       z1       TRUE  TRUE
z2 tracked FALSE       z2       TRUE  TRUE
> track.stop()
>
> list.files("tmp1", all=TRUE)
[1] "."                    ".."
[3] "filemap.txt"          ".trackingSummary.rda"
[5] "x.rda"                "y.rda"
[7] "z1.rda"               "z2.rda"
>
}

There are several points to note:
\itemize{
  \item Vars must be explicitly \code{track()}'ed - newly created objects
  are not tracked.  (This is not a "feature", but the package author knows no way of
  automatically tracking newly created objects.)
  \item When tracking is stopped, all
  tracked variables are saved on disk and will be no longer accessible.
  \item The objects are stored on disk in files in the 
  tracking dir, and are stored in the
  format used by \code{save()}/\code{load()} (RData files).
}
}

\section{List of basic functions and common calling patterns}{
  
\itemize{
  \item \code{\link[=track.start]{track.start(dir=...)}}: start tracking,
  using the supplied directory
  \item \code{\link[=track.start]{track.stop()}}: stop tracking
  (any unsaved tracked variables are saved to disk and all tracked variables
  become unavailable until tracking starts again)
  \item \code{\link[=track]{track(x)}}: start tracking 'x'
  \item \code{\link[=track]{track(var <- value)}}: start tracking 'var'
  \item \code{\link[=track]{track(list=c('x', 'y'))}}: start tracking a
  list of variables
  \item \code{\link[=track]{track(all=TRUE)}}: start tracking all
  untracked variables
  \item \code{\link[=untrack]{untrack(x)}}: stop tracking variable 'x' -
  the R object is left accessible in the environment
  \item \code{\link[=untrack]{untrack(all=TRUE)}}: stop tracking all variables
  \item \code{\link[=untrack]{untrack(list=...)}}: stop tracking a list
  of variables
  \item \code{\link[=track.summary]{track.summary()}}: return a data
  frame containing a summary of the basic characteristics of tracked
  variables: name, class, extent, and creation, modification and access times.
}
}

\section{Complete list of functions and common calling patterns}{
  
The functions that can be used to set up and take down tracking are:
\itemize{
  \item \code{\link[=track.start]{track.start(dir=...)}}: start tracking,
  using the supplied directory
  \item \code{\link[=track.start]{track.stop()}}: stop tracking
  (any unsaved tracked variables are saved to disk and all tracked variables
  become unavailable until tracking starts again)
  \item \code{\link[=track.start]{track.dir()}}: return the path of the
  tracking directory
}

Functions for tracking and stopping tracking variables:
\itemize{
  \item \code{\link[=track]{track(x)}}
  \code{\link[=track]{track(var <- value)}}
  \code{\link[=track]{track(list=...)}}
  \code{\link[=track]{track(all=TRUE)}}: start tracking variable(s)
  \item \code{\link[=track.load]{track.load(file=...)}: load some objects from
    a RData file into the tracked environment}
  \item \code{\link[=untrack]{untrack(x, keep.in.db=FALSE)}}
  \code{\link[=untrack]{untrack(list=...)}}
  \code{\link[=untrack]{untrack(all=TRUE)}}: stop tracking variable(s) -
  value is left in place, and optionally, it is also left in the the database
}

Functions for getting status of tracking and summaries of variables:
\itemize{  \item \code{\link[=track.summary]{track.summary()}}: return a data
  frame containing a summary of the basic characteristics of tracked
  variables: name, class, extent, and creation, modification and access times.
  \item \code{\link[=track.status]{track.status()}}: return a data frame
  containing information about the tracking status of variables: whether
  they are saved to disk or not, etc.
  \item \code{\link[=env.is.tracked]{env.is.tracked()}}: tell whether an
  environment is currently tracked
}

The remaining functions allow the user to more closely manage variable
tracking, but are less likely to be of use to new users.

Functions for getting status of tracking and summaries of variables:
\itemize{
  \item \code{\link[=tracked]{tracked()}}: return the names of tracked variables
  \item \code{\link[=untracked]{untracked()}}: return the names of
  untracked variables
  \item \code{\link[=untrackable]{untrackable()}}:  return the names of
  variables that cannot be tracked
  \item \code{\link[=track.unsaved]{track.unsaved()}}: return the names of
  variables whose copy on file is out-of-date
  \item \code{\link[=track.orphaned]{track.orphaned()}}: return the
  names of once-tracked variables that have lost their active binding
  (should not happen)
  \item \code{\link[=track.masked]{track.masked()}}: return the names of
  once-tracked variables whose active binding has been overwritten by an
  ordinary variable (should not happen)
}

Functions for managing tracking and tracked variables:
\itemize{
  \item \code{\link[=track.options]{track.options()}}: examine and set
  options to control tracking
  \item \code{\link[=track.remove]{track.remove()}}: completely remove all
  traces of a tracked variable
  \item \code{\link[=track.save]{track.save()}}: write unsaved variables to disk
  \item \code{\link[=track.flush]{track.flush()}}: write unsaved variables to disk, and remove from memory
  \item \code{\link[=track.forget]{track.forget()}}: delete cached
  versions without saving to file (file version will be retrieved next
  time the variable is accessed)
  \item \code{\link[=track.restart]{track.restart()}}: reload variable
  values from disk (can forget all cached vars, remove no-longer existing tracked vars)
  \item \code{\link[=track.load]{track.load()}}: load variables from a
  saved RData file into the tracking session
}

Functions for recovering from errors:
\itemize{
  \item \code{\link[=track.rebuild]{track.rebuild()}}: rebuild tracking
  information from objects in memory or on disk
  \item \code{\link[=track.flush]{track.flush()}}: write unsaved variables to disk, and remove from memory
}

Design and internals of tracking:
\itemize{
  \item \code{\link[=track.design]{track.design}}
}
}

\author{Tony Plate <tplate@acm.org>}
\references{
Roger D. Peng. Interacting with data using the filehash package. R
News, 6(4):19-24, October
2006. \code{http://cran.r-project.org/doc/Rnews} and
\code{http://sandybox.typepad.com/software}

David E. Brahm. Delayed data packages. R News, 2(3):11-12, December
2002.  \code{http://cran.r-project.org/doc/Rnews}
}

\seealso{
\link[track.design]{Design} of the \code{trackObjs} package.

Potential \link[track.future]{future features} of the \code{trackObjs} package.

Documentation for \code{\link[save]{save}} \code{\link[load]{load}} (in 'base' package).

Documentation for \code{\link[base]{makeActiveBinding}} and related
functions (in 'base' package).

Inspriation from the packages \code{\link[g.data:g.data-package]{g.data}} and
\code{\link[filehash:filehash-package]{filehash}}.
}
\keyword{ package }
\keyword{ data }
\keyword{ database }
\keyword{ utilities }
