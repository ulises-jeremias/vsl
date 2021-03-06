module float32

// ger performs the rank-one operation
//  A += alpha * x * yᵀ
// where A is an m×n dense matrix, x and y are vectors, and alpha is a scalar.
pub fn ger(m u32, n u32, alpha f32, x []f32, incx u32, y []f32, incy u32, mut a []f32, lda u32) {
	if incx == 1 && incy == 1 {
		for i, xv in x[..m] {
			axpy_unitary(alpha * xv, y[..n], mut a[u32(i) * lda..u32(i) * lda + n])
		}
		return
	}

	mut ky := u32(0)
	mut kx := u32(0)
	if int(incy) < 0 {
		ky = u32(-int(n - 1) * int(incy))
	}
	if int(incx) < 0 {
		kx = u32(-int(m - 1) * int(incx))
	}

	mut ix := kx
	for i := 0; i < int(m); i++ {
		axpy_inc(alpha * x[ix], y, mut a[u32(i) * lda..u32(i) * lda + n], n, incy, 1,
			ky, 0)
		ix += incx
	}
}

// gemv_n computes
//  y = alpha * A * x + beta * y
// where A is an m×n dense matrix, x and y are vectors, and alpha and beta are scalars.
pub fn gemv_n(m u32, n u32, alpha f32, a []f32, lda u32, x []f32, incx u32, beta f32, mut y []f32, incy u32) {
	mut kx := u32(0)
	mut ky := u32(0)
	if int(incx) < 0 {
		kx = u32(-int(n - 1) * int(incx))
	}
	if int(incy) < 0 {
		ky = u32(-int(m - 1) * int(incy))
	}

	if incx == 1 && incy == 1 {
		if beta == 0 {
			for i in 0 .. m {
				y[i] = alpha * dot_unitary(a[lda * i..lda * i + n], x)
			}
			return
		}
		for i in 0 .. m {
			y[i] = y[i] * beta + alpha * dot_unitary(a[lda * i..lda * i + n], x)
		}
		return
	}
	mut iy := ky
	if beta == 0 {
		for i in 0 .. m {
			y[iy] = alpha * dot_inc(x, a[lda * i..lda * i + n], n, incx, 1, kx, 0)
			iy += incy
		}
		return
	}
	for i in 0 .. m {
		y[iy] = y[iy] * beta + alpha * dot_inc(x, a[lda * i..lda * i + n], n, incx, 1, kx, 0)
		iy += incy
	}
}

// gemv_t computes
//  y = alpha * Aᵀ * x + beta * y
// where A is an m×n dense matrix, x and y are vectors, and alpha and beta are scalars.
pub fn gemv_t(m u32, n u32, alpha f32, a []f32, lda u32, x []f32, incx u32, beta f32, mut y []f32, incy u32) {
	mut kx := u32(0)
	mut ky := u32(0)
	if int(incx) < 0 {
		kx = u32(-int(m - 1) * int(incx))
	}
	if int(incy) < 0 {
		ky = u32(-int(n - 1) * int(incy))
	}
	if beta == 0 {
		// beta == 0 is special-cased to memclear
		if incy == 1 {
			for i in 0 .. y.len {
				y[i] = 0
			}
		} else {
			mut iy := ky
			for i := 0; i < n; i++ {
				y[iy] = 0
				iy += incy
			}
		}
	} else if int(incy) < 0 {
		scal_inc(beta, mut y, n, u32(int(-incy)))
	} else if incy == 1 {
		scal_unitary(beta, mut y[..n])
	} else {
		scal_inc(beta, mut y, n, incy)
	}

	if incx == 1 && incy == 1 {
		for i in 0 .. m {
			axpy_unitary_to(mut y, alpha * x[i], a[lda * i..lda * i + n], y)
		}
		return
	}
	mut ix := kx
	for i in 0 .. m {
		axpy_inc(alpha * x[ix], a[lda * i..lda * i + n], mut y, n, 1, incy, 0, ky)
		ix += incx
	}
}
