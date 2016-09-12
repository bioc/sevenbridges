[![Build Status](https://travis-ci.org/sbg/sevenbridges-r.svg?branch=master)](https://travis-ci.org/sbg/sevenbridges-r)
[![platform](http://www.bioconductor.org/shields/availability/devel/sevenbridges.svg)](http://bioconductor.org/packages/release/bioc/html/sevenbridges.html#archives)
[![bioc](http://www.bioconductor.org/shields/years-in-bioc/sevenbridges.svg)](http://bioconductor.org/packages/release/bioc/html/sevenbridges.html#since)
[![posts](http://www.bioconductor.org/shields/posts/sevenbridges.svg)](https://support.bioconductor.org/t/sevenbridges/)
[![downloads](http://www.bioconductor.org/shields/downloads/sevenbridges.svg)](http://bioconductor.org/packages/stats/bioc/sevenbridges/)
![cov](http://www.bioconductor.org/shields/coverage/release/sevenbridges.svg)


# sevenbridges: R Package for Seven Bridges Platform from API client to CWL generator 



[Bioconductor-Stable](http://www.bioconductor.org/packages/release/bioc/html/sevenbridges.html) |  [Bioconductor-Devel](http://www.bioconductor.org/packages/devel/bioc/html/sevenbridges.html) 

##### Table of Contents  

[Events](#events)  <br />
[Features](#features) <br />
[Installation](#install) <br />
[Tutorial](#tutorial) <br />
[IDE docker image](#rstudio) <br />
[Issues report](#issue) <br />
[Q and A](#qa) <br />

<a name="events"/>

### Events

- May 27 - 29, 2016 [The 9th China-R Conference 2016](http://china-r.org/bj2016/index.html) @ Renmin University, Beijng, China. (talk)
- June 24 - 26, 2016 [BioC 2016: Where Software and Biology Connect](http://bioconductor.org/help/course-materials/2016/BioC2016/) @ Stanford University, Stanford, CA (workshop)
- June 27 - 30, 2016 [The R User Conference 2016](http://user2016.org/) @ Stanford University, Stanford, CA (talk)
- (Past) [NCI Cancer Genomics Cloud Hackathon Tutorials](http://www.cancergenomicscloud.org/hacking-cancer/) @ Boston 2016
[[html](http://www.tengfei.name/sevenbridges/vignettes/bioc-workflow.html)] 
[[R markdown](http://www.tengfei.name/sevenbridges/vignettes/bioc-workflow.Rmd)] 
[[R script](http://www.tengfei.name/sevenbridges/vignettes/bioc-workflow.R)]

<a name="features"/>

### Features

- Complete API R client with user friendly API in object-oriented fashion with user friendly printing, support operation on users, billing, project, file, app, task etc, short example.

```r
## get project by pattern matching name
p = a$project("demo")
## get exact project by id
p = a$project(id = "tengfei/demo")
## detele files from a project
p$file("sample.tz")$delete()
## upload fies from a folder to a project with metadata
p$upload("folder_path", metadata = list(platform = "Illumina"))
```

- Task monitoring hook allow you to add hook function to task status when you monitor a task, for example, when task is finished sent you email or download all files.


```r
setTaskHook("completed", function(){
    tsk$download("~/Downloads")
})
tsk$monitor()
```

- Task batching by item and metadata

```r
## batch by items
(tsk <- p$task_add(name = "RNA DE report new batch 2", 
                   description = "RNA DE analysis report", 
                   app = rna.app$id,
                   batch = batch(input = "bamfiles"),
                   inputs = list(bamfiles = bamfiles.in, 
                                 design = design.in,
                                 gtffile = gtf.in)))

## batch by metadata, input files has to have metadata fields specified
(tsk <- p$task_add(name = "RNA DE report new batch 3", 
                   description = "RNA DE analysis report", 
                   app = rna.app$id,
                   batch = batch(input = "fastq", 
                                 c("metadata.sample_id", 
                                 "metadata.library_id")),
                   inputs = list(bamfiles = bamfiles.in, 
                                 design = design.in,
                                 gtffile = gtf.in)))
```


- Cross platform support from Seven
  Bridges, such as [NCI Cancer genomics cloud](http://www.cancergenomicscloud.org/) or [Seven bridges](https://www.sbgenomics.com/) on google and
  AWS, you can use it.

- Authentication management for multiple platforms/users via config file.

```r
## standard 
a = Auth(token = "fake_token", url = "api_url")
## OR from config file, multiple platform/user support
a = Auth(username = "tengfei", platform = "cgc")
```

- CWL Tool interface, you can directly describe your tool in R, export to JSON/YAML, or add it to your online project. This package defines a complete set
of CWL object. So you can describe tools like this

```r
library(readr)
fd <- fileDef(name = "runif.R",
              content = read_file(fl))
rbx <- Tool(id = "runif", 
            label = "runif",
            hints = requirements(docker(pull = "rocker/r-base"), 
                                 cpu(1), mem(2000)),
            requirements = requirements(fd),
            baseCommand = "Rscript runif.R",
            stdout = "output.txt",
            inputs = list(input(id = "number",
                                type = "integer",
                                position = 1),
                          input(id = "min",
                                type = "float",
                                position = 2),
                          input(id = "max",
                                type = "float",
                                position = 3)),
            outputs = output(id = "random", glob = "output.txt")) 
## output cwl JSON            
rbx$toJSON(pretty = TRUE) 
## output cwl YAML
rbx$toYAML()
```

- Utilities for Tool and Flow, for example

```r
# converting a SBG CWL json file
library(sevenbridges)
t1 = system.file("extdata/app", "tool_star.json", package = "sevenbridges")
## convert json file into a Tool object
t1 = convert_app(t1)
# shows all input matrix
t1$input_matrix() 
```

<a name="install"/>

### Installation

__[Bioconductor: Stable]__  

For most users, I will recommend this installation, it's most stable. The current release of Bioconductor is version 3.3; it works with __R version 3.3.0__. Users of older R and Bioconductor versions must update their installation to take advantage of new features. If you don't want to update your R, please install from github directly as introduced in next section. It's quite easy.

Now check your R version 

```r
 R.version.string
```

If you are not running latest R, first install R 3.3 following instruction [here](http://www.bioconductor.org/install/#install-R), after you successfully installed
R 3.3, if you are using Rstudio, please close and restart Rstudio, it will detect the 
new install. Then install `sevenbridges` package. 

```r
source("http://bioconductor.org/biocLite.R")
biocLite("sevenbridges")
```



__[Latest]__ 

You can always install the latest development version of the package from GitHub, it's always the most latest version, fresh new,  with all new features and hot fixes, we push to bioconductor branch (release/devel) regularly.

__If you don't have devtools__

This require you have `devtools` package, install it from CRAN if you don't have it

```r
install.packages("devtools") 
```

You may got an error and need system dependecies sometimes for curl and ssl, for example, in ubuntu you probably need to do this first in order to install `devtools` and in order to build vigenttes (you need pandoc)

```
apt-get update
apt-get install libcurl4-gnutls-dev libssl-dev pandoc pandoc-citeproc
```

__If devtools is already installed__

Now install latest version from github for `sevenbridges`

```r
source("http://bioconductor.org/biocLite.R")
biocLite(c("readr", "BiocStyle"))
library(devtools)
install_github("sbg/sevenbridges-r", build_vignettes=TRUE, 
  repos=BiocInstaller::biocinstallRepos(),
  dependencies=TRUE)
```

If you have trouble with pandoc and don't want to install pandoc,  set `build_vignettes = FALSE` to avoid vignettes build, 

__[Bioconductor: Devel]__ 

Install from bioconductor `devel` branch if you are developing tools in devel branch or if you are users who use devel version for R and Bioconductor. You need to install R-devel first, please follow the instruction ["Using the Devel Version of Bioconductor"](http://bioconductor.org/developers/how-to/useDevel/). After upgrade of R. This is kind of tricky and hard, if you just want to try latest feature, please install directly from github as next installation instruction.

```r
source("http://bioconductor.org/biocLite.R")
useDevel(devel = TRUE)
biocLite("sevenbridges")
```

To load the package in R, simply call

```r
library("sevenbridges")
```

<a name="tutorial"/>

### Tutorials 

We have 3 different version, github (latest), Bioconductor stable and devel. Only github version is provided below for latest docs. For other version,
please visit Bioconductor homepage (link provide at the top). Tutorials below is auto-generated at 8:00pm everyday with github version.

- Complete Guide for API R Client
[[html](http://www.tengfei.name/sevenbridges/vignettes/api.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/api.R)]
- Tutorial: use R for Cancer Genomics Cloud
[[html](http://www.tengfei.name/sevenbridges/vignettes/bioc-workflow.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/bioc-workflow.R)]
- Creating Your Docker Container and Command Line Interface
[[html](http://www.tengfei.name/sevenbridges/vignettes/docker.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/docker.R)]
- Describe CWL Tools/Workflows in R and Execution
[[html](http://www.tengfei.name/sevenbridges/vignettes/apps.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/apps.R)]
- IDE container: Rstudio and Shiny server and more
[[html](http://www.tengfei.name/sevenbridges/vignettes/rstudio.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/rstudio.R)]
- Find Data on CGC via Data Exploerer, SPARQL and Data API
[[html](http://www.tengfei.name/sevenbridges/vignettes/cgc-sparql.html)]
[[R script](http://www.tengfei.name/sevenbridges/vignettes/cgc-sparql.R)]


<a name="rstudio"/>

### Launch Rstudio Server and Shiny Server with sevenbridges IDE docker container

```shell
docker run  -d -p 8787:8787 -p 3838:3838 --name rstudio_shiny_server tengfei/sevenbridges
```

check out the ip from docker machine if you are on mac os.

```bash
docker-machine ip default
```

In your browser, `http://<url>:8787/` for Rstudio server, for example, if 192.168.99.100 is what returned, visit `http://192.168.99.100:8787/` for Rstudio.


For shiny server, __per user app__ is hosted `http://<url>:3838/users/<username of rstudio>/<app_dir>` for Shiny server, for example for user `rstudio` (a default user) and some app called `01_hello`, it will be `http://<url>:3838/users/rstudio/01_hello/`. To develop your shiny app as Rstudio user, you can login your rstudio server, and create a fold at home folder called `~/ShinyApps` and develop shiny apps under that folder, for example, you can create an app called `02_text` at `~/ShinyApps/02_text/`.

Login your rstudio at `http://<url>:8787`, then try to copy some example over to your home folder

```r
dir.create("~/ShinyApps")
file.copy("/usr/local/lib/R/site-library/shiny/examples/01_hello/", "~/ShinyApps/", recursive = TRUE)
```

If you are login as username 'rstudio', then visit  `http://192.168.99.100:3838/rstudio/01_hello` you should be able to see the hello example.


Note: Generic shiny app can also be hosted `http://<url>:3838/` or for particular app, `http://<url>:3838/<app_dir>` and inside the docker container, it's hosted under `/srv/shiny-server/`


<a name="issue"/>

### Issue report

All feedback are welcomed! Please file bug/issue/request on the [issue page](https://github.com/sbg/sevenbridges-r/issues) here on github, we will 
try to respond asap.

<a name="qa"/>

### Q&A

To ask a question about this package, the best place will be Bioconductor support website,
go visit support [website](https://support.bioconductor.org/), and tag your post with package name __sevenbridges__. 

- __Q__: Does this package support older API which is not cwl compatible?<br />
  __A__: No it only supports API v2 +, for older version, please check [sbgr](https://github.com/road2stat/sbgr) package, but 
please note that the old API or project type will be deprecated. 

- __Q__: Which version of CWL (common workflow language) supported now? <br />
  __A__: Draft 2, progress on draft 3.
  
- __Q__: Is there a python binding for the API? <br />
  __A__: Yes, official python client is [here](https://github.com/sbg/sevenbridges-python). And lots python recipes are now [here](https://github.com/sbg/okAPI)
  
- __Q__: Why I always get warning message when I use API R client?<br />
  __A__: It only exists in Rstudio, potentially a bug in Rstudio. To ignore it use `options(warn = -1)`

- __Q__: I still have some problem
  __A__: Please try use the latest package on github, at least update to your package on Bioconductor, that usually solved the most recent bugs. 
  
<hr>

© Seven Bridges Genomics 2012 - 2016. Licensed under the MIT license.
