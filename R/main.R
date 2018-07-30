#' A mulset function
#'
#' `mulset()` returns all multi-set intersections it found.
#'
#' This function allows you to generate specific type of multi-set intersections.
#' 
#' @param data Data-frame containing your data
#' @param exclude List of columns to exclude from analysis
#' @param maxIntersections Maximum number of unique multi-set intersections to generate
#' @keywords mulset
#' @export mulset
#' @return If any intersections around found it returns a list that contains all available multi-sets
#' @examples
#' 
#' data <- data.table::fread("../data/Example_100.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
#' resamples <- mulset(data, exclude = c("outcome", "age", "gender"), 250)
#' 
#' @importFrom gtools mixedsort
#' @importFrom digest digest


mulset <- function(data, exclude = c("outcome", "age", "gender"), maxIntersections = NULL){
	data <- data[ , !(names(data) %in% exclude)]
	data <- data[, mixedsort(names(data))]
	# Placeholder for combination across different subject feature sets
	featureSets <- list()

	# Placeholder for combination across different shared subject feature sets
	featureSetsShared <- list()
	intersectCounter <- 0

	for (i in 1:nrow(data)){   
		if (!is.null(maxIntersections) && maxIntersections > 0) {
			if(intersectCounter >= maxIntersections){
				next()
			}
		}

		sample <- data[i, ]
		sample <- sample[ , apply(sample, 2, function(x) any(isNumeric(x)))]
		if(ncol(sample) == 0) { next() }

		sampleFeatures <- names(sample)
		featuresID <- digest(paste(sampleFeatures, sep = ",", collapse = ","), algo="sha512", serialize=F, file=FALSE)

		if (is.null(featureSets[[featuresID]])) {
			featureSets[[featuresID]] <- sampleFeatures;
		} else {
			next()
		}

		featureSets <- featureSets[mixedsort(names(featureSets))]

		for (featuresTempID in names(featureSets)) {
			featuresTempValue <- featureSets[[featuresTempID]]

			featuresShared <- intersect(featuresTempValue, sampleFeatures)
			if (length(featuresShared) > 0) {
				featuresShared <- mixedsort(featuresShared)
				featuresSharedID =  digest(paste(featuresShared, sep = ",", collapse = ","), algo="sha512", serialize=F, file=FALSE)
		
				if (is.null(featureSetsShared[[featuresSharedID]])) {
					featureSetsShared[[featuresSharedID]] <- list(
						totalFeatures = length(featuresShared),
						listFeatures = featuresShared,
						listSamples = c(),
						totalSamples = 0,
						totalDatapoints = 0
					)
					intersectCounter = intersectCounter + 1
				}
			}
		}
	}

	## Get number of samples for each feature set
	for (key in names(featureSetsShared)) {
		value <- featureSetsShared[[key]]

		for (c in 1:nrow(data)){   
			sample <- data[c, ]
			sample <- sample[ , apply(sample, 2, function(x) any(isNumeric(x)))]
			if(ncol(sample) == 0) { next() }

			featuresShared <- intersect(value$listFeatures, names(sample));

			if (length(featuresShared) == value$totalFeatures) {
				featureSetsShared[[key]]$totalSamples <- featureSetsShared[[key]]$totalSamples + 1;
				featureSetsShared[[key]]$listSamples <- c(featureSetsShared[[key]]$listSamples, c)
			}
		}
		featureSetsShared[[key]]$totalDatapoints = (featureSetsShared[[key]]$totalSamples * featureSetsShared[[key]]$totalFeatures);
		#featureSetsShared[$key]['listSamples'] = $this->generateRanges($featureSetsShared[$key]['listSamples']);
	}

	return(featureSetsShared)
}

## data <- data.table::fread("../data/Example_100.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
## resamples <- mulset(data, exclude = c("outcome", "age", "gender"))
## print(resamples)