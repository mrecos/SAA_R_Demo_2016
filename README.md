### Documentation for:
# SAA On-line Seminar Series - *Using R Statistical Computing Language for Archaeological*
### - Hosted by the Society for American Archaeology


# Introduction
This is a Github repository to hold information relative to the 2-hour seminar entitled: "Using R Statistical Computing Language for Archaeological".  This introductory seminar is being hosted by the [Society for American Archaeology][SAA] on September 27th at 2 to 4pm (EDT).  SAA members can sign up through [SAA Seminars] page.  Beacuse this is a professional development seminar that is eligible for Continuing Education Credits from the [Register for Profesional Archaeologists][RPA] it is a fee-based seminar.  The materials presented in this repo are intended to help participants of this seminar gain familiarity with R and data analaysis, but are free to be used by anyone else to learn a bit about R and its use in archaeology.  While the slides from the seminar and audio/video are property of the SAA and not available here, I think there should be lots of material here to help anyone get started.

Given that the seminar is not in person, only two hours in length, and geared towards giving a broad introduction to the capabilities and potential of usnig R in arhcaeology, it is not a hands-on demo.  However, with the material presented here, attendees may download the data and code to follow along during the seminar or repeat the analysis afterwords.  Contact me at the addresses below and I will be happy to help get you started before the seminar or walk-though the material afterwards.

#### About me
My name is Matt harris, I am an archaeologist and GIS professional with 16 years of experience conducting archaeological excavations, planning GIS studies, field data collection, statistical analysis, model building, and more so these days project management and associated tasks. While I have worked at in University and State agency roles, most of my carreer thus far is in the private sector field of Cultrual Resources Management.  I currently work for [AECOM] in their Burlington, New Jersey office.

I can be found at:
  * [@Md_Harris] - On Twitter talking about models, data viz, and archaeology
  * [My blog] - Occasional postings about the same stuff, but with code and lots of tangents
  * email: matthew.d.harris [at] aecom.com
 
# What's in here?
This repro is inteded to hold some information and code relevant to the SAA seminar, as well as help anyone who stumbles on here looking for introductory material for R. This repo is not a full documentation of the seminar, as that is property of the SAA, but it is a good launch pad for preparing for the seminar and learning about the R ecosystem.
The basic content includes:

  - Details on the seminar content
  - Data sets that will be used in the seminar
  - R code that will be used in the seminar
  - Link to software resources, classes, videos, and websites with good introductory material for learning R
 
# Getting started: Installing R
In ordet to learn about R, it is helpful to have R!  The basic installation of R provides the language and a basic editor/user interface for interactive coding.  For most Windows and Mac users, the precompiled installers should be the path of least resistence.  *nix users and those that wish to compile there own will find plenty of help on the web.  While the basic R environment is ok, there is a much better option to interface with the language; that is RStudio.  RStudio is a fully featured Interactive Development Environment (IDE) that allows you to take full advantage of R and all the added features of the IDE.  
1) Install R from [CRAN][R download]

2) Install [RStudio][R Studio Download]

3) Wactch a brief [RStudio intro video][R Studio Intro video] and check out the learning resources below 

# Course Material
Accompanying the on-line 2hr seminar, below are links to R Markdown documents that we will cover as part of learning the basics of R.  The `*.rmd` and `*.html` are stored in the `r_markdown_docs` folder of this repo; the linked html is hosted on [RPubs], but the same files are used.  The bascis covered in these documents is used to support the more in-depth project examples that we will go through live during the seminar.  However, these can be used and reviewed (along with the additional learning resources linked below) at any time to help you learn the basics of R.
### Basics of learning R
1. [Introduction to basic R concepts][r_basic_concepts]
2. [Working with data][r_working_with_data]: Operators, Loops, and Functions
3. [Basics of creating and importing data][r_basic_data_import]
4. Tidy Data (forth coming...)
5. Plotting (forth coming...)

### Working examples of R in action
1. Data Processing/Munging (forth coming...)
2. Exploratory Data Analysis (EDA) (forth coming...)
3. Modeling & Machine Learning (forth coming...)
4. Data Visualization (forth coming...)
5. Reproducibility (forth coming...)

