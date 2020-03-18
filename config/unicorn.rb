# Copyright (c) 2015 - 2020 Ana-Cristina Turlea <turleaana@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#Set the working application directory
# working_directory "/path/to/your/app"
APP_NAME = "CourseEval"
ROOT_PATH = "/home/rails_course/#{APP_NAME}"

working_directory "#{ROOT_PATH}/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{ROOT_PATH}/pid/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "#{ROOT_PATH}/log/unicorn.log"
stdout_path "#{ROOT_PATH}/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.[#{APP_NAME}].sock"
listen "/tmp/unicorn.#{APP_NAME}.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
