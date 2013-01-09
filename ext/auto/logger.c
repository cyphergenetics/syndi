/*
 * Auto 4
 * Copyright (c) 2013, Auto Project. All rights reserved.
 * This is free software distributed under the terms of the FreeBSD license (see LICENSE.md).
 *
 */

#include <ruby.h>

VALUE mAuto;
VALUE cLogger;

VALUE generic_eLogError;

/* Check for the existence of logs/, and create the directory if it does not
 * exist.
 */
static VALUE logger_log_directory_check(VALUE self)
{
    struct stat st;

    // check foremost whether the directory exists
    if (stat("logs", &st) != 0) {
        
        // create the directory
        status = mkdir("logs", 0700);

        /* if the creation failed, set @status to bad
         * and raise a LogError exception */
        if (status == -1) {
            rb_ivar_set(self, "@status", ID2SYM(rb_intern("bad")));
            rb_raise(generic_eLogError, "Could not create the log directory logs/");
            return Qnil;
        }

    }
    
    return self;
}

/* Initialize the Auto::Logger class. */
void Init_logger()
{
    mAuto = rb_define_module("Auto");
    cLogger = rb_define_class("Logger", mAuto);
    generic_eLogError = rb_define_class_under(cLogger, "Error", rb_eStandardError);
    rb_define_private_method(cLogger, "log_directory_check", logger_log_directory_check, 0);
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
