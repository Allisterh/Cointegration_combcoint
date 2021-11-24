#' @export
print.bhtest <- function(x, ...) {
  cat(c("----------------------------------------------------------",
        "Bayer Hanck Test for Non-Cointegration",
        "----------------------------------------------------------",
        paste(c("Test statistic:", round(x$bh.test, 4)),
              collapse = " "),
        paste(c("p-Value:", ifelse(x$bh.pval <= 1e-12, "< 1e-12", format(x$bh.pval, scientific = TRUE))),
              collapse = " ")),
      sep = "\n")
}

