


##Paquete para chequear acceso para scrapear de páginas web
##robotstxt
##Documentación: https://github.com/ropensci/robotstxt
##

##ejemplo:
library(robotstxt)
options(robotstxt_warn = FALSE)
paths_allowed(
  paths = c(
    "https://tiendainglesa.com.uy", 
    "https://tiendainglesa.com.uy"
  )
)

##Identificación de BOTS en Twitter: tweetbotornot2
##creo que con los cambios en rtweet da error

remotes::install_github("mkearney/tweetbotornot2")
library(tweetbotornot2)
# función predict_bot()



##Twitter auth
library(rtweet)
#rtweet::create_token()


