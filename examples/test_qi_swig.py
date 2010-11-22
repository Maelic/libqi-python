#!/usr/bin/env python
##
## qic.py
## Login : <ctaf42@cgestes-de2>
## Started on  Fri Nov 19 20:21:20 2010 Cedric GESTES
## $Id$
##
## Author(s):
##  - Cedric GESTES <gestes@aldebaran-robotics.com>
##
## Copyright (C) 2010 Cedric GESTES
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

import _qi
import sys

def test_1():
    client = _qi.qi_client_create("simplecli", sys.argv[1])
    msg = _qi.qi_message_create()
    ret = _qi.qi_message_create()

    _qi.qi_message_write_string(msg, "master.locateService::s:s");
    _qi.qi_message_write_string(msg, "master.listServices::{ss}:");

    _qi.qi_client_call(client, "master.locateService::s:s", msg, ret);

    result = _qi.qi_message_read_string(ret);
    print "locate returned: ", result

def test_2():
    client = _qi.qi_client_create("simplecli", sys.argv[1])
    msg = _qi.qi_message_create()
    ret = _qi.qi_message_create()

    _qi.qi_message_write_string(msg, "master.listServices::{ss}:");
    #_qi.qi_message_write_string(msg, "master.locateService::s:s");

    _qi.qi_client_call(client, "master.listServices::{ss}:", msg, ret);

    result = _qi.qi_message_read_int(ret);
    print "result:", result
    for i in range(result):
        key = _qi.qi_message_read_string(ret);
        value = _qi.qi_message_read_string(ret);
        print "k: %s, v: %s" % (key, value)

test_1()
test_2()
