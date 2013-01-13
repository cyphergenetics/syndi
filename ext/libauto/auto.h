/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#ifndef AUTO_H

/* include the Ruby header */
#include "ruby.h"

/* SYM(x) returns rb_intern(x) */
#define SYM(str) rb_intern(#str)

/* variable for the Auto module */
VALUE mAuto;

/* prototypes */
void Init_auto();

/* Auto's exceptions */
VALUE eLogError;

/* include other headers */
#include "logger.h"

#endif // AUTO_H

/* vim: set ts=4 sts=4 sw=4 et cindent: */
