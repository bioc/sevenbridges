.onLoad <- function(libname, pkgname) {
  lst <- list(
    offset = 0,
    limit = 100,
    advance_access = FALSE,
    input_check = TRUE,
    taskhook = TaskHook()
  )

  options(sevenbridges = lst)
}
.onAttach <- function(libname, pkgname) {
    msg <- sprintf(
        "Package '%s' is deprecated and will be removed from Bioconductor
         version %s", pkgname, "3.25")
    .Deprecated(msg=paste(strwrap(msg, exdent=2), collapse="\n"))
}
