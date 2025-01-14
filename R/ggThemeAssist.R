#' ggThemeAssist
#'
#' \code{ggThemeAssist} is a RStudio-Addin that delivers a graphical interface for editing ggplot2 theme elements.
#'
#' @details To run the addin, either highlight a ggplot2-object in your current script and select \code{ggThemeAssist} from the Addins-menu within RStudio, or run \code{ggThemeAssistGadget(plot)} with a ggplot2 object as the parameter. After editing themes and terminating the addin, a character string containing the desired changes is inserted in your current script.
#' @param plot A ggplot2 plot object to manipulate its theme.
#' @examples
#' \dontrun{
#' # example for ggThemeAssist command line usage.
#' library(ggplot2)
#' gg <- ggplot(mtcars, aes(x = hp, y = mpg, colour = as.factor(cyl))) + geom_point()
#' ggThemeAssistGadget(gg)
#' }
#' @return \code{ggThemeAssist} returns a character vector.
#' @import shiny
#' @import ggplot2
#' @import formatR
#' @import rstudioapi
#' @importFrom grDevices col2rgb
#' @name ggThemeAssist
NULL

ggThemeAssist <- function(text){

  SubtitlesSupport <- any(names(formals(ggtitle)) == 'subtitle')

  if (grepl('^\\s*[[:alpha:]]+[[:alnum:]\\.]*\\s*$', paste0(text, collapse = ''))) {
    text <- gsub('\\s+', '', text)
    if (any(ls(envir = .GlobalEnv) == text)) {
      gg_original <- get(text, envir = .GlobalEnv)
      allowOneline <- TRUE
    } else {
      stop(paste0('I\'m sorry, I couldn\'t find object ', text, '.'))
    }
  } else {
    gg_original <- try(eval(parse(text = text)), silent = TRUE)
    allowOneline <- FALSE
    if(class(gg_original)[1] == 'try-error') {
      stop(paste0('I\'m sorry, I was unable to parse the string you gave to me.\n', gg_original))
    }
  }

  if (!is.ggplot(gg_original)) {
    stop('No ggplot2 object has been selected. Fool someone else!')
  }

  # add rgb colours to the available colours
  colours.available <- c(colours.available, getRGBHexColours(gg_original))
  default <- updateDefaults(gg_original, default, linetypes = linetypes)

  # Add support for new theme elements
  AvailableElements$plot.title.position <- list(
    name = 'plot.title.position',
    type = '',
    enabled = TRUE
  )

  # Update default values
  default$plot.title$hjust <- 0
  default$plot.subtitle$hjust <- 0
  default$plot.caption$hjust <- 1

  ui <- fluidPage(
    tags$script(jscodeWidth),
    tags$script(jscodeHeight),
    tags$style(type = "text/css", ".selectize-dropdown{ width: 200px !important; }"),

    titlePanel("ggplot Theme Assistant"),
    
    tabsetPanel(
      tabPanel("Settings",
               plotOutput("ThePlot5", width = '100%', height = '45%'),
               fluidRow(
                 column(4, h4('Plot dimensions')),
                 column(4, numericInput('plot.width', label = 'Width', min = 0, max = 10, step = 1, value = 10)),
                 column(4, numericInput('plot.height', label = 'Height', min = 0, max = 10, step = 1, value = 5))
               ),
               fluidRow(
                 column(4, h4("General options")),
                 column(4, checkboxInput('formatR', 'Use FormatR', value = getOption("ggThemeAssist.formatR", default = TRUE))),
                 column(4, if (allowOneline) {
                   checkboxInput('multiline', 'Multiline results', value = getOption("ggThemeAssist.multiline", default = FALSE))
                 })
               )
      ),
      tabPanel("Panel & Background",
               plotOutput("ThePlot2", width = '100%', height = '45%'),
               fluidRow(
                 column(3, h4('Plot Background')),
                 column(3, h4('Panel Background')),
                 column(3, h4('Grid Major')),
                 column(3, h4('Grid Minor'))
               ),
               fluidRow(
                 column(3, selectizeInput('plot.background.fill', label = 'Fill', choices = NULL, width = input.width)),
                 column(3, selectizeInput('panel.background.fill', label = 'Fill', choices = NULL, width = input.width)),
                 column(3, ""),
                 column(3, "")
               ),
               # ... (continue with other inputs)
      ),
      # ... (continue with other tabs)
    )
  )

  # Add new UI elements for newer ggplot2 theme options
  ui <- fluidPage(
    # ... existing UI elements ...
    
    tabPanel("Advanced",
      fluidRow(
        column(4, h4("Plot Title Position")),
        column(4, selectInput("plot.title.position", "Position", 
                              choices = c("panel", "plot"), selected = "panel"))
      ),
      fluidRow(
        column(4, h4("Subtitle")),
        column(4, textInput("plot.subtitle", "Subtitle Text"))
      ),
      fluidRow(
        column(4, h4("Caption")),
        column(4, textInput("plot.caption", "Caption Text"))
      )
    )
  )

  server <- function(input, output, session) {
    # ... existing server logic ...
    
    # Add reactive elements for new theme options
    observe({
      gg_reactive$theme$plot.title.position <- input$plot.title.position
      gg_reactive$labs$subtitle <- input$plot.subtitle
      gg_reactive$labs$caption <- input$plot.caption
    })
  }

  viewer <- dialogViewer(dialogName = 'ggThemeAssist', width = 990, height = 900)
  runGadget(ui, server, viewer = viewer)
}

#' @export
#' @rdname ggThemeAssist
ggThemeAssistGadget <- function(plot) {
  if (missing(plot)) {
    stop('You must provide a ggplot2 plot object.', call. = FALSE)
  }
  plot <- deparse(substitute(plot))
  if (grepl('^\\s*[[:alpha:]]+[[:alnum:]\\.]*\\s*$', paste0(plot, collapse = ''))) {
    ggThemeAssist(plot)
  } else {
    stop('You must provide a ggplot2 plot object.', call. = FALSE)
  }
}

ggThemeAssistAddin <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  text <- context$selection[[1]]$text
  if (nchar(text) == 0) {
    stop('Please highlight a ggplot2 plot before selecting this addin.')
  }
  ggThemeAssist(text)
}