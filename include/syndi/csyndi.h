/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (see LICENSE).
 *
 */

#ifndef __LIBSYNDI_H__
#define __LIBSYNDI_H__

/* SYM(x) returns rb_intern(x) */
#define SYM(str) rb_intern(#str)

/* variable for the Syndi module */
extern VALUE mSyndi;

/* Init_libsyndi prototype */
void Init_libsyndi();

/* Syndi's exceptions */
extern VALUE eLogError;
extern VALUE eConfigError;
extern VALUE eDatabaseError;
extern VALUE ePluginError;

/* line ending */
#ifdef _WIN32
#define OS_LINE_TERM "\r\n"
#else
#define OS_LINE_TERM "\n"
#endif

/* fetch the Syndi directory */
#define SYNDI_DIR RSTRING_PTR(rb_funcall(mSyndi, SYM(app_dir), 0))

#endif

/* vim: set ts=4 sts=4 sw=4 et cindent: */
