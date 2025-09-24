proyeccion = raster::raster("Datos/carreteras.tif")

infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes.tif")
correlacion = raster::raster("Datos/correlacion_infraestructura_con_numero_de_viajes.tif")
correlacion_dos = raster::raster("Datos/correlacion_infraestructura_con_numero_de_viajes_con_menos1.tif")

infraestructura[infraestructura <  1e-3] = NA

raster::plot(infraestructura)
raster::plot(viajes)
raster::plot(correlacion)
raster::plot(correlacion_dos)

infraestructura = raster::disaggregate(x = infraestructura, fact = 3)



infraestructura = raster::projectRaster(infraestructura, crs = raster::crs(proyeccion)) 
viajes = raster::projectRaster(viajes, crs = raster::crs(proyeccion))
correlacion = raster::projectRaster(correlacion, crs = raster::crs(proyeccion))
correlacion_dos = raster::projectRaster(correlacion_dos, crs = raster::crs(proyeccion))





### Municipio 

source("Funcion_Github.R")
mun = sf::read_sf("../../Importantes_documentos_usar/Municipios/municipiosjair.shp")
git = imagenes_git()

mun = mun |> 
  dplyr::select(CVEGEO, NOM_MUN) |> 
  dplyr::left_join(y = git, by = c("NOM_MUN" = "nombre_principal")) |> 
  relocate(links, .after = NOM_MUN)

### Paletas de colores

paleta_infraestructura = leaflet::colorNumeric(palette = "Spectral", domain = raster::values(infraestructura), na.color = "transparent")
paleta_viajes = leaflet::colorNumeric(palette = "RdYlGn", domain = raster::values(viajes), na.color = "transparent")
paleta_correlacion = leaflet::colorNumeric(palette = "YlOrRd", domain = raster::values(correlacion), na.color = "transparent")
paleta_correlacion_dos = leaflet::colorNumeric(palette = "YlOrRd", domain = raster::values(correlacion_dos), na.color = "transparent")



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
  addRasterImage(infraestructura, opacity = 0.7, group = "Percepción infraestructuravial") |> 
  addLegend(pal = paleta_infraestructura, values = raster::values(infraestructura), title = "Percepción infraestructuravial", position = "bottomright", group = "Percepción infraestructuravial") |> 
  addRasterImage(viajes, opacity = 0.7, group = "Nivel de uso por numero de viaje") |> 
  addLegend(pal = paleta_viajes, values = raster::values(viajes), title = "Nivel de uso por numero de viaje", position = "bottomright", group = "Nivel de uso por numero de viaje") |> 
  addRasterImage(correlacion, opacity = 0.7, group = "Correlación Rasters") |> 
  addLegend(pal = paleta_correlacion, values = raster::values(correlacion), title = "Correlación Rasters", position = "bottomright", group = "Correlación Rasters") |> 
  addRasterImage(correlacion_dos, opacity = 0.7, group = "Correlación Rasters Modificado") |> 
  addLegend(pal = paleta_correlacion_dos, values = raster::values(correlacion_dos), title = "Correlación Rasters Modificado", position = "bottomright", group = "Correlación Rasters Modificado") |> 
  addLayersControl(
    overlayGroups = c("Percepción infraestructuravial", "Nivel de uso por numero de viaje", "Correlación Rasters", "Correlación Rasters Modificado"),
    options = layersControlOptions(collapsed = FALSE)
  ) |> 
  hideGroup(c("Nivel de uso por numero de viaje", "Correlación Rasters", "Correlación Rasters Modificado")) |> 

mapa


htmlwidgets::saveWidget(mapa, "Mapa_web_Vialidades_Raster.html",selfcontained = T, title = "Vialidades")
