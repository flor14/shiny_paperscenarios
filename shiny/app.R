library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(rnaturalearth)
library(rnaturalearthdata)


# world map (to plot near countries as Uruguay)
  world <- ne_countries(scale = "medium", returnclass = "sf")

pampa_polygon <- st_read("data/pampa_polygon.shp")

ui <- fluidPage(
  
  titlePanel("PWC Scenarios"),
  sidebarLayout(
    sidebarPanel(
     selectInput("polygon", "Polygon",
                         choices = unique(pampa_polygon$id_uc_gid),
                         selected = "A329_49", multiple = TRUE)
      
    ),
    
    # Show Leaflet
    mainPanel(
     leafletOutput("pampaPlot", width = "100%")
    )
  )
)

# Define server logic
server <- function(input, output){
  
 
  # world map (to plot near countries as Uruguay)
  world <- ne_countries(scale = "medium", returnclass = "sf")
  
    
  pampa_select <- reactive({
    
    pampa_polygon %>% filter(id_uc_gid %in% input$polygon)
    
  })
  
  
  output$pampaPlot <- renderLeaflet({ 
    
    leaflet() %>%
      addPolygons(data = world,
                  color = "#444444",
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 0.5,
                  highlightOptions = highlightOptions(color = "blue", 
                                                      weight = 2)) %>% 
      addPolygons(data= pampa_polygon,
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 0.5,
                  highlightOptions = highlightOptions(color = "white", 
                                                      weight = 2,
                                                      bringToFront = TRUE)) %>%
      addPolygons(data= pampa_select(),
                  color = "pink", 
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 1,
                  highlightOptions = highlightOptions(color = "red", 
                                                      weight = 2,
                                                      bringToFront = TRUE)) %>%
      fitBounds( -66,-30, -56, -40) 
  })
 }

# Run the application 
shinyApp(ui = ui, server = server)

