export class Regularity
  #regularity error class
  class RegErr extends Error then (@message) ~> @name = @@name

  #constants
  const
    patterns =
      digit:        '[0-9]'
      lowercase:    '[a-z]'
      uppercase:    '[A-Z]'
      letter:       '[A-Za-z]'
      alphanumeric: '[A-Za-z0-9]'
      whitespace:   \\s
      tab:          \\t
      space:        ' '

    escaped-chars = <[* . ? ^ + $ | ( ) { }]>

  #constructor
  ~> @str = ''

  #public
  start-with: (...args) ->
    throw RegErr '.start-with called multiple times' unless @str is ''
    write.call this, "^#{interpret ...args}"

  then: (...args) -> write.call this, interpret ...args
  end-with: (...args) -> write.call this, "#{interpret ...args}$"
  maybe: (...args) -> write.call this, "#{interpret ...args}?"
  one-of: -> write.call this, "[#{it.map escape .join \|}]"
  zero-or-more: -> write.call this, "#{interpret it}*"
  one-or-mode: -> write.call this, "#{interpret it}+"
  between: ([x, y]:range, pattern) ->
    throw RegErr 'must provide an array of 2 integers' unless range.length is 2
    write.call this, "#{interpret pattern}{#x,#y}"

  regex: -> RegExp @str
  to-string: -> "#<Regularity regex=/#{@str}/>"

  #private
  write = -> @str ++= it; @

  interpret = (...args) ->
    switch args.length
      | 2 => numbered-constraint ...args
      | 1 => patterned-constraint ...args
      | _ => throw RegErr 'must provide one or two argument(s)'

  numbered-constraint = (count, type) ->
    pattern = patterned-constraint type
    throw RegErr 'Unrecognized pattern' if pattern is '' or pattern is null
    "#pattern{#count}"

  patterned-constraint = -> escape translate it
  singularize = -> it.to-string! - /s$/
  escape = -> it.to-string!replace /.+/ -> if it in escaped-chars then "\\#it" else it
  translate = -> patterns[singularize it] or it
