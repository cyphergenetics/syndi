/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#ifndef WIN32
#include <pthread.h>
#endif

extern VALUE cEvents;

static VALUE events_initialize(VALUE self);
static VALUE events_on(VALUE self, VALUE event, VALUE rbpriority, VALUE prc);

static void init_events();

/* vim: set ts=4 sts=4 sw=4 et cindent: */
