#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

namespace "ChatRoom", (exports) ->
  exports.template_path = "backbone/templates"

  exports.template = (name) ->
  	JST["#{exports.template_path}/#{name}"]