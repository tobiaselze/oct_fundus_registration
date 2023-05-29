
# "Makefile" for R packages;
# adapt the package name and
# store all your functions in a file functions.R
# and all your data files you want to include in
# a directory "data" in the current working directory


args = commandArgs(trailingOnly=TRUE)

# this can be overwritten by the first two command line args:
package.default = "octfundusreg"
version.default = "0.1"

package <- ifelse(length(args)<1, package.default, args[1])
version <- ifelse(length(args)<2, version.default, args[2])


##### identify dependencies from other packages via #' import...:
functionfile.lines = readLines("functions.R")
find.dependency <- function(deps, l)
{
	if(startsWith(l, "#' @import"))
		c(deps, gsub("^#' @import[^ ]* ([^ ]+) ?.*$", "\\1", l))
	else deps
}
import.packages <- paste(
	Reduce(find.dependency, functionfile.lines, c()),
	collapse = ", ")


# add DESCRIPTION tags here...
description.fields <- list(
	`Authors@R` = 'person("Tobias", "Elze", email = "tobias_elze@meei.harvard.edu",
                          role = c("aut", "cre"),
                          comment = c(ORCID = "0000-0002-2032-0496"))',
	Imports=import.packages,
	Version=version,
	Title="Register OCT scans",
	Description="Register ophthalmic optical coherence tomography (OCT) scans using OCT generated fundus images",
	Maintainer="Tobias Elze <tobias_elze@meei.harvard.edu>",
	LazyData="true",	# to load the data automatically when needed (without calling data())
	License="GPL (>= 2)")

devtools::create(package, fields=description.fields)

# include data files stored in data:
if(dir.exists("data"))
{
	# use devtools::use_data() when including data directly from a variable;
	# if the data file already exists, use this:
	file.copy("data", package, recursive=TRUE)
}


file.copy("functions.R", paste0(package, "/R/"))

# this calls roxygen2:
devtools::document(package)






