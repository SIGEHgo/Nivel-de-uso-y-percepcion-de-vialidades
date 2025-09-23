library(leaflet)

datos = sf::read_sf("C:/Users/SIGEH/Downloads/rutas_con_numero_de_usos_citydata.geojson")

paleta = colorNumeric(palette = "YlOrRd", domain = c(min(datos$num_registros), max(datos$num_registros)))


mapa = leaflet() |> 
  addTiles() |> 
  setView(lng = -98.92, lat = 20.47, zoom = 8)  
mapa


mapa = leaflet() |> 
  addTiles() |> 
  setView(lng = -98.92, lat = 20.47, zoom = 8)  |> 
  addPolylines(data = datos, color = paleta(x = datos$num_registros), weight = 2, opacity = 0.8, 
               label = paste0("Nombre: ", "<b>", datos$name, "</b>", "<br>", 
                              "Registros: ", "<b>", datos$num_registros, "</b>") |> 
                 lapply(FUN = function(x) { htmltools::HTML(x)}))
mapa

for (i in 1:1000) {
  df = datos[i,]
  coor = sf::st_coordinates(x = df) |>  as.data.frame()
  
  mapa = mapa |> 
    addPolylines(
      data = df,
      color = paleta(df$num_registros),
      weight = 2, 
      opacity = 0.8,
      label = df$name
    )
}


paste("Municipio:", "<b>", ice_2015$NOM_MUN ,"</b>", "<br>", "Indice de Complejidad: ",  "<b>" , round(ice_2015$ICE_Personal_2015., digits = 2) ,"</b>", "<br>", "Ranking:", "<b>", ice_2015$ranking ,"</b>") |> lapply(FUN = function(x) { htmltools::HTML(x)})

mapa
