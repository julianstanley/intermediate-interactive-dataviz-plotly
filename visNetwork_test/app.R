library(shiny)
library(visNetwork)

library(shiny)

init.nodes <- data.frame(id = c("up", "down"),
                    label = c("up", "down"))
init.edges <- data.frame(id = c("updown", "downup", "upup"),
                    to = c("up", "down", "up"),
                    from = c("down", "up", "up"),
                    label = c("updown", "downup", "upup"))
ui <- navbarPage(
  "visNetwork test",

  tabPanel("Plot",
           fluidRow(
             column(
               width = 6,
               visNetworkOutput("network")
             ),
             column(
               width = 6,
               tags$h1("Nodes in the graph:"),
               tableOutput("all_nodes"),
               tags$h1("Edges in the graph:"),
               tableOutput("all_edges")
             )
           )
  )
)

server <- function(input, output, session) {
  graph_data = reactiveValues(
      nodes = init.nodes,
      edges = init.edges
  )


  output$network <- renderVisNetwork({
    visNetwork(graph_data$nodes, graph_data$edges) %>%
      visEdges(arrows = "to", physics = FALSE,
               smooth = list(
                 type = "curvedCW",
                 roundness = 0.2)) %>%
      visOptions(manipulation = list(
        enabled = TRUE,
        editEdge = TRUE


        # htmlwidgets::JS("function(data, callback) {
        #               function clearPopUp() {
        #         document.getElementById('saveButton').onclick = null;
        #         document.getElementById('cancelButton').onclick = null;
        #         document.getElementById('network-popUp').style.display = 'none';
        #               }
        #           function saveEdge(data, callback, cmd) {
        #             callback(data); //must be first called for egde id !
        #             if (window.Shiny){
        #               var obj = {cmd: cmd, id: data.id, from: data.from, to: data.to, label: data.label};
        #               Shiny.onInputChange(el.id + '_graphChange', obj);
        #             }
        #
        #           }
        #       document.getElementById('operation').innerHTML = 'Edit Edge';
        #       document.getElementById('node-id').value = data.id;
        #       document.getElementById('node-label').value = data.label;
        #       document.getElementById('cancelButton').onclick = () => {
        #         clearPopUp();
        #       };
        #       document.getElementById('saveButton').onclick = () => {
        #         saveEdge(data, callback, 'editEdge')
        #       }
        #       document.getElementById('network-popUp').style.display = 'block';
        #                            }")
      ))
  })

  # Render table with all nodes
  output$all_nodes = renderTable({
    graph_data$nodes
  })

  # Render table with all edges
  output$all_edges = renderTable({
    graph_data$edges
  })

  observeEvent(input$network_graphChange, {
    if(input$network_graphChange$cmd == "addNode") {
      temp = bind_rows(
        graph_data$nodes,
        data.frame(id = input$network_graphChange$id,
                   label = input$network_graphChange$label,
                   stringsAsFactors = F)
      )
      graph_data$nodes = temp
    } else if (input$network_graphChange$cmd == "addEdge") {
      temp = bind_rows(
        graph_data$edges,
        data.frame(id = input$network_graphChange$id,
                   from = input$network_graphChange$from,
                   to = input$network_graphChange$to,
                   stringsAsFactors = F)
      )
      graph_data$edges = temp
    } else if(input$network_graphChange$cmd == "editEdge") {
      temp = graph_data$edges
      temp$from[temp$id == input$network_graphChange$id] = input$network_graphChange$from
      temp$to[temp$id == input$network_graphChange$id] = input$network_graphChange$to
      graph_data$edges = temp
    }
  })
}

shinyApp(ui, server)
