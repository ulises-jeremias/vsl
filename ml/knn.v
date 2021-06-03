module ml

import vsl.blas.vlas.internal.float64 { l2_distance_unitary }
import vsl.errors

// KNN is the struct defining a K-Nearest Neighbors classifier.
pub struct KNN {
mut:
	data		&Data
	weights		map[f64]f64 // weights[class] = weight
pub mut:
	neighbors	[]&Neighbor
}

// Neighbor is a support struct to help organizing the code
// and calculating distances, as well as sorting using array.sort.
struct Neighbor {
mut:
	point    []f64
	class    f64
	distance f64
}

// new_knn accepts a `vml.ml.Data` parameter called `data`, that will be used
// to predict values with `KNN.predict`. You can use the following piece of code to
// make your life easier:
// ```mut knn := new_knn(mut data_from_raw_xy_sep([[0.0, 0.0], [10.0, 10.0]], [0.0, 1.0]))```
// If you predict with `knn.predict(1, [9.0, 9.0])`, it should return 1.0 as it is the closest
// to [10.0, 10.0] (which is class 1.0).
pub fn new_knn(mut data Data) &KNN {
	if data.x.data.len == 0 {
		errors.vsl_panic('vls.ml.knn.new_knn expects data.x to have at least one element.',
			.einval)
	}
	if data.y.len == 0 {
		errors.vsl_panic('vls.ml.knn.new_knn expects data.y to have at least one element.',
			.einval)
	}
	mut weights := map[f64]f64{}
	for class in data.y {
		weights[class] = 1.0
	}
	mut knn := KNN{
		data: data
		weights: weights
	}
	data.add_observer(knn) // need to recompute neighbors upon data changes
	knn.update() // compute first neighbors
	return &knn
}

// set_weights will set the weights for the KNN. They default to
// 1.0 for every class when this function is not called.
pub fn (mut knn KNN) set_weights(weights map[f64]f64) {
	mut new_weights := map[f64]f64{}
	for k, v in weights {
		if k !in knn.data.y {
			errors.vsl_panic('KNN.set_weights expects weights (map[f64]f64) to have ' +
				'all its keys present in the KNN\'s classes.', .einval)
		}
		if v == 0.0 {
			errors.vsl_panic('KNN.set_weights expects weights (map[f64]f64) to not have ' +
				'zeroes, as it cannot divide by zero.', .ezerodiv)
		}
		new_weights[k] = v
	}
	for class in knn.data.y {
		if class !in new_weights {
			new_weights[class] = 1.0
		}
	}
	knn.weights = new_weights.clone()
}

// update perform updates after data has been changed (as an Observer)
pub fn (mut knn KNN) update() {
	mut x := knn.data.x.get_deep2()
	knn.neighbors = []&Neighbor{cap: x.len}
	for i := 0; i < x.len; i++ {
		knn.neighbors << &Neighbor{
			point: x[i]
			class: knn.data.y[i]
		}
	}
}

// data needed for KNN.predict
pub struct PredictConfig {
	max_iter int
	k        int
	to_pred  []f64
}

// predict will find the `k` points nearest to the specified `to_pred`.
// If the value of `k` results in a draw - that is, a tie when determining
// the most frequent class in those k nearest neighbors (example:
// class 1 has 10 occurrences, class 2 has 5 and class 3 has 10) -,
// `k` will be decreased until there are no more ties. The worst case
// scenario is `k` ending up as 1. Also, it makes sure that if we do
// have a tie when k = 1, we select the first closest neighbor.
pub fn (mut knn KNN) predict(config PredictConfig) f64 {
	k := config.k
	to_pred := config.to_pred

	if k <= 0 {
		errors.vsl_panic('KNN.predict expects k (int) to be >= 1.', .einval)
	}
	if to_pred.len <= 0 {
		errors.vsl_panic('KNN.predict expects to_pred ([]f64) to have at least 1 element.',
			.einval)
	}
	mut x := knn.data.x.get_deep2()
	for i := 0; i < x.len; i++ {
		knn.neighbors[i].distance = l2_distance_unitary(to_pred, x[i]) /
									knn.weights[knn.neighbors[i].class]
	}
	knn.neighbors.sort(a.distance < b.distance)

	// Break ties
	mut new_k := k
	mut tied := true
	mut most_shown := knn.data.y[0]
	mut iter_number := 0
	for tied {
		if config.max_iter != 0 {
			if iter_number >= config.max_iter {
				break
			}
		}

		tied = false
		mut tmp_neighbors := knn.neighbors[0..new_k].clone()
		mut freq := map[f64]int{}
		for n in tmp_neighbors {
			if n.class !in freq {
				freq[n.class] = 0
			}
			freq[n.class]++
		}
		most_shown = freq.keys()[0]
		mut most_times := 0
		for key, v in freq {
			if v > most_times {
				most_times = v
				most_shown = key
			}
		}
		for key, v in freq {
			if key != most_shown && v == most_times {
				tied = true
			}
		}
		if tied {
			new_k--
			if new_k < 0 {
				break
			}
		} else {
			break
		}

		// Avoids overflow if for some reason this loop
		// runs enough times to make iter_number go above
		// int's max value.
		if config.max_iter != 0 {
			iter_number++
		}
	}

	return most_shown
}