# Learning resources
The internet is full of resources (videos, blogs, tutorials, books) for learning R.  Many of these resources are worthwhile, some are exeptional, and some are a waste of time.  Sorting through them is beyond the scope of this course, but a few links below will help zero in an some of the best generalized resources:
- Where to [find help][DC_help] with R
- [Google Intro to R videos]
- [R Studio On-line Learning]
- Grolemund and Wickham's [R For Data Science][r4ds]
- [Ramnath Vaidyanathan's][ramnath] Introduction to R course
- Welcome to the [Tidyverse]
- [Tidy tools manifesto][tidy] by Hadley Wickham
- [Wide vs. Long Data][wide_long_data]
- [Data Camp]
- [R on Coursera]
- [R on Code School]
- [R at Software Carpentry]
- [R Tutorial from UCLA]
- [ggplot2 Tutorial]
- Tutorials on [spatial topics][neon] raster, vector, time series, etc...

Resoures specific to R in archaeology are not numerous, but there are a growing number of really great resources:
- Nakoinz and Knitter's new book [Modelling Human Behaviour in Landscapes][mhbil] and its [assocaited GitHub site][mhbil_gh] with chapter by chapter R code!
- Ben Marwick's [Archaeological Science Github page][MarwickGH] - A very extensve list of tools and resources.  A really great resource!
- Stefano Costa's [Rchaeology Tutorials/wiki][stekoRchaeology] and [Github page][stekoRchaeologyGH] - Not updated for a number of years, but great information. 
- Mike Baxter's manuscript [Notes on Quantitative Archaeology and R][BaxterQuantArch] - Fantastic primer on stats for archaeology using R.
- [zooaRch: An R Package for Zooarchaeological Analyses][zooarch] -  really great R packaged by Erik Otárola-Castillo, Jess Wolfhagen, and Max Price
- [Quantitative Archaeology][my blog] - My blog
- [AAPA R Workshop] - Description and links from AAPA 2016 R workshop
- David Carlson's [An R Companion to Statistics for Archaeologists by Robert Drennan][CarlsonStats] - a dense, but complete read when accompanying Drennan's book.
- Matt Peeples [Research page][Peeples] 

Resources for getting started learning and practicing Reproducible Research:
- rOpenSci [Reproducibility Guide][rOpenSci_reproducible]: a great intro to why & how with in-depth links.
- Ben Marwick's slidedeck for [Reproducible Research" A Primer for the Social Sciences][marwickslides]
- Marwick's great [essay on reproducibiliy][marwickcompsbrokeit]
- Victoria Stodden's [Why scientists must share their research code][stodden]: widely circulated recent piece
- Karl Broman's [Tools for Reproducible Research][kbroman]: a site for Karl's course on the topic, but has great links; dig into it.
- John Hopkins University Coursera course of [Reproducible Research][JHU_repro]
- RStudio guide to [R Markdown]

# Data for Seminar
The vast majority of the data used in the examples of the seminar are drawn from the [Archdata] package for R.  This is a fantastic package pulled together by David L. Carlson (Texas A & M) and Georg Roth.  This pacakge offers 24 different archaeological data sets along with meta-data including description, source, and references.  The data sets in this package have been used in various archaeological studies and the package author often includes R examples of these analyses.  

As we will cover in the seminar, installing a package in R is as simple as typing: ```install.packages("archdata")``` , then: ```library("archdata")``` to load the package, and then ```data("data-set-name")``` to load that specific data set into the environment.

Additional data will be in the form of CSV files and GIS Shapefiles for examples of how to import these common data types.  These files are in the `data` folder in this GitHub repo.

# Seminar Schedule
1. Introduction
    * About me
    * Seminar Goals
    * Learning Resources
2. Introduction to R
    * Brief Demo
    * Some truths about working in R
    * Uses across science and technology
3. R in Archaeology
    * Explore existing applications of R in our field
    * Motivating examples
    * Questions...
4. Reproducible Research
    * What is it?
    * Why should I do it?
    * How do I practice reproducibility?
5. Getting Started with R
    * Installing (will not be done live)
    * RStudio IDE - Demo
    * R package environment
6. The basics of R - Getting your feet wet
    * Syntax - [Link to markdown][r_basic_concepts]
    * Data structures  - [Link to markdown][r_working_with_data]
    * Importing data - [link to markdown][r_basic_data_import]
    * Plotting (base R)
7. Quick Break at half-time
8. Introdcution to Examples
    * Motivation
    * Scope of examples
9. Data Entry and Preperation
    * Data Input
    * Viewing Data
    * Data manipulation
    * Example - Field Data Processing
10. Data Analysis
    * Exploratory Data Analysis (EDA)
    * Modeling
    * Example - TBD
11. Data Visualization
    * planning data visualiztions
    * Plotting in ggplot2
    * Example - Pueblo Migration
12. Reporting and Reproducibility
    * Documentation with knitr
    * Example - Bornholm grave ornamentation CA




[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [R Studio]: <https://www.rstudio.com/>
   [R Studio Download]: <https://www.rstudio.com/products/rstudio/download3/>
   [R Studio On-line Learning]: <https://www.rstudio.com/online-learning/>
   [My blog]: <http://www.matthewdharris.com>
   [@md_harris]: <http://twitter.com/Md_Harris>
   [Data Camp]: <https://www.datacamp.com/>
   [R Download]: <https://cran.rstudio.com/>
   [R Studio Download]: <https://www.rstudio.com/products/rstudio/download2/>
   [R on Coursera]: <https://www.coursera.org/learn/r-programming>
   [R on Code School]: <http://tryr.codeschool.com/>
   [R at Software Carpentry]: <http://swcarpentry.github.io/r-novice-gapminder/>
   [R Tutorial from UCLA]: <http://web.cs.ucla.edu/~gulzar/rstudio/basic-tutorial.html>
   [ggplot2 Tutorial]: <http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html>
   [AAPA R Workshop]: <http://www.davidpappano.com/r-workshop-at-aapa-2016.html>
   [@djpappano]: <https://twitter.com/djpappano>
   [Statistial Rethinking Class Videos]: <https://www.youtube.com/playlist?list=PLDcUM9US4XdMdZOhJWJJD4mDBMnbTWw_z>
   [Google Intro to R videos]: <https://www.youtube.com/watch?v=iffR3fWv4xw&list=PLOU2XLYxmsIK9qQfztXeybpHvru-TrqAP>
   [R Studio Intro video]:  <https://www.youtube.com/watch?v=uwlwNRbaKMI>
   [SAA]: <http://www.saa.org/>
   [SAA Seminars]: <http://www.saa.org/AbouttheSociety/OnlineSeminars/tabid/1503/Default.aspx>
   [RPA]: <http://www.rpanet.org/>
   [AECOM]: <http://aecom-burlington.com/>
   [Archdata]: <https://cran.rstudio.com/web/packages/archdata/index.html>
   [MarwickGH]: <https://github.com/benmarwick/ctv-archaeology>
   [DataCarpentry]: <http://www.datacarpentry.org/lessons/>
   [r4ds]: <http://r4ds.had.co.nz/introduction.html>
   [CarlsonStats]: <http://people.tamu.edu/~dcarlson/quant/Drennan/StatisticsArchaeologistsR.pdf>
   [Peeples]: <http://www.mattpeeples.net/resources.html>
   [stekoRchaeologyGH]: <https://github.com/steko/rchaeology>
   [stekoRchaeology]: <http://rchaeology.readthedocs.io/en/latest/index.html>
   [BaxterQuantArch]: <https://www.researchgate.net/publication/277931925_Notes_on_Quantitative_Archaeology_and_R>
   [kbroman]: <http://kbroman.org/Tools4RR/>
   [marwickslides]: <http://benmarwick.github.io/CSSS-Primer-Reproducible-Research/#/>
   [marwickcompsbrokeit]: <https://theconversation.com/how-computers-broke-science-and-what-we-can-do-to-fix-it-49938>
   [stodden]: <http://www.nature.com/news/why-scientists-must-share-their-research-code-1.20504>
   [rOpenSci_reproducible]: <http://ropensci.github.io/reproducibility-guide/sections/introduction/>
   [JHU_repro]: <https://www.coursera.org/learn/reproducible-research>
   [r4ds]: <http://r4ds.had.co.nz/introduction.html>
   [mhbil_gh]: <https://github.com/dakni/mhbil>
   [mhbil]: <http://www.springer.com/us/book/9783319295367>
   [DC_help]: <http://www.datacarpentry.org/R-genomics/00-before-we-start.html>
   [zooarch]: <https://cran.r-project.org/web/packages/zooaRch/vignettes/zooaRch-vignette.html>
   [Tidyverse]: <http://blog.revolutionanalytics.com/2016/09/tidyverse.html>
   [tidy]:<https://mran.microsoft.com/web/packages/tidyverse/vignettes/manifesto.html>
   [neon]: <http://neondataskills.org/tutorial-series/>
   [R Markdown]: <http://rmarkdown.rstudio.com/index.html>
   [ramnath]:<https://ramnathv.github.io/pycon2014-r/>
   [r_basic_concepts]:<http://rpubs.com/mharris/211896>
   [r_working_with_data]:<http://rpubs.com/mharris/r_working_with_data>
   [RPubs]: <https://rpubs.com/>
   [wide_long_data]:<http://stanford.edu/~ejdemyr/r-tutorials/wide-and-long/>
   [r_basic_data_import]:<http://rpubs.com/mharris/r_basic_data_import>

   
   
   
   
   
   
   
   
