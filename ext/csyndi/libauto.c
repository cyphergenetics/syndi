/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (see LICENSE).
 *
 */

#include "syndi.h"

VALUE mSyndi;
VALUE eLogError;
VALUE ePluginError;
VALUE eConfigError;
VALUE eDatabaseError;

/* initialize exceptions */
void initialize_exceptions()
{
    eLogError = rb_define_class_under(mSyndi, "LogError", rb_eStandardError);
    ePluginError = rb_define_class_under(mSyndi, "PluginError", rb_eStandardError);
    eConfigError = rb_define_class_under(mSyndi, "ConfigError", rb_eStandardError);
    eDatabaseError = rb_define_class_under(mSyndi, "DatabaseError", rb_eStandardError);
}

/* initialize Syndi module */
void Init_csyndi()
{
    mSyndi = rb_define_module("Syndi");
    /* initialize exceptions */
    initialize_exceptions();
    /* initialize Syndi::Logger */
    init_syndi_logger();
    /* extend Ruby stdlib Integer */
    init_integer();
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
