/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#include "auto.h"

/* initialize exceptions */
void initialize_exceptions()
{
    eLogError = rb_define_class("LogError", rb_eStandardError);
    ePluginError = rb_define_class("PluginError", rb_eStandardError);
    eConfigError = rb_define_class("ConfigError", rb_eStandardError);
    eDatabaseError = rb_define_class("DatabaseError", rb_eStandardError);
}

/* initialize Auto module */
void Init_libauto()
{
    mAuto = rb_define_module("Auto");
    /* initialize exceptions */
    initialize_exceptions();
    /* initialize Auto::Logger */
    init_auto_logger();
    /* extend Ruby stdlib Integer */
    init_integer();
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
