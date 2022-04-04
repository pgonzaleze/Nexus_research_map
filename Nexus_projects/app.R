#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(pacman)
p_load("shiny", "shinydashboard", "leaflet",
       "tidyverse", "htmltools", "dplyr")

#load dataframe
nexus_df <- read.csv(file = 'Ocean_Nexus_Projects_list.csv', 
                     sep = ',', skip = 1)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel(p("Nippon Foundation Ocean Nexus Center at UW EarthLab -- Research Projects", style = "color:#3474A7")),
    mainPanel((
        leafletOutput(outputId = "map")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,server){
    output$map <- renderLeaflet({
        nexus_df%>%
            leaflet(options = leafletOptions(minZoom = 1)) %>%
            addProviderTiles(provider = "CartoDB")%>%
            setMaxBounds(lng1 = -179,
                         lat1 = -89,
                         lng2 = 179,
                         lat2 = 89) %>%
            addProviderTiles(provider = "CartoDB")%>%
            addCircleMarkers(lng = jitter(nexus_df$lon, factor = 0.001),
                             lat = jitter(nexus_df$lat, factor = 0.001),
                             radius = 12, color = "blue",
                             popup = Text,
                             label = nexus_df$Title,
                             clusterOptions = markerClusterOptions())%>%
            clearBounds()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server) 
