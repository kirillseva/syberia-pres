library(magrittr)
library(httr)
library(jsonlite)
URL <- 'http://localhost:8105'

shinyServer(function(input, output) {
  score <- reactive({
    payload = list(
      pclass    = input$pclass,
      sex       = input$sex,
      name      = paste(input$title, input$name),
      age       = input$age,
      sibsp     = input$siblings + as.numeric(input$spouse),
      parch     = input$parents  + input$children,
      ticket    = 234600,
      fare      = input$fare,
      cabin     = 'B5',
      embarked  = input$embarked,
      home.dest = paste(input$from, '/', input$to)
    )
    httr::POST(paste0(URL, '/predict'), encode = 'json', body = payload) %>%
      content %>%
      jsonlite::fromJSON(.) %>%
      .$score
  })

  output$survived <- renderText({ score() })
})
