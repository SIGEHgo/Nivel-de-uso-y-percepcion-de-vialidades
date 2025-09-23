infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes.tif")

proyeccion = raster::raster("../../Importantes_documentos_usar/Accesibilidad/carreteras.tif")
proyeccion = terra::rast(proyeccion)

#infre = raster::resample(infraestructura, viajes, method = "bilinear")

infre = raster::disaggregate(x = infraestructura, fact = 3)
infraestructura = terra::rast(infre)
viajes = terra::rast(viajes)

plot(infre)
plot(viajes)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA


terra::crs(correlacion)
terra::crs(proyeccion)

library(leaflet)
leaflet() |> addTiles() |> addRasterImage(correlacion,opacity = 0.7)

terra::writeRaster(correlacion, "correlacion_infraestructura_con_numero_de_viajes.tif", filetype = "GTiff", overwrite = TRUE)













######################
infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes.tif")

proyeccion = raster::raster("../../Importantes_documentos_usar/Accesibilidad/carreteras.tif")
proyeccion = terra::rast(proyeccion)

#infre = raster::resample(infraestructura, viajes, method = "bilinear")

infre = raster::disaggregate(x = infraestructura, fact = 3)
infraestructura = terra::rast(infre)
viajes = terra::rast(viajes)
viajes[is.na(viajes)] = -1


correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes)
terra::plot(correlacion)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA


terra::crs(correlacion)
terra::crs(proyeccion)

library(leaflet)
leaflet() |> addTiles() |> addRasterImage(correlacion,opacity = 0.7)

terra::writeRaster(correlacion, "correlacion_infraestructura_con_numero_de_viajes_con_menos1.tif", filetype = "GTiff", overwrite = TRUE)


