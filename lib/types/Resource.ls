class Resource
  (type, id, attrs, @links, @href) ~>
    # set manually, unlike @links and @href, to trigger the 
    # validation checks and create the @_type etc props.
    [@type, @id, @attrs] = [type, id, attrs];

  removeAttr: (attr) ->
    delete @_attrs[attr]

  attrs:~
    -> @_attrs
    (attrs) ->
      @_validateAttrs(attrs)
      @_attrs = @_coerceAttrs(attrs)

  type:~
    -> @_type
    (type) ->
      @_validateType(type)
      @_type = type;

  id:~
    -> @_id
    (id) -> 
      if id? and /^[A-Za-z0-9\-\_]+$/ != id
        throw new Error("Invalid id") 
      @_id = if id? then String(id).toString! else null

  _coerceAttrs: (attrs) -> attrs # No coercion by default; subclasses may override.

  _validateAttrs: (attrs) ->
    throw new Error("attrs must be an object, even if empty") if typeof! attrs != \Object
    ["id", "type", "href", "links"].forEach(->
      # todo validate nested objs in attrs
      throw new Error(it + " is an ivalid attribute name") if attrs[it]?
    )

  _validateType: (type) ->
    throw new Error("type is required") if not type

module.exports = Resource