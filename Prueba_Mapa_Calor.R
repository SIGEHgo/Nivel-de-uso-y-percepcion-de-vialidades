puntos = matrix(data = c(-98.73740880850079, 20.122586597431404, -98.74580291920297, 20.1164801910504), ncol = 2, byrow = T)
linea = sf::st_linestring(x = puntos) |>  sf::st_sfc(crs = 4326)
linea = sf::st_transform(x = linea, crs = 32614)

distancia = sf::st_length(x = linea)
particion = seq(0, 1, by = 1/as.numeric(distancia)) # Por cada metro

puntos_particion = sf::st_line_sample(x = linea, sample = particion) |>  sf::st_cast(to = "POINT")
puntos_particion = sf::st_transform(x = puntos_particion, crs = 4326)





datos = sf::read_sf("C:/Users/SIGEH/Downloads/rutas_con_numero_de_usos_citydata.geojson")


expansion = NULL
for (i in 1:nrow(datos)) {
  cat("Vamos en la fila ", i, "\n")
  linea_original = datos[i,]
  nombre = linea_original$name
  registros = linea_original$num_registros
  linea = sf::st_transform(x = sf::st_cast(x = linea_original, to = "LINESTRING"), crs = 32614)
  linea = sf::st_line_sample(x = linea, density = 1/10) |>  sf::st_cast(to = "POINT") |>  sf::st_transform(crs = 4326)
  coordenadas = sf::st_coordinates(linea) |>  as.data.frame()
  coordenadas = coordenadas |> 
    dplyr::mutate(NOMBRE = nombre,
                  REGISTROS = registros)
  
  expansion = dplyr::bind_rows(expansion, coordenadas)
  
}


expacion_datos = expansion

df = expansion
df = df |> 
  dplyr::filter(!is.na(X), !is.na(Y))

df = sf::st_as_sf(x = df,  coords = c("X", "Y"), crs = 4326)

df = df |> 
  dplyr::mutate(id = 1:nrow(df))
mun = sf::read_sf("C:/Users/SIGEH/Desktop/Lalo/Gob/Importantes_documentos_usar/Municipios/municipiosjair.shp")
tiza = mun[which("13069" == mun$CVEGEO),]

p = sf::st_join(x = df, y = tiza, join = sf::st_within)
p = p |>  dplyr::filter(!is.na(CVE_ENT))


filtracion = df[df$id %in% p$id,]



mapa = leaflet() |> 
  addTiles() |> 
  addHeatmap(data = filtracion, radius = 5, intensity = filtracion$REGISTROS )
mapa

