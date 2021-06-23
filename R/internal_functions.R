#' Extracting the Model Frame from a Formula or Fit
#'
#' @param formula a model \code{\link[stats]{formula}}
#' @param ...
#'
#' @noRd
#'
model.frame.fastLm <- function (formula, ...) {
  dots <- list(...)
  nargs <- dots[match(c("data"), names(dots),
                      0)]
  fcall <- formula$call
  m <- match(c("formula", "data"), names(fcall), 0L)
  fcall <- fcall[c(1L, m)]
  fcall$drop.unused.levels <- TRUE
  fcall[[1L]] <- quote(stats::model.frame)
  fcall$xlev <- formula$xlevels
  fcall$formula <- terms(formula)
  fcall[names(nargs)] <- nargs
  env <- environment(formula$terms)
  if (is.null(env))
    env <- parent.frame()
  eval(fcall, env)
}


#' Construct Design Matrices
#'
#' @param
#' @param ...
#'
#' @noRd
#'
model.matrix.fastLm <- function (object, ...) {
  if (n_match <- match("x", names(object), 0L))
    object[[n_match]]
  else {
    data <- model.frame.fastLm(object, xlev = object$xlevels, ...)
    if (exists(".GenericCallEnv", inherits = FALSE))
      NextMethod("model.matrix", data = data, contrasts.arg = list(k_dummy = "contr.treatment"))
    else {
      dots <- list(...)
      dots$data <- dots$contrasts.arg <- NULL
      do.call("model.matrix.default", c(list(object = object,
                                             data = data, contrasts.arg = list(k_dummy = "contr.treatment")),
                                        dots))
    }
  }
}


#' Extract Lambda
#'
#' @param data
#' @param case_w
#' @param art
#' @param test_w
#'
#' @noRd
#'
get_lambda <- function(data, case_w, art, test_w){
  data %>%
    dplyr::filter(case == case_w,
                  test.type == test_w) %>%
    dplyr::select(all_of(art)) %>%
    dplyr::pull()
}


#' Extract Model
#'
#' @param trendtype
#' @param test
#'
#' @noRd
#'
get_model <- function(trendtype, test){
  models %>%
    dplyr::filter(case == trendtype,
                  test.type == test) %>%
    dplyr::select(model) %>%
    dplyr::pull() %>%
    purrr::pluck(1)
}


#' Get critical Value
#'
#' @param trendtype
#' @param k_s
#' @param test
#'
#' @noRd
#'
get_critical_val <- function(trendtype, k_s, test){
  models %>%
    dplyr::filter(case == trendtype,
                  test.type == test) %>%
    tidyr::unnest(critical) %>%
    dplyr::filter(k == k_s) %>%
    dplyr::pull(crit_val)
}


#' Predict p-Value from Test Statistic
#'
#' @param bh.test
#' @param trendtype
#' @param test.type
#' @param k
#'
#' @noRd
#'
get_p_value <- function(bh.test, trendtype, test.type, k){
  # trendtype = case

  # getting lambda for p_values
  lambda_p <- get_lambda(models, trendtype, 'p', 'all')
  # getting lambda for stat
  lambda_stat <- get_lambda(models, trendtype, 'stat', test.type)
  # getting critical val
  crit_val <- get_critical_val(trendtype, k, test.type)

  if (crit_val <= bh.test) {
    p.value <- 1e-12
  }else{
    # saving model
    model <- get_model(trendtype, test.type)
    # dependent var
    dep_var <- model %>%
      purrr::pluck('formula') %>%
      purrr::pluck(2) %>%
      as.character()

    # generating data set
    new_data <- tibble(dep = 1L,
                       stat_Fisher_all_bc = ((bh.test^lambda_stat)-1)/lambda_stat,
                       stat_Fisher_E_J_bc = ((bh.test^lambda_stat)-1)/lambda_stat,
                       k_dummy = as.factor(k))
    colnames(new_data)[1] <- dep_var
    # approximation of the model
    p.value_raw <- as.vector(model.matrix.fastLm(object = model, data = new_data) %*% coef(model))

    p.value_trans <- if(stringr::str_detect(dep_var, '_bc')){
      Re((lambda_p*as.complex(p.value_raw) + 1)^(1/lambda_p))
    } else {p.value_raw}

    p.value <- ifelse(p.value_trans >= 1, 9.9999e-1, ifelse(p.value_trans <= 0, 1e-12, p.value_trans))
  }

  return(p.value)
}
