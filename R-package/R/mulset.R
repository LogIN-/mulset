#' A mulset function
#'
#' `mulset()` returns all multi-set intersections
#'
#' This function allows you to generate specific type of multi-set intersections.
#' It searches for multi set intersections between rows and column identifiers. If no NA values are present only 1 dataset is returned as expected.
#' 
#' @param data Data frame containing your data
#' @param exclude Vector containing  one  or  more  variable  names  from `names(data)`
#' @param include List of attributes which will be shown in results. Possible values are: c("samples", "samples_count", "datapoints"). If parameter is set to NULL only c("features", "feature_count") will be returned.
#' @param maxIntersections Maximum number of unique datasets to generate, if NULL all datasets will be generated
#' @param hashMethod Hashing method to use for unique sets identification. Available choices: md5(default), sha1, crc32, sha256, sha512, xxhash32, xxhash64, murmur32
#' @keywords mulset, multi-set intersection, table intersection, missing data
#' @return If any intersections are found it returns a list that contains all available multi-set intersections
#' 	You can convert this to data-frame following example provided or use it as it is.
#' @importFrom gtools mixedsort
#' @importFrom digest digest
#' @importFrom stats complete.cases
#' @examples
#' data(mulsetDemo)
#' print(head(mulsetDemo))
#' resamples <- mulset(mulsetDemo, exclude = c("outcome", "age", "gender"), maxIntersections = 250)
#' ## Loop through returned list or convert it to data-frame
#' ## resamplesFrame <- as.data.frame(t(sapply(resamples,c)))
#' @export mulset
mulset <- function(data, exclude = NULL, include = c("samples", "samples_count", "datapoints"), maxIntersections = NULL, hashMethod = "md5"){
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

	for (i in seq_len(dataRowsCount)){   
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
						features_hash = featuresSharedID,
						feature_count = length(featuresShared),
						features = featuresShared
					)
					if (!is.null(maxIntersections) && maxIntersections > 0) {
						intersectCounter <- intersectCounter + 1
						if(intersectCounter == maxIntersections){
							break
						}
					}
				}
			}
		}
	}

	if(!is.null(include) && length(include) > 0){
		## Get number of samples for each feature set
		for (key in names(featureSetsShared)) {

			queryData <- data[complete.cases(data[ , featureSetsShared[[key]]$features]), ] 
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
	## Reset return list keys
	names(featureSetsShared) <- seq(1, length(featureSetsShared))	

	return(featureSetsShared)
}