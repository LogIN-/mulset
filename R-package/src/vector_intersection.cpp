#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::interfaces(r)]]
// [[Rcpp::export]]
StringVector vector_intersection(StringVector v1, StringVector v2)
{

    StringVector v3;

    std::sort(v1.begin(), v1.end());
    std::sort(v2.begin(), v2.end());

    std::set_intersection(v1.begin(),v1.end(),v2.begin(),v2.end(), std::back_inserter(v3));

    return v3;
}
