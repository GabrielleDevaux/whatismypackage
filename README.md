# whatismypackage
Little game to check your knowledge about R packages, made with R Shiny. The main purpose of this app is fun, and train Shiny / R / Golem skills


# Try the demo
The app is available on [shinyapps.io](https://gabrielledevaux.shinyapps.io/whatismypackage/).


# Installation

Install from GitHub
```
devtools::install_github("GabrielleDevaux/whatismypackage")
```

## Getting Started

Launch the app locally.
```
library(whatismypackage)
whatismypackage::run_app('local)
```
Launch the app with an Ethercalc Room to share the scores. This solution was developped to have persistent data when the app is deployed on shinyapp.io.
```
library(whatismypackage)
whatismypackage::run_app("shinyappsio",  ec_host = "https://ethercalc.org", ec_room = ****************)
```


## Acknowledgments

* The package structure was made with the package [Golem](https://github.com/ThinkR-open/golem) developed by ThinkR
* Some elements of the app were inspired by Victor Perrier's [Memory hex](https://github.com/dreamRs/memory-hex) game
* The score sharing tool is [Ethercalc](https://github.com/audreyt/ethercalc)
* The R package to access Ethercalc API was developped by [Bob Rudis](https://github.com/hrbrmstr/ethercalc)


