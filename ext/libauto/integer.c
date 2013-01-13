/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#include "auto.h"

// SWAR algorithm for finding the number of set bits.
VALUE swar_bits_set(VALUE self)
{
	long l = NUM2LONG(self);
	l -= ((l >> 1) & 0x55555555);
	l = (l & 0x33333333) + ((l >> 2) & 0x33333333);
	return INT2FIX((((l + (l >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24);
}

// c = PI(n-1, i=0, (b^2^i)) % m
VALUE modular_power(VALUE self, VALUE exponent, VALUE modulus)
{
	// I need to figure out how this works to see which long long i can take out.
	long long result = 1;
	long long base = NUM2INT(self);
	long long exp = NUM2INT(exponent);
	long long modulo = NUM2INT(modulus);

	if(modulo == 0)
	{
		// Avoid divide by zero
		return Qnil;
	}

	while(exp > 0)
	{	
		if(exp & 1)
			result = (result * base) % modulo;
		exp >>= 1;
		base = (base * base) % modulo;
	}

	// If the numbers become an issue we will switch to INT2NUM to allow for Bignums
	return INT2NUM(result);
}

/* initialize extension of Ruby stdlib Integer */
void init_integer()
{
	rb_define_method(rb_cInteger, "bits_set", swar_bits_set, 0);
	rb_define_method(rb_cInteger, "mod_exp", modular_power, 2);
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */

