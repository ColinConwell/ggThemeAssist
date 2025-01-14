ggThemeAssist
==============
[![Build Status](https://travis-ci.org/calligross/ggthemeassist.svg?branch=master)](https://travis-ci.org/calligross/ggthemeassist)
[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/calligross)

**ggThemeAssist** is a RStudio-Addin that provides a GUI for editing [`ggplot2`](https://github.com/hadley/ggplot2) themes. 

Installation
------------

Please be aware that you need the **most recent (stable) release of RStudio** (v1.2 or later). Additionally, **ggThemeAssist** depends on [`shiny`](https://github.com/rstudio/shiny) and [`ggplot2`](https://github.com/tidyverse/ggplot2).

#### Install from Github
You can install the latest version of **ggThemeAssist** from Github using the [`remotes`](https://github.com/r-lib/remotes) package:
```r
if (!requireNamespace("remotes", quietly = TRUE))
  install.packages("remotes")

remotes::install_github("calligross/ggthemeassist")
```

Usage
------------
After installing, **ggThemeAssist** is available in the Addins menu within RStudio.

To edit `ggplot2` themes, just highlight a `ggplot2` object in your current script and run the Addin from the Addins menu. **ggplot2** will analyze your current plot, update its defaults to your current specification and give you a preview. Use the input widgets to get your ideas into shape. After terminating **ggThemeAssist** a character string containing your desired changes in standard `ggplot2` notation is inserted in your script. Re-running your script now produces the plot you just configured using **ggThemeAssist**.

[Click to enlarge](https://raw.githubusercontent.com/calligross/ggthemeassist/master/examples/ggThemeAssist2.gif)

![Screenshot](examples/ggThemeAssist2.gif)

