###
proyeccion = raster::raster("Datos/carreteras_solo_proyeccion.tif")
infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes.tif")

infraestructura[abs(infraestructura) <  1e-3] = NA

infraestructura = raster::disaggregate(x = infraestructura, fact = 3)

infraestructura = raster::projectRaster(infraestructura, crs = raster::crs(proyeccion)) 
viajes = raster::projectRaster(viajes, crs = raster::crs(proyeccion))

### Correlacion
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

paleta_correlacion = leaflet::colorNumeric(
  palette = "Spectral", 
  domain = , seq(-1, 1, 0.001),
  na.color = "transparent",
  reverse = T
)

paleta_infraestructura = leaflet::colorNumeric(palette = "Spectral", 
                                               domain = raster::values(infraestructura), 
                                               na.color = "transparent", reverse = T)

paleta_viajes = leaflet::colorNumeric(palette = "Spectral", 
                                      domain = raster::values(viajes), 
                                      na.color = "transparent", reverse = T)


library(leaflet)
library(leaflegend)

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
  addRasterImage(infraestructura, opacity = 0.7, group = "Percepción infraestructuravial", colors = paleta_infraestructura) |> 
  addLegendNumeric(
    pal = paleta_infraestructura, 
    values = raster::values(infraestructura)[!is.na(raster::values(infraestructura))],  
    title = "Percepción infraestructuravial", position = "bottomright", group = "Percepción infraestructuravial",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 200,
    labels = c(raster::minValue(infraestructura) |> round(digits = 2), raster::maxValue(infraestructura) |> round(digits = 2)), tickLength = 0
  )  |> 
  addRasterImage(viajes, opacity = 0.7, group = "Nivel de uso por numero de viaje", colors = paleta_viajes) |> 
  addLegendNumeric(
    pal = paleta_viajes, 
    values = raster::values(viajes)[!is.na(raster::values(viajes))],  
    title = "Nivel de uso por numero de viaje", position = "bottomright", group = "Nivel de uso por numero de viaje",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 250,
    labels = c(raster::minValue(viajes) |> round(digits = 2), raster::maxValue(viajes) |> round(digits = 2)), tickLength = 0
  ) |> 
  
  addRasterImage(correlacion_pearson_3, opacity = 0.7, group = "Pearson 3", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_pearson_3)[!is.na(raster::values(correlacion_pearson_3))],  
    title = "Pearson 3", position = "bottomright", group = "Pearson 3",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 

  addRasterImage(correlacion_pearson_5, opacity = 0.7, group = "Pearson 5", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_pearson_5)[!is.na(raster::values(correlacion_pearson_5))],  
    title = "Pearson 5", position = "bottomright", group = "Pearson 5",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 
  
  addRasterImage(correlacion_pearson_7, opacity = 0.7, group = "Pearson 7", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_pearson_7)[!is.na(raster::values(correlacion_pearson_7))],  
    title = "Pearson 7", position = "bottomright", group = "Pearson 7",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 
  
  addRasterImage(correlacion_spearman_3, opacity = 0.7, group = "Spearman 3", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_spearman_3)[!is.na(raster::values(correlacion_spearman_3))],  
    title = "Spearman 3", position = "bottomright", group = "Spearman 3",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 
  
  addRasterImage(correlacion_spearman_5, opacity = 0.7, group = "Spearman 5", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_spearman_5)[!is.na(raster::values(correlacion_spearman_5))],  
    title = "Spearman 5", position = "bottomright", group = "Spearman 5",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 
  
  addRasterImage(correlacion_spearman_7, opacity = 0.7, group = "Spearman 7", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_spearman_7)[!is.na(raster::values(correlacion_spearman_7))],  
    title = "Spearman 7", position = "bottomright", group = "Spearman 7",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  ) |> 
  
  addLayersControl(
    overlayGroups = c("Percepción infraestructuravial", "Nivel de uso por numero de viaje", "Pearson 3", "Pearson 5", "Pearson 7", "Spearman 3", "Spearman 5", "Spearman 7"),
    options = layersControlOptions(collapsed = FALSE)
  ) |> 
  hideGroup(c("Percepción infraestructuravial", "Nivel de uso por numero de viaje", "Pearson 3","Pearson 5", "Pearson 7", "Spearman 3", "Spearman 5", "Spearman 7"))  

mapa

htmlwidgets::saveWidget(mapa, "Mapa_web_Correlaciones.html", selfcontained = T, title = "Correlaciones")



























correlacion_pearson_3 = raster::raster("Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_3_pearson.tif")
paleta_correlacion = leaflet::colorNumeric(
  palette = "Spectral", 
  domain = , seq(-1,1,0.001),
  na.color = "transparent",
  reverse = T
)



library(leaflegend)


mapa = leaflet() |> 
  addTiles() |> 
  addRasterImage(correlacion_pearson_3, opacity = 0.7, group = "Pearson 3", colors = paleta_correlacion) |> 
  addLegendNumeric(
    pal = paleta_correlacion, 
    values = raster::values(correlacion_pearson_3)[!is.na(raster::values(correlacion_pearson_3))],  
    title = "Pearson 3", position = "bottomright", group = "Pearson 3",
    orientation = 'horizontal', shape = 'rect', decreasing = FALSE, height = 20, width = 100,
    labels = c("-1", "1"), tickLength = 0
  )

mapa
  
