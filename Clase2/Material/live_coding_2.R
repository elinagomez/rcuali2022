


# Fuentes de datos

##1. Recuperación de documentos en imagen o pdf (OCR) 


## Cargamos la librería necesaria:
library(readtext)
##Abro los textos en formato .txt y visualizo cómo los carga
txt <- readtext::readtext("Clase2/Material/Mujeres_Adultos_1.txt")
# Determinamos el pdf con el que trabajar
pdf <- readtext("Clase2/Material/text.pdf")
url <- readtext("https://www.ingenieria.unam.mx/dcsyhfi/material_didactico/Literatura_Hispanoamericana_Contemporanea/Autores_B/BENEDETTI/Poemas.pdf")


#pdftools

library(pdftools)
# Extraemos el texto
pdf_texto <- pdf_text("Clase2/Material/marcha_1973.pdf")


write.csv(pdf_texto,"Clase2/Material/pdf_texto.csv")


##Reconocimiento óptico de caracteres en imagenes

library(tesseract)
##Chequear los idiomas disponibles 
tesseract_info()
# Bajar por unicamente español para entrenar
tesseract_download("spa")
# asignar
espanol <- tesseract("spa")
#Probamos:
transcribopdf <- ocr("Clase2/Material/analesUruguay.pdf",engine = espanol)


# Ejercicio 

#- Replicar el OCR para la imagen _analesUruguay_3_

#- Hacer las tablas de ambas





## Web scraping

library(rvest)
library(dplyr)

#Defino mi sitio html: Montevideo portal


mvdportal = rvest::read_html("https://www.montevideo.com.uy/index.html") 

resumenes = mvdportal %>%
  html_elements(".text")%>% #defino el elemento que identifiqué con el SelectorGadget 
  html_text()%>%
  as.data.frame()

write.csv(resumenes,"C:/Users/Usuario/Documents/rcuali_2021/Clase2/Material/resumenes.csv")

titulares = mvdportal %>%
  html_elements("a")%>%
  html_text()%>%
  as.data.frame()

write.csv(titulares,"C:/Users/Usuario/Documents/rcuali_2021/Clase2/Material/titulares.csv")

url <- 'https://en.wikipedia.org/wiki/R_(programming_language)'

url %>% read_html() %>% 
  html_elements(css = '.wikitable') %>% 
  html_table() 


# Ejercicio 

#- Probar descargar titulares de otra web



##Scrapeo parlamentario

##Instalar PUY 
##remotes::install_github("Nicolas-Schmidt/puy")


##Speech - ejemplo

url = "https://parlamento.gub.uy/documentosyleyes/documentos/diario-de-sesion/senadores/6280/IMG/0?width=800&height=600&hl=en_US1&iframe=true&rel=nofollow"


library(speech)
#url <- "http://bit.ly/35AUVF4"
sesion <- speech_build(file = url,compiler = T)


library(puy)
sesion = puy::add_party(sesion)


# Ejercicio 

#- Elegir una sesión parlamentaria, aplicar el OCR, agregar etiqueta partidaria y guardar en formato tabulado 



#gdeltr2

#Instalación
# devtools::install_github("hafen/trelliscopejs")
# devtools::install_github("abresler/gdeltr2")

library(gdeltr2)

##ver paises dominios

loc = gdeltr2::dictionary_country_domains()



##mode:"ArtList" (listado de artículos)

articulos  = gdeltr2::ft_v2_api(
  terms = c("lacalle pou"),
  modes = c("ArtList"),
  visualize_results = F,
  timespans = "55 days",
  source_countries = "UY"
) 

articulos_comb  = gdeltr2::ft_v2_api(
  terms = c('"Lacalle Pou" covid'),
  modes = c("ArtList"),
  visualize_results = F,
  timespans = "55 days",
  source_countries = "UY")



##mode:"TimelineVol" o "TimelineVolInfo"

intensidad = gdeltr2::ft_v2_api(
  terms = c("lacalle pou"),
  modes = c("TimelineVol"),
  visualize_results = F,
  timespans = "55 days",
  source_countries = "UY"
) 

intensidad_info = gdeltr2::ft_v2_api(
  terms = c("Lacalle Pou"),
  modes = c("TimelineVolInfo"),
  visualize_results = F,
  timespans = "55 days",
  source_countries = "UY"
) 

##mode:"TimelineTone" 

tono_diario = gdeltr2::ft_v2_api(
  terms = c("Lacalle Pou"),
  modes = c("TimelineTone"),
  visualize_results = F,
  timespans = "30 days",
  source_countries = "UY"
) 

##mode:"ToneChart" 

tonos = gdeltr2::ft_v2_api(
  terms = c("Lacalle Pou"),
  modes = c("ToneChart"),
  visualize_results = F,
  timespans = "30 days",
  source_countries = "UY"
) 



##Indicadores de inestabilidad


inestabilidad_zona <-
  gdeltr2::instability_api_locations(
    location_ids = c("UY"),
    use_multi_locations = c(T, F),
    variable_names = c('instability', 'tone', 'protest', 'conflict','artvolnorm'),
    time_periods = c('daily'),
    nest_data = F,
    days_moving_average = NA,
    return_wide = T,
    return_message = T,
    visualize = T
  )


##busqueda por temas

##recupero códigos
df_gkg <-
  gdeltr2::dictionary_ft_codebook(code_book = "gkg")


tema =  ft_v2_api(gkg_themes = "WB_2901_GENDER_BASED_VIOLENCE",modes = c("Artlist"),
                  visualize_results = F,
                  timespans = "55 days")




# Ejercicio 

#- Aplicar dos de las funciones vistas sobre un tema diferente  

##gtrendsR 


library(gtrendsR)
library(ggplot2)
library(ggrepel)
library(tmap)

query=gtrends(keyword = c("mundial"),time = "today+5-y",geo = "UY")


##Análisis de evolución de búsquedas por keyword

mundial <- query$interest_over_time
mundial %>% 
  ggplot(aes(x = date,
             y = hits,group=keyword,
             color = keyword))  +
  theme_bw()+
  labs(title = "Búsquedas en Google sobre 'mundial' desde 2018",
       x= NULL, y = "Interest")+
  theme(legend.position = "none") +
  geom_point(size=1,color="black")+
  geom_line(size=1,color="black")

#Análisis de búsquedas más relacionadas con keyword

query$related_queries %>%
  filter(related_queries=="top") %>%
  mutate(value=factor(value,levels=rev(as.character(value))),
         subject=as.numeric(subject)) %>%
  top_n(20,value) %>%
  ggplot(aes(x=value,y=subject,fill="red")) + 
  geom_bar(stat='identity',show.legend = F) + 
  coord_flip() + labs(title="Búsquedas más relacionadas con 'mundial' desde 2018")



#Comparación de búsquedas en período de tiempo determinado para todos los países


query=gtrends(keyword = c("mundial"),time = "now 1-d")

paises=query$interest_by_country
paises$hits=as.numeric(paises$hits)



paisescoord <- spData::world %>%
  left_join(y=paises,by = c("name_long" = "location"),keep=T)


mapa=tm_shape(paisescoord) +
  tm_fill("hits",
          title = "Búsquedas por países",
          legend.reverse = T,
          id = "name_long")




# Ejercicio 

#- Realizar alguna visualización sobre un tema específico.   



