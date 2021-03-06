#' data.frame-first formula-second method for \code{\link[stats]{t.test}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{t.test}}.
#'
#' @seealso \code{\link[stats]{t.test}}
#'
#' @inheritParams twidlr_defaults
#' @export
#'
#' @examples
#' ttest(iris[1:100,], Petal.Width ~ Species)
ttest <- function(data, formula, ...) {
  check_pkg("stats")
  UseMethod("ttest")
}

#' @export
ttest.default <- function(data, formula, ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  stats::t.test(formula = formula, data = data, ...)
}


#' data.frame-first formula-second method for \code{\link[stats]{lm}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{lm}}.
#'
#' @seealso \code{\link[stats]{lm}}
#'
#' @inheritParams twidlr_defaults
#' @export
#'
#' @examples
#' fit <- lm(mtcars, hp ~ .)
#' summary(fit)
#'
#' # Help page for function being twiddled
#' ?stats::lm
lm <- function(data, formula, ...) {
  check_pkg("stats")
  UseMethod("lm")
}

#' @export
lm.default <- function(data, formula, ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  stats::lm(formula = formula, data = data, ...)
}

#' @rdname lm
#' @export
#' @export predict.lm
predict.lm <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  stats::predict.lm(object, newdata = data, ...)
}


#' data.frame-first formula-second method for \code{\link[stats]{glm}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{glm}}.
#'
#' @seealso \code{\link[stats]{glm}}
#'
#' @inheritParams twidlr_defaults
#' @export
#'
#' @examples
#' fit <- glm(mtcars, vs ~ hp + wt, family = binomial())
#' summary(fit)
#' predict(fit, mtcars[1:5,])
#'
#' # Help page for function being twiddled
#' ?stats::glm
glm <- function(data, formula, ...) {
  check_pkg("stats")
  UseMethod("glm")
}

#' @export
glm.default <- function(data, formula, ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  stats::glm(formula = formula, data = data, ...)
}

#' @rdname glm
#' @export
#' @export predict.glm
predict.glm <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  stats::predict.glm(object, newdata = data, ...)
}


#' data.frame-first formula-second method for \code{\link[stats]{kmeans}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{kmeans}}.
#'
#' @seealso \code{\link[stats]{kmeans}}
#'
#' @inheritParams unsupervised_twidlr_defaults
#' @export
#'
#' @examples
#' # Standard kmeans
#' kmeans(iris, centers = 3)
#'
#' # formula interface can be used to select certain variables
#' kmeans(iris, ~ Petal.Width + Sepal.Width, centers = 3)
#'
#' #... or create new variables. Consider non-linear example:
#'
#' # Create data for two circles
#' x <- matrix(rnorm(300),nc=2)
#' y <- x/sqrt(rowSums(x^2))
#' d <- data.frame(rbind(y, y*5))
#' plot(d)
#'
#' fit <- kmeans(d, centers = 2)
#' plot(d, col = predict(fit, d))
#'
#' fit <- kmeans(d, ~ X1 + X2 + I(X1^2 + X2^2), centers = 2)
#' plot(d, col = predict(fit, d))
kmeans <- function(data, formula = ~., ...) {
  check_pkg("stats")
  UseMethod("kmeans")
}

#' @export
kmeans.default <- function(data, formula = ~., ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  x <- model_as_xy(data, formula)$x
  object <- stats::kmeans(x = x, ...)
  attr(object, "formula") <- formula
  object
}

#' @rdname kmeans
#' @export
#' @export predict.kmeans
predict.kmeans <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  data <- model_as_xy(data, attr(object, "formula"))$x

  centers   <- object[["centers"]]
  n_centers <- nrow(centers)
  distances <- matrix(0, nrow = nrow(data), ncol = n_centers)

  for (i in seq(n_centers)) {
    distances[,i] <- sqrt(rowSums(t(t(data) - centers[i,])^2))
  }

  apply(distances, 1, which.min)
}


