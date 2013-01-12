/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#ifndef __AUTO_H__

/* SYM(x) returns rb_intern(x) */
#define SYM(str) rb_intern(#str)

/* variable for the Auto module */
VALUE mAuto;

void Init_auto();

#endif // __AUTO_H__

/* vim: set ts=4 sts=4 sw=4 et cindent: */
