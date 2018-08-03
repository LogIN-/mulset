#' A mulset function
#'
#' `mulset()` returns all multi-set intersections it found.
#'
#' This function allows you to generate specific type of multi-set intersections.
#' It searches for multi set intersections between rows and column identifiers. If no NA values are present only 1 dataset is returned as expected.
#' 
#' @param data Data frame containing your incomplete data.
#' @param exclude Vector  of  strings  containing  one  or  more  variable  names  from names(data)
#' @param include List of attributes to return in results. Possible values are: c("samples", "samples_count", "datapoints"). If parameter is set to NULL only features will be returned.
#' @param maxIntersections Maximum number of unique multi-set intersections to generate
#' @param hashMethod Hashing method to use for unique sets identification. Available choices: md5 (default),sha1,crc32,sha256,sha512,xxhash32,xxhash64,murmur32
#' @param resetHashIDs Should we reset return list keys or keep original features hash as a key value
#' @keywords mulset, multi-set intersection, table intersection, missing data
#' @return If any intersections are found it returns a list that contains all available multi-set intersections
#' 	You can convert this to data-frame following example provided or use it as it is.
#' @importFrom gtools mixedsort
#' @importFrom digest digest
#' @useDynLib mulset
#' @importFrom Rcpp sourceCpp
#' @examples
#' data(mulsetDemo)
#' print(head(mulsetDemo))
#' resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250)
#' ## Loop through returned list or convert it to data-frame
#' resamplesFrame <- as.data.frame(t(sapply(resamples,c)))
#' @export mulset
mulset <- function(data, exclude = NULL, include = c("samples", "samples_count", "datapoints"), maxIntersections = NULL, hashMethod = "md5", resetHashIDs = FALSE){
	if(!is.data.frame(data)){
		 stop("data argument must be a valid data frame. Please check mulsetDemo data that is distributed with a package.")
	}
	if(!is.null(exclude) && length(exclude) > 0){
		data <- data[ , !(names(data) %in% exclude)]
	}
	## Sort column names
	data <- data[, mixedsort(names(data))]
	dataRowsCount <- nrow(data)

	# Placeholder for combination across different subject feature sets
	featureSets <- list()

	# Placeholder for combination across different shared subject feature sets
	featureSetsShared <- list()
	intersectCounter <- 0

	for (i in 1:dataRowsCount){   
		if (!is.null(maxIntersections) && maxIntersections > 0) {
			if(intersectCounter >= maxIntersections){
				break
			}
		}

		sample <- data[i, ]
		## Remove all columns if they are not specific data type, in this case check for numbers
		sample <- sample[ , apply(sample, 2, function(x) any(isNumeric(x)))]
		if(ncol(sample) == 0) { next() }

		sampleFeatures <- names(sample)
		featuresID <- digest(paste(sampleFeatures, sep = ",", collapse = ","), algo=hashMethod, serialize=F, file=FALSE)

		if (is.null(featureSets[[featuresID]])) {
			featureSets[[featuresID]] <- sampleFeatures;
		} else {
			next()
		}

		featureSets <- featureSets[mixedsort(names(featureSets))]

		for (featuresTempID in names(featureSets)) {
			featuresTempValue <- featureSets[[featuresTempID]]

			featuresShared <- intersect(featuresTempValue, sampleFeatures)
			## featuresShared <- intersection(featuresTempValue, sampleFeatures)

			if (length(featuresShared) > 0) {
				featuresShared <- mixedsort(featuresShared)
				featuresSharedID =  digest(paste(featuresShared, sep = ",", collapse = ","), algo=hashMethod, serialize=F, file=FALSE)
		
				if (is.null(featureSetsShared[[featuresSharedID]])) {
					featureSetsShared[[featuresSharedID]] <- list(
						feature_count = length(featuresShared),
						features = featuresShared
					)
					intersectCounter = intersectCounter + 1
				}
			}
		}
	}

	if(!is.null(include) && length(include) > 0){
		## Get number of samples for each feature set
		for (key in names(featureSetsShared)) {

			queryData <- data[stats::complete.cases(featureSetsShared[[key]]$features), ] 
			totalSamples <- nrow(queryData)

			if('samples' %in% include){
				featureSetsShared[[key]]$samples <- as.numeric(rownames(queryData))
			}
			if('samples_count' %in% include){
				featureSetsShared[[key]]$samples_count <- as.numeric(totalSamples)
			}
			if('datapoints' %in% include){
				featureSetsShared[[key]]$datapoints <- as.numeric((totalSamples * featureSetsShared[[key]]$feature_count));
			}
		}
	}

	if(!isTRUE(resetHashIDs)){
		names(featureSetsShared) <- seq(1, length(featureSetsShared))	
	}	

	return(featureSetsShared)
}

# library(data.table)
# library(gtools)
# library(digest)
# source("./utils.R")
# source("./intersection.R")
# source("./RcppExports.R")
# mulsetDemo <-fread("../data/mulsetDemo.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
# exclude <- c("outcome", "age", "gender")
# 
# mulsetDemo <-fread("../data/EY2_trans_804f.csv", header = T, sep = ',', stringsAsFactors = FALSE, data.table = FALSE)
# exclude <- c("age","Gender","CMV")
# 
# system.time({ 
# 	resamples <- mulset(mulsetDemo, exclude = exclude, include = c("samples_count", "datapoints"), maxIntersections = 250, hashMethod = "sha1", resetHashIDs = FALSE)
# 	resamples <- as.data.frame(t(sapply(resamples,c)))
# })

##system.time( replicate(50, mulset(mulsetDemo, exclude = exclude, include = c("samples_count", "datapoints"), maxIntersections = 250, hashMethod = "md5", resetHashIDs = TRUE) ) )

## > system.time( replicate(10, mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250) ) )
##    user  system elapsed 
##   0.145   0.000   0.146 
## > system.time( replicate(100, mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250) ) )
##    user  system elapsed 
##   1.535   0.003   1.538 
## > system.time( replicate(250, mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), 250) ) )
##    user  system elapsed 
##   3.655   0.000   3.655 