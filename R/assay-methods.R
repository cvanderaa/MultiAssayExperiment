#' @describeIn ExperimentList Obtain the specified assay with a \code{numeric}
#' or \code{character} reference
setMethod("assay", c("ANY", "missing"),
    function(x, i, withDimnames = TRUE, ...) {
        if (is(x, "ExpressionSet"))
            return(Biobase::exprs(x))
        return(x)
    }
)

#' @describeIn ExperimentList Get the assay data from each element in the
#' \link{ExperimentList}
#' @param withDimnames logical (default TRUE) whether to return dimension names
#' @aliases assay,ExperimentList,missing-method
setMethod("assays", "ExperimentList", function(x, withDimnames = TRUE, ...) {
    as(S4Vectors::endoapply(x,
        FUN = function(y) assay(y, withDimnames = withDimnames, ...)
    ), "SimpleList")
})

#' @rdname ExperimentList-class
#' @param i A scalar \code{character} or \code{integer} index
setMethod("assay", c("ExperimentList", "missing"),
    function(x, i, withDimnames = TRUE, ...) {
        if (!length(x))
            stop("'assay(<", class(x), ">, i=\"missing\", ...) ",
                 "length(<", class(x), ">) is 0'")
        assay(x[[1L]], ...)
    }
)

#' @rdname ExperimentList-class
setMethod("assay", c("ExperimentList", "numeric"),
    function(x, i, withDimnames = TRUE, ...) {
        tryCatch({
            assay(x[[i]], ...)
        }, error = function(err) {
            stop("'assay(<", class(x), ">, i=\"numeric\", ...)' ",
                 "invalid subscript 'i'\n", conditionMessage(err))
        })
    }
)

#' @rdname ExperimentList-class
setMethod("assay", c("ExperimentList", "character"),
    function(x, i, withDimnames = TRUE, ...) {
        msg <- paste0("'assay(<", class(x), ">, i=\"character\", ...)' ",
                      "invalid subscript 'i'")
        res <- tryCatch({
            assay(x[[i]], ...)
        }, error = function(err) {
            stop(msg, "\n", conditionMessage(err))
        })
        if (is.null(res))
            stop(msg, "\n'i' not in names(<", class(x), ">)")
        res
    }
)

#' @describeIn MultiAssayExperiment Obtain a \code{\link{SimpleList}} of assay
#' data for all available experiments in the object
#' @param withDimnames logical (default TRUE) whether to return dimension names
#' included in the object
#' @exportMethod assays
setMethod("assays", "MultiAssayExperiment",
    function(x, withDimnames = TRUE, ...) {
        assays(experiments(x), withDimnames = withDimnames, ...)
    }
)

#' @describeIn MultiAssayExperiment Convenience function for extracting the
#' assay of the first element (default) in the \code{ExperimentList}. A
#' \code{numeric} or \code{character} index can also be provided
#' @exportMethod assay
setMethod("assay", c("MultiAssayExperiment", "missing"),
    function(x, i, withDimnames = TRUE, ...) {
        assay(experiments(x), withDimnames = withDimnames, ...)
    }
)

#' @rdname MultiAssayExperiment-class
#' @param i An integer or character scalar indicating the assay to return
setMethod("assay", c("MultiAssayExperiment", "numeric"),
    function(x, i, withDimnames = TRUE, ...) {
        assay(experiments(x), i = i, withDimnames = withDimnames, ...)
    }
)

#' @rdname MultiAssayExperiment-class
setMethod("assay", c("MultiAssayExperiment", "character"),
    function(x, i, withDimnames = TRUE, ...) {
        assay(experiments(x), i = i, ...)
    }
)
