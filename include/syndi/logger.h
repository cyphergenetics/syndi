/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (see LICENSE).
 *
 */

#ifndef __SYNDI_LOGGER_H__
#define __SYNDI_LOGGER_H__

#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include <time.h>
#ifndef _WIN32
#include <unistd.h>
#endif

/* Set format based on target OS. */
#ifdef _WIN32
#define LOG_FILE_FORMAT "logs\\%Y%m%d.log"
#else
#define LOG_FILE_FORMAT "logs/%Y%m%d.log"
#endif

/* This is based on the desired output give or take a few characters. */
#define MAX_TIME_STRING_LENGTH 18

/* ("YYYY-MM-DD HH:MM:SS +ZZZZ") "YEAR-MONTH-DAY HOUR:MINUTES:SECONDS UTC_OFFSET" */
#define LOG_TIME_FORMAT_LENGTH 25

extern VALUE cLogger;
void init_syndi_logger();

/* Ruby-accessible methods */
static VALUE logger_init(VALUE self);

static VALUE logger_fatal(VALUE self, VALUE message);
static VALUE logger_error(int argc, VALUE *argv, VALUE message);
static VALUE logger_verbose(VALUE self, VALUE message, VALUE level);
static VALUE logger_warning(VALUE self, VALUE message);
static VALUE logger_debug(VALUE self, VALUE message);
static VALUE logger_deprecate(VALUE self, VALUE message);
static VALUE logger_info(VALUE self, VALUE message);

/* internal functions */
static void log_out2scrn(int type, const char *message, int level);
static void log_out2file(const char *type, const char *message);
static void log_dircheck();

/* symbolic constants for event types */
#define TYPE_FATAL      0
#define TYPE_ERROR      1
#define TYPE_WARNING    2
#define TYPE_INFO       3
#define TYPE_DEBUG      4

#endif 
