proyeccion = terra::rast("Datos/carreteras_solo_proyeccion.tif")
terra::crs(proyeccion)

municipios = sf::read_sf("../../Importantes_documentos_usar/Municipios/municipiosjair.shp")
nivel_de_uso = sf::st_read("Datos/rutas_con_numero_de_usos_citydata.geojson") |> 
  sf::st_transform(crs = 32614) |>  sf::st_buffer(dist = 500) |>  sf::st_transform(crs = sf::st_crs(municipios))


library(terra)
base = terra::rast("Datos/raster_base.tif")

nivel_de_uso = nivel_de_uso |>  sf::st_transform(terra::crs(proyeccion))
nivel_de_uso = terra::rasterize(terra::vect(nivel_de_uso), base, field = "num_registros", fun = "sum")

municipios = municipios |>  sf::st_transform(crs = terra::crs(base))
nivel_de_uso = mask(nivel_de_uso, municipios)
nivel_de_uso = terra::project(nivel_de_uso, terra::crs(proyeccion))

leaflet() |> addTiles() |> addRasterImage(nivel_de_uso)

terra::plot(nivel_de_uso)

nivel_de_uso|> writeRaster("Datos/nivel_de_uso_proxy_de_numero_de_viajes_500.tif",overwrite=T)
