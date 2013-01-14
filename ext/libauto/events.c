/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#include "auto.h"

VALUE cEvents;

static VALUE events_initialize(VALUE self)
{
    rb_iv_set(self, "@events", rb_hash_new());
    rb_iv_set(self, "@threads", rb_ary_new());
    return self;
}

static VALUE events_on(VALUE self, VALUE event, VALUE rbpriority, VALUE prc)
{
    int i, priority;

    // convert the priority to an integer
    priority = FIX2INT(rbpriority);

    // priority must be 1-5
    if (priority <= 1 || priority >= 5)
        return Qnil;

    // if the event does not exist, create it
    if (rb_hash_aref(rb_iv_get(self, "@events"), event) == Qnil) {
        rb_hash_set(rb_iv_get(self, "@events"), event, rb_hash_new());
        for (i = 1; i <= 5; ++i)
            rb_hash_set(rb_hash_aref(rb_iv_get(self, "@events"), event), INT2FIX(i), rb_hash_new());
    }

    

    return Qnil; 
}

/* initialize Auto::Events */
static void init_events()
{
    cEvents = rb_define_class_under(mAuto, "Events", SYM(Auto::API::Object));
    rb_define_method(cEvents, "initialize", events_initialize, 0);
    rb_define_method(cEvents, "on", events_on, 3);
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
