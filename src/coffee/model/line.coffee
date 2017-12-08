Text = require './text'


class Line


    constructor: (data, index, @grid) ->
        @init data, index if data


    init: (@data, @index) ->
        @ident = @data[0]
        @base  = new Text @data[1], @
        @trans = new Text @data[2], @


    layout: (widths) ->
        @height = @base.layout widths[1]
        @height = h if (h = @trans.layout widths[2]) > @height
        @height


module.exports = Line