#' data.frame-first formula-second method for \code{\link[stats]{prcomp}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{prcomp}}.
#'
#' @seealso \code{\link[stats]{prcomp}}
#'
#' @inheritParams twidlr_defaults
#' @param formula a formula with no response variable, referring only to numeric
#'   variables
#' @export
#'
#' @examples
#' prcomp(mtcars)
#'
#' fit <- prcomp(mtcars, ~ .*.)
#' predict(fit, mtcars[1:5,])
prcomp <- function(data, formula = ~., ...) {
  check_pkg("stats")
  UseMethod("prcomp")
}

#' @export
prcomp.default <- function(data, formula = ~., ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  object <- stats:::prcomp.formula(formula = formula, data = data, ...)
  attr(object, "formula") <- formula
  object
}

#' @rdname prcomp
#' @export
#' @export predict.prcomp
predict.prcomp <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  data <- model_as_xy(data, attr(object, "formula"))$x
  stats:::predict.prcomp(object = object, newdata = data, ...)
}


#' data.frame-first formula-second method for \code{\link[stats]{aov}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{aov}}.
#'
#' @seealso \code{\link[stats]{aov}}
#'
#' @inheritParams twidlr_defaults
#' @export
#'
#' @examples
#' fit <- aov(mtcars, hp ~ am * cyl)
#' summary(fit)
#' predict(fit, mtcars)
aov <- function(data, formula, ...) {
  check_pkg("stats")
  UseMethod("aov")
}

#' @export
aov.default <- function(data, formula, ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  stats::aov(formula = formula, data = data, ...)
}

# predict method for aov is predict.lm


#' data.frame-first formula-second method for \code{\link[stats]{prcomp}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{prcomp}}.
#'
#' @seealso \code{\link[stats]{prcomp}}
#'
#' @inheritParams unsupervised_twidlr_defaults
#' @export
#'
#' @examples
#' prcomp(mtcars)
#'
#' fit <- prcomp(mtcars, ~ .*.)
#' predict(fit, mtcars[1:5,])
prcomp <- function(data, formula = ~., ...) {
  check_pkg("stats")
  UseMethod("prcomp")
}

#' @export
prcomp.default <- function(data, formula = ~., ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  object <- stats:::prcomp.formula(formula = formula, data = data, ...)
  attr(object, "formula") <- formula
  object
}

#' @rdname prcomp
#' @export
#' @export predict.prcomp
predict.prcomp <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  data <- model_as_xy(data, attr(object, "formula"))$x
  stats:::predict.prcomp(object = object, newdata = data, ...)
}


#' data.frame-first formula-second method for \code{\link[stats]{factanal}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[stats]{factanal}}.
#'
#' @seealso \code{\link[stats]{factanal}}
#'
#' @inheritParams unsupervised_twidlr_defaults
#' @export
#'
#' @examples
#'factanal(mtcars, factors = 3)
#'
#' fit <- factanal(mtcars, ~ hp*am*wt, factors = 3)
#' predict(fit, mtcars[1:5, ])
factanal <- function(data, formula = ~., ...) {
  check_pkg("stats")
  UseMethod("factanal")
}

#' @export
factanal.default <- function(data, formula = ~., ...) {
  key_args <- coerce_args(data, formula)
  data     <- key_args$data
  formula  <- key_args$formula

  object <- stats::factanal(x = formula, data = data, ...)

  # To predict via regression method
  data <- model_as_xy(data, formula)$x
  Lambda <- object$loadings
  cv <- stats::cov.wt(data)$cov
  sds <- sqrt(diag(cv))
  cv <- cv/(sds %o% sds)

  attr(object, "predict_matrix") <- solve(cv, Lambda)
  attr(object, "formula") <- formula
  object
}

#' @rdname factanal
#' @export
#' @export predict.factanal
predict.factanal <- function(object, data, ...) {
  data <- predict_checks(data = data, ...)
  data <- model_as_xy(data, attr(object, "formula"))$x

  # The below solves for "regression" method conducted by factanal.
  # Partially uses code from original function. Must cite relevant author
  results <- scale(data, TRUE, TRUE) %*% attr(object, "predict_matrix")
  as.data.frame(results)
}
