library(microserver)
library(methods)
library(mungebits)
library(stats)
library(gbm)
predict.gbm <- gbm:::predict.gbm

model <-  s3read('syberia/titanic/gbm')
processSingleDataPoint <- function(datum, model) {
  if (is.list(datum)) {
    datum <- data.frame(denull(datum), stringsAsFactors=FALSE)
  }
  normalize(model$predict(datum, list(on_train = TRUE)))
}

normalize <- function(num) {
  MEAN <- 0.381971
  SD   <- 0.4860552
  1/(1 + exp((num - MEAN) / SD))
}

denull <- function (lst) {
  Map(function (x) {if (is.null(x)) NA else x}, lst)
}
routes <- list(
  '/predict' = function(p, q) {
    list(score = processSingleDataPoint(p, model))
  },
  function(...) "pong")
cat('serving...\n')
microserver::run_server(routes, port = 8105)
