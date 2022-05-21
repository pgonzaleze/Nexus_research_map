#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(pacman)
#p_load("shiny", "shinydashboard", "leaflet",
#       "tidyverse", "htmltools", "dplyr", "shinythemes")

library("shiny")
library("leaflet")
library('htmltools')
library('shinythemes')
library('dplyr')

#load dataframe
nexus_df <- read.csv(file = "Ocean_Nexus_Projects_list.csv", 
                     sep = ',', skip = 1)

Text = paste0("<b>Title:</b> ", nexus_df$Title,
              "<br>", "<b>PI:</b> ", nexus_df$PI.institution,
              "<br>", "<b>Research or Student Fellow / Research Associate:</b> ", nexus_df$Fellow,       
              "<br>", "<b>Description:</b> ", nexus_df$Description,
              "<br>", "<b>Progress:</b> ", nexus_df$Progress)

# Define UI for application that draws a map
ui <- fluidPage(theme = shinytheme("superhero"),
    titlePanel(h1("Nippon Foundation Ocean Nexus Center at UW EarthLab -- Research Projects", 
                  style = "color:#3474A7", align = "center")),
    sidebarLayout(
        sidebarPanel(
            img(src = "https://www.nippon-foundation.or.jp/app/themes/tnf-2019/assets/images/common/logo-horizontal.png",
                height = 50, width = 210, 
                style="display: block; margin-left: auto; margin-right: auto;"),
            h3("Our Research"),
            h5("Ocean Nexus research brings 
              together expertise in social 
              and natural sciences, from 
              critical theory to policy analysis 
              to equity and the environment, 
              for a holistic study of changes 
              to oceans and impacts on the 
              communities that rely on them."),
            br(),
            h5("Instead of modeling for the future, 
              we address current issues with evidence 
              and identify equitable solutions 
              that can be immediately implemented 
              for an equitable outcome.")
        ),
        mainPanel(width = 8, (
            leafletOutput(outputId = "map"))
        )
    )
)

# Define server logic required to draw a map
server <- function(input, output,server){
    output$map <- renderLeaflet({
        nexus_df%>%
            leaflet(options = leafletOptions(minZoom = 1)) %>%
            addProviderTiles(provider = "CartoDB") %>%
            setMaxBounds(lng1 = -179,
                         lat1 = -89,
                         lng2 = 179,
                         lat2 = 89) %>%
            addProviderTiles(provider = "CartoDB") %>%
            addCircleMarkers(lng = jitter(nexus_df$lon, factor = 0.001),
                             lat = jitter(nexus_df$lat, factor = 0.001),
                             radius = 12, color = "blue",
                             popup = Text,
                             label = nexus_df$Title,
                             clusterOptions = markerClusterOptions()) %>%
            clearBounds()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
