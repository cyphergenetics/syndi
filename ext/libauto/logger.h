/*
 * Copyright (c) 2013, Autumn Perrault, et al. 
 * All rights reserved.
 * This free software is distributed under the FreeBSD license (LICENSE.md).
 *
 */

#ifndef __AUTO_LOGGER_H__
#define __AUTO_LOGGER_H__

// Set format based on target OS.
#ifdef WIN32
#define LOG_FILE_FORMAT "logs\\%Y%m%d.log"
#else
#define LOG_FILE_FORMAT "logs/%Y%m%d.log"
#endif

// This is based on the desired output give or take a few characters.
#define MAX_TIME_STRING_LENGTH 18

// ("YYYY-MM-DD HH:MM:SS +ZZZZ") "YEAR-MONTH-DAY HOUR:MINUTES:SECONDS UTC_OFFSET"
#define LOG_TIME_FORMAT_LENGTH 25

extern VALUE cLogger;

VALUE logger_init(VALUE self);

VALUE logger_error(VALUE self, VALUE message);

VALUE logger_debug(VALUE self, VALUE message);

VALUE logger_warning(VALUE self, VALUE message);

VALUE logger_info(VALUE self, VALUE message);

VALUE logger_log(VALUE self, VALUE type, VALUE message);

VALUE logger_log_directory_check(VALUE self);

void init_auto_logger();


#endif 
// __AUTO_LOGGER_H__
