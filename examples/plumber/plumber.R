#* @get /mean
function(samples = 10) {
  data <- rnorm(samples)
  mean(data)
}

#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}
