// Copyright (c) 2019 Ulises Jeremias Cornejo Fandos. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

module poly

import math

const(
        radix = 2
        radix2 = (radix*radix)
)

pub fn eval(c []f64, x f64) f64 {
        if c.len == 0 {
                panic('coeficients can not be empty')
        }

        len := c.len
        mut ans := c[len-1]

        for e in c[..len-1] {
                ans = e + x * ans
        }

        return ans
}

pub fn eval_derivs(c []f64, x f64, lenres u64) []f64 {
        mut res := []f64
        lenc := c.len
        
        mut i := 0
        mut n := 0
        mut nmax := 0

        for ; i < lenres; i++ {
                if n < lenc {
                        res << c[lenc - 1]
                        nmax = n
                        n++
                }
                else {
                        res << f64(0)
                }
        }

        for i = 0; i < lenc - 1; i++ {
                k := (lenc - 1) - i
                res[0] = (x * res[0]) + c[k - 1]
                lmax := if nmax < k { nmax } else { k - 1 }
                for l := 1; l <= lmax; l++ {
                        res[l] = (x * res[l]) + res[l - 1]
                }
        }

        mut f := 1.0
        for i = 2; i <= nmax; i++ {
                f *= i
                res[i] *= f
        }

        return res
}

pub fn solve_quadratic(a, b, c f64) []f64 {
        /* Handle linear case */
        if a == 0 {
                if b == 0 {
                        return []
                }
                else {
                        return [-c / b]
                }
        }

        disc := b * b - f64(4) * a * c
        
        if disc > 0 {
                if b == 0 {
                        r := math.sqrt(-c / a)
                        return [-r, r]
                }
                else {
                        sgnb := if b > 0 { 1 } else { -1 }
                        temp := -0.5 * (b + f64(sgnb) * math.sqrt(disc))
                        r1 := temp / a 
                        r2 := c / temp
                
                        return if (r1 < r2) {
                                [ r1, r2 ] 
                        } 
                        else {
                                [ r2, r1 ] 
                        }
                }
        }
        else if disc == 0 {
                return [ -0.5 * b / a, -0.5 * b / a ] 
        }
        else {
                return []
        }
}

pub fn solve_cubic(a, b, c f64) []f64 {
        q_ := (a * a - 3.0 * b)
        r_ := (2.0 * a * a * a - 9.0 * a * b + 27.0 * c)

        q := q_ / 9.0
        r := r_ / 54.0

        q3 := q * q * q
        r2 := r * r

        cr2 := 729.0 * r_ * r_
        cq3 := 2916.0 * q_ * q_ * q_

        if r == 0.0 && q == 0.0 {
                return [ -a / 3.0, -a / 3.0, -a / 3.0 ] 
        }
        else if cr2 == cq3 {
                /* this test is actually r2 == q3, written in a form suitable
                        for exact computation with integers */

                /* Due to finite precision some double roots may be missed, and
                        considered to be a pair of complex roots z = x +/- epsilon i
                        close to the real axis. */

                sqrt_q := math.sqrt(q)

                if r > 0.0 {
                        return [ -2.0 * sqrt_q  - a / 3.0, sqrt_q - a / 3.0, sqrt_q - a / 3.0 ]
                }
                else {
                        return [ -sqrt_q  - a / 3.0, -sqrt_q - a / 3.0, 2.0 * sqrt_q - a / 3.0 ]
                }
        }
        else if r2 < q3 {
                sgnr := if r >= 0.0 { 1.0 } else { -1.0 }
                ratio := sgnr * math.sqrt(r2 / q3)
                theta := math.acos(ratio)
                norm := f64(-2.0 * math.sqrt(q))
                
                mut x0 := norm * math.cos(theta / 3.0) - a / 3.0
                mut x1 := norm * math.cos((theta + 2.0 * math.pi) / 3.0) - a / 3.0
                mut x2 := norm * math.cos((theta - 2.0 * math.pi) / 3.0) - a / 3.0
                
                /* TODO: Sort x0, x1, x2 into increasing order */

                return [ x0, x1, x2 ]
        }
        else {
                sgnr := if r >= 0.0 { 1.0 } else { -1.0 }
                A := -sgnr * math.pow(math.abs(r) + math.sqrt(r2 - q3), 1.0/3.0)
                B := q / A
                return [ A + B - a / 3 ]
        }
}

pub fn companion_matrix(a []f64) [][]f64 {
        nc := a.len - 1

        mut cm := [[]f64].repeat(nc)
        mut i := 0
	for ; i < nc; i++ {
		cm[i] = [f64(0.0)].repeat(nc)
	}

        for i = 0; i < nc; i++ {
                for j := 0; j < nc; j++ {
                        cm[i][j] = f64(0.0)
                }
        }

        for i = 1; i < nc; i++ {
                cm[i][i - 1] = f64(1.0)
        }

        for i = 0; i < nc; i++ {
                cm[i][nc - 1] = -a[i] / a[nc]
        }

        return cm
}

pub fn balance_companion_matrix(cm [][]f64) [][]f64 {
        nc := cm.len
        mut m := cm
        mut not_converged := true

        mut row_norm := f64(0)
        mut col_norm := f64(0)

        for not_converged {
                not_converged = false

                for i := 0; i < nc; i++ {
                        /* column norm, excluding the diagonal */

                        if i != nc - 1 {
                                col_norm = math.abs(m[i + 1][i])
                        }
                        else {
                                col_norm = 0.0

                                for j := 0; j < nc - 1; j++ {
                                        col_norm += math.abs(m[j][nc - 1])
                                }
                        }

                        /* row norm, excluding the diagonal */

                        if i == 0 {
                                row_norm = math.abs(m[0][nc - 1])
                        }
                        else if i == nc - 1 {
                                row_norm = math.abs(m[i][i - 1])
                        }
                        else {
                                row_norm = (math.abs(m[i][i - 1]) + math.abs(m[i][nc - 1]))
                        }

                        if col_norm == 0.0 || row_norm == 0.0 {
                                continue
                        }

                        mut g := row_norm / radix
                        mut f := 1.0
                        mut s := col_norm + row_norm

                        for col_norm < g {
                                f *= radix
                                col_norm *= radix2
                        }

                        g = row_norm * radix

                        for col_norm > g {
                                f /= radix
                                col_norm /= radix2
                        }

                        if (row_norm + col_norm) < 0.95 * s * f {
                                not_converged = true

                                g = 1.0 / f

                                if i == 0 {
                                        m[0][nc - 1] *= g
                                }
                                else {
                                        m[i][i - 1] *= g
                                        m[i][nc - 1] *= g
                                }

                                if i == nc - 1 {
                                        for j := 0; j < nc; j++ {
                                                m[j][i] *= f
                                        }
                                }
                                else {
                                        m[i + 1][i] *= f
                                }
                        }
                }
        }

        return m
}