/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (see LICENSE).
 *
 */

#include "auto.h"

VALUE cLogger;

/* This will print a verbose message to STDOUT if the level of verbosity specified does
 * not exceed the runtime verbosity.
 */
static void log_out2scrn(int type, const char *message, int level)
{
    char *real_type = ALLOCA_N(char, 12);

    if (FIX2INT(rb_gv_get("$VERBOSITY")) < level)
        return;

    switch (type) {
        case TYPE_FATAL:
            real_type = RSTRING_PTR(rb_funcall(rb_str_new2("FATAL ERROR:"), SYM(red), 0));
            break;
        case TYPE_ERROR:
            real_type = RSTRING_PTR(rb_funcall(rb_str_new2("ERROR:"), SYM(red), 0));
            break;
        case TYPE_WARNING:
            real_type = RSTRING_PTR(rb_funcall(rb_str_new2("WARNING:"), SYM(red), 0));
            break;
        case TYPE_INFO:
            real_type = RSTRING_PTR(rb_funcall(rb_str_new2("***"), SYM(green), 0));
            break;
        case TYPE_DEBUG:
            real_type = RSTRING_PTR(rb_funcall(rb_str_new2("==>"), SYM(magenta), 0));
            break;
    }

    printf("%s %s%s", real_type, message, OS_LINE_TERM);
}

/* This will foremost call log_dircheck() to ensure the presence of the log
 * directory, and then it will output the message to today's logfile.
 */
static void log_out2file(const char *type, const char *message)
{
    char *log_file_name = ALLOCA_N(char, MAX_TIME_STRING_LENGTH + 1);
    char *log_time = ALLOCA_N(char, LOG_TIME_FORMAT_LENGTH + 1);
    FILE *log_file;
    
    /* 8 is the number of extra characters i.e " ", "[]", "\n" */
    size_t output_string_size = 8 + strlen(type) + strlen(message) + LOG_TIME_FORMAT_LENGTH;
    char *formatted_message = ALLOCA_N(char, ++output_string_size);
    time_t current_time;

    /* Ensure the log directory's existence. */
    log_dircheck();

    time(&current_time);

    strftime(log_file_name, 100, LOG_FILE_FORMAT, localtime(&current_time));

    log_file = fopen(log_file_name, "a+");
    if (log_file == NULL)
    {
        rb_raise(eLogError, "Could not open logfile %s for reading: %d", log_file_name, errno);
        return;
    }

    /* Fetch the current time and format the message. */
    strftime(log_time, 100, "%Y-%M-%d %X %z", localtime(&current_time));
    sprintf(formatted_message, "[%s] [%s] %s%s", log_time, type, message, OS_LINE_TERM);

    /* Write to file. */
    fputs(formatted_message, log_file);
    fclose(log_file);
}

/* Ensure the existence of the log directory. */
static void log_dircheck()
{
    int result;
    char *dir = ALLOCA_N(char, strlen(AUTO_DIR) + 5);

#ifdef _WIN32
    sprintf(dir, "%s\\logs", AUTO_DIR);
    result = _mkdir(dir);
#else
    sprintf(dir, "%s/logs", AUTO_DIR);
    result = mkdir(dir, S_IRWXU);
#endif

    // Only raise an error if we fail to create the directory. 
    if (result != 0 && errno != EEXIST)
    {
        int error_number = errno;
        rb_raise(eLogError, "Could not create %s: %s", dir, strerror(error_number));
    }
}

/* @overload initialize()
 *   Constructs a new Auto::Logger instance.
 *
 *   @return [Auto::Logger]
 */
VALUE logger_init(VALUE self)
{
    log_dircheck();
    return self;
}

/* @overload fatal(message)
 *   This will log +message+ as a fatal error, as well as kill the program.
 *
 *   @param [String] message The fatal error message to be reported.
 *   @return [nil]
 */
VALUE logger_fatal(VALUE self, VALUE message)
{
    char *msg = RSTRING_PTR(message);
    log_out2file("FATAL ERROR", msg);
    log_out2scrn(TYPE_FATAL, msg, 0);
    rb_exit(1);
    return Qnil;
}

/* @overload error(message)
 *   This will log +message+ as an error, optionally also outputting +backtrace+,
 *   the data for which shall be obtained from Kernel#caller.
 *
 *   @param [String] message The error message to be reported.
 *   @param [Boolean] backtrace Whether to output a backtrace.
 *   @return [nil]
 */
VALUE logger_error(int argc, VALUE argv, VALUE self)
{
    VALUE message;
    VALUE backtrace;
    VALUE bt_bool;

    rb_scan_args(argc, argv, "11", &message, &bt_bool);

    char *msg = RSTRING_PTR(message);
    log_out2file("ERROR", msg);
    log_out2scrn(TYPE_ERROR, msg, 0);

    if (bt_bool == Qtrue)
    {
        backtrace = rb_funcall(rb_cObject, SYM(caller), 0);
        fprintf(stderr, "Backtrace:%s", OS_LINE_TERM);
        rb_funcall(rb_stderr, SYM(puts), 1, backtrace);
    }
    
    return Qnil;
}

/* @overload warn(message)
 *   This will log +message+ as a warning.
 *
 *   @param [String] message The admonitory message to be reported.
 *   @return [nil]
 */
VALUE logger_warn(VALUE self, VALUE message)
{
    char *msg = RSTRING_PTR(message);
    log_out2file("WARNING", msg);
    log_out2scrn(TYPE_WARNING, msg, 0);
    return Qnil;
}

/* @overload info(message)
 *   This will log +message+ as an informative message.
 *
 *   @param [String] message The information to be reported.
 *   @return [nil]
 */
VALUE logger_info(VALUE self, VALUE message)
{
    char *msg = RSTRING_PTR(message);
    log_out2file("INFO", msg);
    log_out2scrn(TYPE_INFO, msg, 0);
    return Qnil;
}

/* @overload verbose(message, level)
 *   Yield a message of verbosity magic. This will execute any block it is
 *   passed (*implicit!*).
 *
 *   @param [String] message The message to be reported.
 *   @param [Integer] level The level of verbosity. We recommend +VSIMPLE+,
 *      +VUSEFUL+, or +VNOISY+.
 *
 *   @return [nil]
 */
VALUE logger_verbose(VALUE self, VALUE message, VALUE level)
{
    char *msg = RSTRING_PTR(message);
    int vrb = FIX2INT(level);

    /* check verbosity */
    if (FIX2INT(rb_gv_get("$VERBOSITY")) < vrb)
        return Qnil;

    /* log */
    log_out2file("DEBUG", msg);
    log_out2scrn(TYPE_DEBUG, msg, vrb);

    /* execute the block */
    if (rb_block_given_p())
        rb_yield(Qnil);

    return Qnil;
}

/* initializes Auto::Logger in Ruby */
void init_auto_logger()
{
    cLogger = rb_define_class_under(mAuto, "Logger", rb_cObject);
    rb_define_method(cLogger, "initialize", logger_init, 0);
    rb_define_method(cLogger, "fatal", logger_fatal, 1);
    rb_define_method(cLogger, "error", logger_error, -1);
    rb_define_method(cLogger, "verbose", logger_verbose, 2);
    rb_define_method(cLogger, "warn", logger_warn, 1);
    rb_define_method(cLogger, "info", logger_info, 1);
}

/* vim: set ts=4 sts=4 sw=4 et cindent: */
