#Pregunta 1.1

#Instalacioon de librerias 
install.packages("readr")
library(readr)
library(stringr)
library(data.table)

#Carga de CSV 
epa_http <- read.table(file = "../Downloads/Lab3_grupo3/epa-http.csv", sep = " ", quote = '"', fill = TRUE)
colnames(epa_http) <-c("host", "timestamp", "request", "status", "bytes")

#limpieza de datos
epa_http$timestamp <- as.POSIXct(epa_http$timestamp, format="[%d:%H:%M:%S]", tz="UTC")

#parceo de datos
epa_http$bytes <- readr::parse_number(epa_http$bytes, na = c("-", "NA"), locale = default_locale(), trim_ws = TRUE)
epa_http <- tidyr::separate(epa_http, request, c("tipo", "url", "protocolo"), sep = " ")

