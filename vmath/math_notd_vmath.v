module vmath

import math
import math.factorial

// Returns the absolute value.
[inline]
pub fn abs(a f64) f64 {
	return math.fabs(a)
}

// acos calculates inverse cosine (arccosine).
[inline]
pub fn acos(a f64) f64 {
	return math.acos(a)
}

// asin calculates inverse sine (arcsine).
[inline]
pub fn asin(a f64) f64 {
	return math.asin(a)
}

// atan calculates inverse tangent (arctangent).
[inline]
pub fn atan(a f64) f64 {
	return math.atan(a)
}

// atan2 calculates inverse tangent with two arguments, returns the angle between the X axis and the point.
[inline]
pub fn atan2(a f64, b f64) f64 {
	return math.atan2(a, b)
}

// cbrt calculates cubic root.
[inline]
pub fn cbrt(a f64) f64 {
	return math.cbrt(a)
}

// ceil returns the nearest f64 greater or equal to the provided value.
[inline]
pub fn ceil(a f64) f64 {
	return math.ceil(a)
}

// copysign returns a value with the magnitude of x and the sign of y
[inline]
pub fn copysign(x f64, y f64) f64 {
	return math.copysign(x, y)
}

// cos calculates cosine.
[inline]
pub fn cos(a f64) f64 {
	return math.cos(a)
}

// cosh calculates hyperbolic cosine.
[inline]
pub fn cosh(a f64) f64 {
	return math.cosh(a)
}

// degrees convert from degrees to radians.
[inline]
pub fn degrees(radians f64) f64 {
	return math.degrees(radians)
}

// digits returns an array of the digits of n in the given base.
[inline]
pub fn digits(n int, base int) []int {
	return math.digits(n, base)
}

// exp calculates exponent of the number (math.pow(math.E, a)).
[inline]
pub fn exp(a f64) f64 {
	return math.exp(a)
}

// erf computes the error function value
[inline]
pub fn erf(a f64) f64 {
	return math.erf(a)
}

// erfc computes the complementary error function value
[inline]
pub fn erfc(a f64) f64 {
	return math.erfc(a)
}

// exp2 returns the base-2 exponential function of a (math.pow(2, a)).
[inline]
pub fn exp2(a f64) f64 {
	return math.exp2(a)
}

// factorial calculates the factorial of the provided value.
[inline]
pub fn factorial(n f64) f64 {
	return factorial.factorial(n)
}

// log_factorial calculates the log-factorial of the provided value.
[inline]
pub fn log_factorial(n f64) f64 {
	return factorial.log_factorial(n)
}

// floor returns the nearest f64 lower or equal of the provided value.
[inline]
pub fn floor(a f64) f64 {
	return math.floor(a)
}

[inline]
pub fn fmod(x f64, y f64) f64 {
	return math.fmod(x, y)
}

// gamma computes the gamma function value
[inline]
pub fn gamma(a f64) f64 {
	return math.gamma(a)
}

// gcd calculates greatest common (positive) divisor (or zero if a and b are both zero).
[inline]
pub fn gcd(a i64, b i64) i64 {
	return math.gcd(a, b)
}

// Returns hypotenuse of a right triangle.
[inline]
pub fn hypot(a f64, b f64) f64 {
	return math.hypot(a, b)
}

// lcm calculates least common (non-negative) multiple.
[inline]
pub fn lcm(a i64, b i64) i64 {
	return math.lcm(a, b)
}

// log calculates natural (base-e) logarithm of the provided value.
[inline]
pub fn log(a f64) f64 {
	return math.log(a)
}

// log2 calculates base-2 logarithm of the provided value.
[inline]
pub fn log2(a f64) f64 {
	return math.log2(a)
}

// log10 calculates the common (base-10) logarithm of the provided value.
[inline]
pub fn log10(a f64) f64 {
	return math.log10(a)
}

// log_gamma computes the log-gamma function value
[inline]
pub fn log_gamma(a f64) f64 {
	return math.log_gamma(a)
}

// log_n calculates base-N logarithm of the provided value.
[inline]
pub fn log_n(a f64, b f64) f64 {
	return math.log_n(a, b)
}

// max returns the maximum value of the two provided.
[inline]
pub fn max(a f64, b f64) f64 {
	return math.max(a, b)
}

// min returns the minimum value of the two provided.
[inline]
pub fn min(a f64, b f64) f64 {
	return math.min(a, b)
}

// mod returns the floating-point remainder of number / denom (rounded towards zero):
[inline]
pub fn mod(a f64, b f64) f64 {
	return math.fmod(a, b)
}

// pow returns base raised to the provided power.
[inline]
pub fn pow(a f64, b f64) f64 {
	return math.pow(a, b)
}

// radians convert from radians to degrees.
[inline]
pub fn radians(degrees f64) f64 {
	return math.radians(degrees)
}

// round returns the integer nearest to the provided value.
[inline]
pub fn round(f f64) f64 {
	return math.round(f)
}

// signbit returns a value with the boolean representation of the sign for x
[inline]
pub fn signbit(x f64) bool {
	return signbit(x)
}

// sin calculates sine.
[inline]
pub fn sin(a f64) f64 {
	return math.sin(a)
}

// sinh calculates hyperbolic sine.
[inline]
pub fn sinh(a f64) f64 {
	return math.sinh(a)
}

// sqrt calculates square-root of the provided value.
[inline]
pub fn sqrt(a f64) f64 {
	return math.sqrt(a)
}

// tan calculates tangent.
[inline]
pub fn tan(a f64) f64 {
	return math.tan(a)
}

// tanh calculates hyperbolic tangent.
[inline]
pub fn tanh(a f64) f64 {
	return math.tanh(a)
}

// trunc rounds a toward zero, returning the nearest integral value that is not
// larger in magnitude than a.
[inline]
pub fn trunc(a f64) f64 {
	return math.trunc(a)
}
