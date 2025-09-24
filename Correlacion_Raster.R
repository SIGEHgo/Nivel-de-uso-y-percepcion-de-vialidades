infraestructura = raster::raster("Datos/j_Percepción_infraestructura_vial.tif")
viajes = raster::raster("Datos/nivel_de_uso_proxy_de_numero_de_viajes_500.tif")

proyeccion = raster::raster("../../Importantes_documentos_usar/Accesibilidad/carreteras.tif") |>  terra::rast()

infraestructura = raster::disaggregate(x = infraestructura, fact = 3) |> terra::rast()
viajes = terra::rast(viajes)

infraestructura = terra::mask(x = infraestructura, mask = viajes)
viajes = terra::mask(x = viajes, mask = infraestructura)

terra::plot(infraestructura)
terra::plot(viajes)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 3)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA


terra::crs(correlacion)
terra::crs(proyeccion)

library(leaflet)
leaflet() |> addTiles() |> addRasterImage(correlacion,opacity = 0.7)

terra::writeRaster(correlacion, "correlacion_infraestructura_con_numero_de_viajes_.tif", filetype = "GTiff", overwrite = TRUE)












correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 3)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_3_pearson.tif", filetype = "GTiff", overwrite = TRUE)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 5)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_5_pearson.tif", filetype = "GTiff", overwrite = TRUE)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 7)
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_7_pearson.tif", filetype = "GTiff", overwrite = TRUE)


correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 3, type = "spearman")
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_3_spearman.tif", filetype = "GTiff", overwrite = TRUE)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 5, type = "spearman")
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_5_spearman.tif", filetype = "GTiff", overwrite = TRUE)

correlacion = spatialEco::rasterCorrelation(x = infraestructura, y = viajes, s = 7, type = "spearman")
correlacion = terra::project(x = correlacion, terra::crs(proyeccion))
correlacion[correlacion < -1 | correlacion > 1] = NA
terra::writeRaster(correlacion, "Datos/Correlaciones/correlacion_infraestructura_con_numero_de_viajes_7_spearman.tif", filetype = "GTiff", overwrite = TRUE)




































































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


