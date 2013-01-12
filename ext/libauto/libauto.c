/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#include "ruby.h"
#include "auto.h"

/* initialize Auto module */
void Init_libauto()
{
    mAuto = rb_define_module("Auto");
    /* initialize Auto::Logger */
    Init_logger();
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
