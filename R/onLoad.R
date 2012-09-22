.onAttach <- function(libname, pkgname) {
    packageStartupMessage("Package 'trackObjs' has been renamed to 'track'.\n'trackobjs' will soon disappear from CRAN.\nPlease switch to package 'track'.")
}
