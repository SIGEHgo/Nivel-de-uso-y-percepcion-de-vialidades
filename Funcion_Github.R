imagenes_git <- function(owner = "Eduardo-Alanis-Garcia", 
                         repo = "R_Leaflet", 
                         branch = "main", 
                         folder = "Img/Municipios", 
                         exts = c(".png")) {
  
  library(httr)
  library(jsonlite)
  library(dplyr)
  library(stringr)
  
  url = paste0("https://api.github.com/repos/", owner, "/", repo, "/git/trees/", branch, "?recursive=1")
  
  # Realizar la solicitud a la API
  resp = GET(url)
  stop_for_status(resp)
  data = content(resp, as = "text", encoding = "UTF-8")
  json = fromJSON(data)
  
  # Filtrar archivos que son imágenes dentro de la carpeta deseada
  files = json$tree[json$tree$type == "blob", "path"]
  images = files[
    grepl(paste0("^", folder), files) & 
      sapply(files, function(f) any(endsWith(tolower(f), exts)))
  ]
  
  # Construir URLs RAW
  links = paste0("https://raw.githubusercontent.com/", owner, "/", repo, "/", branch, "/", images)
  
  # Crear dataframe
  git <- data.frame(links = links) |> 
    mutate(nombre_principal = basename(links) |>  
             gsub(pattern = "\\.png$", replacement = "") |>  
             str_squish())
  
  return(git)
}
