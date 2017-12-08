class Text


    constructor: (value, @line) ->
        @init value if value


    init: (@value) ->
        @value   = @value.replace /<br\s*\/>/g,  '\n'
        @value   = @value.replace /\r\n|\n|\r/g, '\n'
        @words   = @value.split /\s/g
        @letter  = w: 7.22, h: 14
        @padding = 4
        @border  = 1


    layout: (width) ->
        h   = @letter.h                                            # letter height
        nl  = 1                                                    # num lines
        cpl = ((width - @padding - @border) / @letter.w) >> 0      # chars per line
        cc  = 0                                                    # current chars
        i   = 0                                                    # current index in @value
        for word in @words
            if @value[i] == ' '
                ++cc
                ++i
            else if @value[i] == '\n'
                cc = 0
                ++nl
                ++i

            wl = word.length                                       # word length
            if cc + wl > cpl
                ++nl
                cc = wl
            else
                cc += wl

            if wl > cpl
                lpw = (wl / cpl) >> 0                              # lines for this word
                nl += lpw
                cc  = wl - lpw * cpl

            i += wl

        @height = nl * h + @padding + @border




module.exports = Text