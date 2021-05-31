module ml

// Euclidean distance:
import vsl.vmath as math
import vsl.gm
import vsl.la
import vsl.blas.vlas.internal.float64 { l2_distance_unitary }

// KNN is the struct defining a K-Nearest Neighbors classifier.
pub struct KNN {
mut:
	data &Data
pub mut:
	neighbors []&Neighbor
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
		panic('vls.ml.knn.new_knn expects data.x to have at least one element.')
	}
	if data.y.len == 0 {
		panic('vls.ml.knn.new_knn expects data.y to have at least one element.')
	}
	mut knn := KNN{
		data: data
	}
	return &knn
}

// predict will find the `k` points nearest to the specified `to_pred`.
// If the value of `k` results in a draw - that is, a tie when determining
// the most frequent class in those k nearest neighbors (example:
// class 1 has 10 occurrences, class 2 has 5 and class 3 has 10) -,
// `k` will be decreased until there is no more ties. The worst case
// scenario is `k` ending up as 1.
pub fn (mut knn KNN) predict(k int, to_pred []f64) f64 {
	if k <= 0 {
		panic('KNN.predict expects k (int) to be >= 1.')
	}
	if to_pred.len <= 0 {
		panic('KNN.predict expects to_pred ([]f64) to have at least 1 element.')
	}
	mut x := knn.data.x.get_deep2()
	knn.neighbors = []&Neighbor{}
	for i := 0; i < x.len; i++ {
		knn.neighbors << &Neighbor{
			point: x[i]
			class: knn.data.y[i]
			distance: l2_distance_unitary(to_pred, x[i])
		}
	}
	knn.neighbors.sort(a.distance < b.distance)

	// Break ties
	mut new_k := k
	mut tied := true
	mut most_shown := knn.data.y[0]
	for tied {
		tied = false
		mut tmp_neighbors := knn.neighbors.clone()[0..new_k]
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
		} else {
			break
		}
	}

	return most_shown
}
