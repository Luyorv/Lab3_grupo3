#Pregunta 1.1

#Instalacioon de librerias 
install.packages("readr")
library(readr)
library(stringr)
library(data.table)
library(tidyr)
library(dplyr)
library(lubridate)

#Carga de CSV 
epa_http <- read.table(file = "../../proyecto/Lab3_grupo3/epa-http.csv", sep = " ", quote = '"', fill = TRUE)
colnames(epa_http) <-c("host", "timestamp", "request", "status", "bytes")

#limpieza de datos
epa_http$timestamp <- as.POSIXct(epa_http$timestamp, format="[%d:%H:%M:%S]", tz="UTC")

#parceo de datos
epa_http$bytes <- readr::parse_number(epa_http$bytes, na = c("-", "NA"), locale = default_locale(), trim_ws = TRUE)
epa_http <- tidyr::separate(epa_http, request, c("tipo", "url", "protocolo"), sep = " ")

#Agrupacion de Usuarios con Error
errores_serv <- dplyr::select(epa_http, status, host)
colnames(errores_serv) <- c('codigo', 'host')
errores_serv <- errores_serv %>% group_by(host, codigo) %>% mutate(codigo) %>% summarise(n = n())
#Identificar Usuarios sin Error y con Error
sin_error <- dplyr::filter(errores_serv, between (codigo,100,399))
colnames (sin_error) <- c('host', 'codigo', 'conteo')
con_error <- dplyr::filter(errores_serv, between (codigo,400,999))
colnames (con_error) <- c('host', 'codigo', 'conteo')
errores_serv_resumen <- con_error %>% group_by(codigo) %>% mutate(codigo) %>% summarise(n = n())
colnames(errores_serv_resumen) <- c('codigo', 'Conteo')