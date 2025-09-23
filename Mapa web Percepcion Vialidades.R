proyeccion = raster::raster("../../Importantes_documentos_usar/Accesibilidad/carreteras.tif")
proyeccion = terra::rast(proyeccion)

infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes.tif")
correlacion = raster::raster("correlacion_infraestructura_con_numero_de_viajes.tif")
correlacion_dos = raster::raster("correlacion_infraestructura_con_numero_de_viajes_con_menos1.tif")

infraestructura = raster::disaggregate(x = infraestructura, fact = 3)


infraestructura = raster::projectRaster(infraestructura, crs = raster::crs(proyeccion))
viajes = raster::projectRaster(viajes, crs = raster::crs(proyeccion))
correlacion = raster::projectRaster(correlacion, crs = raster::crs(proyeccion))
correlacion_dos = raster::projectRaster(correlacion_dos, crs = raster::crs(proyeccion))

library(leaflet)
leaflet() |> addTiles() |> addRasterImage(infraestructura,opacity = 0.7)


mapa = leaflet() |> 
  addTiles() |> 
  addRasterImage(infraestructura, opacity = 0.7, group = "Percepción infraestructuravial") |> 
  addRasterImage(viajes, opacity = 0.7, group = "Nivel de uso por numero de viaje") |> 
  addRasterImage(correlacion, opacity = 0.7, group = "Correlación Rasters") |> 
  addRasterImage(correlacion_dos, opacity = 0.7, group = "Correlación Rasters Modificado") |> 
  addLayersControl(
    baseGroups = c("Percepción infraestructuravial", "Nivel de uso por numero de viaje", "Correlación Rasters", "Correlación Rasters Modificado"),
    options = layersControlOptions(collapsed = FALSE)
  ) |> 
  hideGroup(c("Nivel de uso por numero de viaje", "Correlación Rasters", "Correlación Rasters Modificado"))

mapa


htmlwidgets::saveWidget(mapa, "Mapa_web_Vialidades_Raster.html",selfcontained = T, title = "Vialidades")
