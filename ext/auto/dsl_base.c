/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */
#include "ruby.h"

VALUE mAuto;
VALUE mDSL;
VALUE mBase;

static VALUE clock_do(int argc, VALUE *argv, VALUE self)
{
    return rb_funcall2(rb_funcall(rb_funcall(rb_gv_get("$m"), rb_intern("clock"), 0), rb_intern("spawn"), 0), argc, argv);
}

static VALUE clock_stop(int argc, VALUE *argv, VALUE self)
{
    return rb_funcall2(rb_funcall(rb_funcall(rb_gv_get("$m"), rb_intern("clock"), 0), rb_intern("del"), 0), argc, argc);
}

static VALUE undo_on(VALUE self, VALUE sys, VALUE hook)
{
    if(sys == rb_intern("auto"))
    {
        return rb_funcall(rb_funcall(rb_gv_get("$m"), rb_intern("events"), 0) rb_intern("del"), 1, hook);
    }
    else
    {
        if(rb_funcall(rb_gv_get("$m"), rb_intern("respond_to?"), 1, sys) == Qtrue)
        {
            return rb_funcall(rb_funcall(rb_funcall(rb_gv_get("$m"), sys, 0), rb_intern("events"), 0), rb_intern("del"), 1, hook);
        }
        else
        {
            return Qnil;
        }
    }
}

void Init_dsl_base()
{
    mAuto = rb_define_module("Auto");
    mDSL  = rb_define_module_under(mAuto, "DSL");
    mBase = rb_define_module_under(mDSL, "Base");
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
