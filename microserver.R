library(microserver)
library(methods)
library(mungebits)
library(stats)
library(gbm)
predict.gbm <- gbm:::predict.gbm # little hack

model <-  s3read('syberia/titanic/gbm')

normalize <- function(num) {
  MEAN <- model$internal$mean_dv
  SD   <- model$internal$sd_dv
  1 / (1 + exp((num - MEAN) / SD))
}
processSingleDataPoint <- function(datum, model) {
  if (is.list(datum)) {
    datum <- data.frame(denull(datum), stringsAsFactors=FALSE)
  }
  normalize(model$predict(datum, list(on_train = TRUE)))
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
