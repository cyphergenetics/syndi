/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

// So that the Header will be read correctly.
#define __LOGGER__

#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include <time.h>
#include "auto.h"

VALUE cLogger;

static VALUE logger_init(VALUE self)
{
    rb_iv_set(self, "@status", ID2SYM(SYM(good)));
    rb_funcall(self, SYM(log_directory_check), 0);
    return Qnil;
}

/* @overload error(message)
 *   This will log +message+ as an error.
 *
 *   @param [String] message The error message to be reported.
 *   @return [nil]
 */
static VALUE logger_error(VALUE self, VALUE message)
{
    rb_funcall(self, SYM(log), 2, rb_str_new2("ERROR"), message);
    return Qnil;
}

static VALUE logger_debug(VALUE self, VALUE message)
{
    rb_funcall(self, SYM(log), 2, rb_str_new2("DEBUG"), message);
    return Qnil;
}

static VALUE logger_warning(VALUE self, VALUE message)
{
    rb_funcall(self, SYM(log), 2, rb_str_new2("WARNING"), message);
    return Qnil;
}

static VALUE logger_info(VALUE self, VALUE message)
{
    rb_funcall(self, SYM(log), 2, rb_str_new2("INFO"), message);
    return Qnil;
}

static VALUE logger_log(VALUE self, VALUE type, VALUE message)
{
    // Declaractions and assignments.
    char *log_file_name  = ALLOCA_N(char, MAX_TIME_STRING_LENGTH + 1);
    //
    char *log_time = ALLOCA_N(char, LOG_TIME_FORMAT_LENGTH + 1); // Length of our maximum expected string
    FILE *log_file;
    
    /* 8 is The number of extra characters i.e " ", "[]", "\n" */
    size_t output_string_size = 8 + RSTRING_LEN(type) + RSTRING_LEN(message) + LOG_TIME_FORMAT_LENGTH;

    char *formatted_message = ALLOCA_N(char, ++output_string_size);
    
    time_t current_time;

    // Ensure we have the directory we need.
    rb_funcall(self, SYM(log_directory_check), 0);

    // Get the current time
    time(&current_time);

    // Create the file name
    strftime(log_file_name, 100, LOG_FILE_FORMAT, localtime(&current_time));

    // Open the log file for appending.
    log_file = fopen(log_file_name, "a+");

    // Make sure we can open the file.
    if(log_file == NULL)
    {
        rb_raise(eLogError, "Could not open logfile %s for reading: %d", log_file_name, errno);
        return Qnil;
    }

    // Create the time to log
    strftime(log_time, 100, "%Y-%M-%d %X %z", localtime(&current_time));


    // Create the string to log
    sprintf(formatted_message, "[%s] [%s] %s\n", log_time, RSTRING_PTR(type), RSTRING_PTR(message));

    // Write sting to log and close.
    fputs(formatted_message, log_file);
    fclose(log_file);
    
    return Qnil;
}

/* @overload log_directory_check()
 *   @private
 *
 *   This will check whether the log directory exists, and attempt to create it
 *   in the event that it doesn't.
 *
 *   @raise [LogError] If directory creation fails.
 *   @return [nil]
 */
static VALUE logger_log_directory_check(VALUE self)
{
    int result = mkdir("logs", S_IRWXU);

    // Only raise an error if we fail to create the directory. 
    if(result != 0 && result != EEXIST)
    {
        int error_number = result;
        rb_iv_set(self, "@status", ID2SYM(SYM(bad)));
        rb_raise(eLogError, "Could not create logs/: %s", strerror(error_number));
    }

    return Qnil;
}

void init_auto_logger()
{
    cLogger = rb_define_class_under(mAuto, "Logger", rb_cObject);
    rb_define_method(cLogger, "initialize", logger_init, 0);
    rb_define_method(cLogger, "error", logger_error, 1);
    rb_define_method(cLogger, "debug", logger_debug, 1);
    rb_define_method(cLogger, "warning", logger_warning, 1);
    rb_define_method(cLogger, "info", logger_info, 1);
    rb_define_private_method(cLogger, "log_directory_check", logger_log_directory_check, 0);
    rb_define_private_method(cLogger, "log", logger_log, 2);
}
