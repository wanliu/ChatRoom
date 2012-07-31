#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com
#= require_self
#= require ./router_management
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

namespace "ChatRoom", (exports) ->
  exports.template_path = "backbone/templates"

  exports.template = (name) ->
  	JST["#{exports.template_path}/#{name}"]

