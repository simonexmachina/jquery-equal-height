$.fn.equalHeight = (option) ->
  return this.each ->
    $this = $(this)
    options = typeof option == 'object' && option
    unless obj = $this.data('equalHeightObj')
      $this.data 'equalHeightObj', obj = new EqualHeight(this, options)
    if typeof option == 'string'
      obj[option]()

$.fn.equalHeight.defaults = 
  prop: 'min-height'
  method: 'outerHeight'
  columns: null

class EqualHeight
  constructor: (el, options)->
    @$el = $(el)
    if typeof options == 'string'
      options.selector = options
    @options = $.extend {}, $.fn.equalHeight.defaults, options
    @refresh()
  refresh: ->
    $els = @$el.find(@options.selector)
    start = 0
    len = @options.columns || $els.length
    while true
      end = start + len
      $slice = $els.slice(start, end)
      if $slice.length
        maxHeight = 0
        method = @options.method
        $slice.each ->
          $el = $(this)
          height = $el[method].call $el
          maxHeight = height if height > maxHeight
        $slice.css @options.prop, maxHeight
        start += len
        end += len
      else
        break

$(window).on 'load', ->
  $('[data-equal-height]').each ->
    if selector = $(this).data('equalHeight')
      data = selector: selector, columns: $(this).data('equalHeightColumns')
    $(this).equalHeight data