#
#
# package management quick reference
# list of CRAN mirrors https://cran.r-project.org/mirrors.html

# check repository used by current R session
getOption("repos")

# check path of current local library
normalizePath(.libPaths(), winslash = "/")

# check current local library of packages
installed.packages()[, "Package"]

# choose a CRAN repo mirror site from a list
chooseCRANmirror()

# choose a CRAN repo via URL
options(repos=structure(c(CRAN="http://cran.us.r-project.org")))

# install from a particular mirror
install.packages('rmarkdown', repos='http://cran.us.r-project.org')

# permanently set CRAN repo # does not work with Microsoft R distro
local({
  r <- getOption("repos")
  r["CRAN"] <- "http://cran.us.r-project.org"
  options(repos = r)
})

# add repos
setRepositories(addURLs =
                  c(CRANxtras = "http://cran.us.r-project.org"))
setRepositories(addURLs =
                  c(CRAN = "http://cran.us.r-project.org"))

# list of packages with newer versions available
old.packages()

# Using Microsoft R distibution
# Microsoft uses the MRAN repo
# checkpoint package from MSFT is helpful for using a specific repo snapshot
# more info at http://bit.ly/1Rzrqdy

# install.p When you create a checkpoint, the checkpoint() function performs the following:
#   
#   Creates a snapshot folder to install packages. This library folder is located at ~/.checkpoint
# Scans your project folder for all packages used. Specifically, it searches for all instances of library() and requires() in your code.
# Installs these packages from the MRAN snapshot into your snapshot folder using install.packages()
# Sets options for your CRAN mirror to point to a MRAN snapshot, i.e. modify options(repos)
# This means the remainder of your script will run with the packages from a specific date.ackages("checkpoint")
library(checkpoint)
# checkpoint("2016-03-15") # use Austria CRAN repo snapshot from 3-15-2016
# for all packages referenced in current working directory



