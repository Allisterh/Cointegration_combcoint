#' @export
print.bhtest <- function(x, ...) {
  cat(c("----------------------------------------------------------",
        "Bayer Hanck Test for Non-Cointegration",
        "----------------------------------------------------------",
        paste(c("Test statistic:", round(x$bh.test, 4)),
              collapse = " "),
        paste(c("p-Value:", round(x$bh.pval, 4)),
              collapse = " ")),
      sep = "\n")
}

