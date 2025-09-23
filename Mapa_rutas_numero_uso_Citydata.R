library(leaflet)

datos = sf::read_sf("Datos/rutas_con_numero_de_usos_citydata.geojson")
datos = sf::st_transform(x = datos, crs = 32614)
datos = datos |> 
  dplyr::mutate(distancias = sf::st_length(x = geometry)) |> 
  dplyr::relocate(distancias, .after = num_registros) |> 
  dplyr::mutate(num_reg_x_metro = num_registros/distancias) |> 
  dplyr::relocate(num_reg_x_metro, .after = distancias) |> 
  dplyr::mutate(distancias = distancias |>  as.character() |>  as.numeric(),
                num_reg_x_metro = num_reg_x_metro |> as.character() |>  as.numeric())

datos = sf::st_transform(x = datos, crs = 4326)


datos = datos |> 
  dplyr::filter(!sf::st_is_empty(geometry))


paleta_registro = colorNumeric(palette = "YlOrRd", domain = c(min(datos$num_registros), max(datos$num_registros)))
paleta_numr_m = colorNumeric(palette = "YlOrRd", domain = c(min(datos$num_reg_x_metro), max(datos$num_reg_x_metro)))

mapa = leaflet() |> 
  addTiles(options = tileOptions(opacity = 0.6)) |> 
  setView(lng = -98.92, lat = 20.47, zoom = 8)  |> 
  addPolylines(data = datos, color = paleta_registro(x = datos$num_registros), weight = 2, opacity = 0.8, 
               label = paste0("Nombre: ", "<b>", datos$name, "</b>", "<br>", 
                              "Registros: ", "<b>", datos$num_registros, "</b>", "<br>", 
                              "Longitud: ", "<b>", round(x = datos$distancias, digits = 2), " m","</b>") |> 
                 lapply(FUN = function(x) { htmltools::HTML(x)}),
               group = "Registros") |> 
  addPolylines(data = datos, color = paleta_numr_m(x = datos$num_reg_x_metro), weight = 2, opacity = 0.8, 
               label = paste0("Nombre: ", "<b>", datos$name, "</b>", "<br>", 
                              "Registros por metro: ", "<b>", round(x = datos$num_reg_x_metro, digits = 4), "</b>", "<br>", 
                              "Longitud: ", "<b>", round(x = datos$distancias, digits = 2), " m","</b>") |> 
                 lapply(FUN = function(x) { htmltools::HTML(x)}),
               group = "Registros por metro") |> 
  addLayersControl(
    baseGroups = c("Registros", "Registros por metro"),
    options = layersControlOptions(collapsed = FALSE)
  ) |> 
  hideGroup(c("Registros por metro"))
  
  
mapa




htmlwidgets::saveWidget(mapa, "Rutas_numero_uso_Citydata.html", selfcontained = T, title = "Rutas numero de uso Citydata")
