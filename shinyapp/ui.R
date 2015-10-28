shinyUI(fluidPage(
  titlePanel("Titanic survival"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        radioButtons("title", "Title",
          choices = list("Mr." = "Mr.", "Ms." = "Ms.", "Mrs." = "Mrs.",
                         "Master" = "master", "Dr." = "Dr.", "Reverent" = "rev"),
          selected = "Mr."),
        textInput("name", label = "Name", value = "John Doe"),
        radioButtons("pclass", "Title",
          choices = list("1st" = "1st", "2nd" = "2nd", "3rd" = "3rd"),
          selected = "1st"),
        radioButtons("sex", "Sex",
          choices = list("male" = "male", "female" = "female"),
          selected = "male"),
        numericInput("age", "Age", value = 42, min = 0, max = 80, step = 1),
        numericInput("siblings", "Siblings", value = 0, min = 0, max = 10, step = 1),
        numericInput("children", "Children", value = 0, min = 0, max = 10, step = 1),
        numericInput("parents", "Parents", value = 0, min = 0, max = 2, step = 1),
        checkboxInput("spouse", label = "With spouse?", value = FALSE),
        numericInput("fare", "Ticket price", value = 33, min = 0, max = 512, step = 1),
        radioButtons("embarked", "Embarked",
          choices = list("Southampton" = "Southampton",
                         "Cherbourg"   = "Cherbourg",
                         "Queenstown" = "Queenstown"),
          selected = "Southampton"),
        textInput("from", label = "Traveling from", value = "London"),
        textInput("to", label = "Traveling to", value = "Pittsburgh, PA")
      ),
      wellPanel(
        tags$small(paste0(
          "Predicting survival % on titanic"
        ))
      )
    ),
    column(9,
      wellPanel(
        span(h3("Survival chance:"),
          h1(textOutput("survived"))
        )
      )
    )
  )
))
