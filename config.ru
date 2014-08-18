#!/usr/bin/env rackup
#\ -o 0.0.0.0 -p 60080
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require ::File.dirname(__FILE__) + '/config/boot.rb'
run Padrino.application
