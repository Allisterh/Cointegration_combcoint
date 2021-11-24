#' @export
print.bhtest <- function(x, ...) {
  cat(c("----------------------------------------------------------",
        "Bayer Hanck Test for Non-Cointegration",
        "----------------------------------------------------------",
        paste(c("Test statistic:", round(x$bh.test, 4)),
              collapse = " "),
        paste("p-Value:", ifelse(x$bh.pval <= 1e-12, paste(c("<", x$bh.pval), collapse = ""), round(x$bh.pval, 4)), collapse = " ")),
      sep = "\n")
}

