correlacion_pearson_3 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_3_pearson.tif")
correlacion_pearson_5 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_5_pearson.tif")
correlacion_pearson_7 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_7_pearson.tif")

correlacion_spearman_3 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_3_spearman.tif")
correlacion_spearman_5 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_5_spearman.tif")
correlacion_spearman_7 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_7_spearman.tif")


### Municipio 
source("Funcion_Github.R")
mun = sf::read_sf("../../Importantes_documentos_usar/Municipios/municipiosjair.shp")
git = imagenes_git()

mun = mun |> 
  dplyr::select(CVEGEO, NOM_MUN) |> 
  dplyr::left_join(y = git, by = c("NOM_MUN" = "nombre_principal")) |> 
  relocate(links, .after = NOM_MUN)

### Paletas de colores
paleta_correlacion = leaflet::colorNumeric(palette = "YlOrRd", domain = raster::values(correlacion_pearson_3), na.color = "transparent")



library(leaflet)
mapa = leaflet() |> 
  addTiles() |> 
  addPolygons(data = mun, 
              label = paste0(
                "<div style='display:flex; align-items:center;'>",
                "<img src='", mun$links, "' style='width:auto; height:30px; margin-right:5px;'>",
                "<span>", "<b>", mun$NOM_MUN, "</b>", "</span>",
                "</div>"
              ) |> lapply(FUN =  function(x){htmltools::HTML(x)}),
              color = "black",
              fillColor = "black",
              fillOpacity = 0.01,
              weight = 1
  ) |> 
  addRasterImage(correlacion_pearson_3, opacity = 0.7, group = "Pearson 3") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_pearson_3), title = "Pearson 3", position = "bottomright", group = "Pearson 3") |>
  addRasterImage(correlacion_pearson_5, opacity = 0.7, group = "Pearson 5") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_pearson_5), title = "Pearson 5", position = "bottomright", group = "Pearson 5") |>
  addRasterImage(correlacion_pearson_7, opacity = 0.7, group = "Pearson 7") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_pearson_7), title = "Pearson 7", position = "bottomright", group = "Pearson 7") |>
  addRasterImage(correlacion_spearman_3, opacity = 0.7, group = "Spearman 3") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_spearman_3), title = "Spearman 3", position = "bottomright", group = "Spearman 3") |>
  addRasterImage(correlacion_spearman_5, opacity = 0.7, group = "Spearman 5") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_spearman_5), title = "Spearman 5", position = "bottomright", group = "Spearman 5") |>
  addRasterImage(correlacion_spearman_7, opacity = 0.7, group = "Spearman 7") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion_spearman_7), title = "Spearman 7", position = "bottomright", group = "Spearman 7") |>
  addLayersControl(
    overlayGroups = c("Pearson 3", "Pearson 5", "Pearson 7", "Spearman 3", "Spearman 5", "Spearman 7"),
    options = layersControlOptions(collapsed = FALSE)
  ) |> 
  hideGroup(c("Pearson 5", "Pearson 7", "Spearman 3", "Spearman 5", "Spearman 7"))  

mapa

htmlwidgets::saveWidget(mapa, "Mapa_web_Correlaciones.html",selfcontained = T, title = "Correlaciones")

