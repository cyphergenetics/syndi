/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#ifndef __LIBAUTO_H__
#define __LIBAUTO_H__

/* SYM(x) returns rb_intern(x) */
#define SYM(str) rb_intern(#str)

/* variable for the Auto module */
VALUE mAuto;

/* Init_libauto prototype */
void Init_libauto();

/* Auto's exceptions */
VALUE eLogError;
VALUE eConfigError;
VALUE eDatabaseError;
VALUE ePluginError;

#endif

/* vim: set ts=4 sts=4 sw=4 et cindent: */
