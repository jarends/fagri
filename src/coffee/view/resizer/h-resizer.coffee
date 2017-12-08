EMap      = require 'emap'
ViewNode  = require 'two-trees/src/js/view-node'
getBounds = require 'mycs/js/get-bounds'




#     0000000  00000000  000      000    
#    000       000       000      000    
#    000       0000000   000      000    
#    000       000       000      000    
#     0000000  00000000  0000000  0000000

class Cell


    constructor: (@style, @row) ->
        ws    = @style.width
        ms    = @style.minWidth
        @w0   = 0
        @w1   = 0
        @m    = 0
        @type = null

        if r = /(\d*(.\d+)*)%$/.exec ws
            @w0      = parseFloat r[1]
            @type    = 0
            @row.tp += @w0

        else if r = /(\d*(.\d+)*)px$/.exec ws
            @w1      = parseFloat r[1]
            @type    = 1
            @row.ta += @w1


        if r = /(\d*(.\d+)*)px$/.exec ms
            @m = parseFloat r[1]

        @row.tm += @m
        if @type == 0 then @row.tpm += @m else @row.tam += @m


    update: (w1, width) ->
        @w0 = w1 / width * 100
        @w1 = w1
        if @type == 0
            @style.width = @w0 + '%'
        else if @type == 1
            @style.width = @w1 + 'px'
        @




#    00000000    0000000   000   000
#    000   000  000   000  000 0 000
#    0000000    000   000  000000000
#    000   000  000   000  000   000
#    000   000   0000000   00     00

class Row


    constructor: (@width, @styles) ->
        @ta  = 0
        @tp  = 0
        @tm  = 0
        @tam = 0
        @tpm = 0
        @cells = []

        @cells.push new Cell style, @ for style in @styles

        if @tm > @width
            null #TODO: implement later

        else if @ta > @width
            null #TODO: implement later

        else
            rest = @width - @ta
            if @tpm > rest
                null #TODO: implement later

            else
                tp = rest / @width * 100
                for cell in @cells
                    if cell.type == 0
                        cell.w0 = tp * cell.w0 / @tp
                        cell.w1 = @width * cell.w0 / 100
                        cell.style.width = cell.w0 + '%'
                    else
                        cell.w0 = cell.w1 / @width * 100




#    000   000          00000000   00000000   0000000  000  0000000  00000000  00000000 
#    000   000          000   000  000       000       000     000   000       000   000
#    000000000  000000  0000000    0000000   0000000   000    000    0000000   0000000  
#    000   000          000   000  000            000  000   000     000       000   000
#    000   000          000   000  00000000  0000000   000  0000000  00000000  000   000

class HResizer extends ViewNode


    @getStyles = (name) ->
        sheets = document.styleSheets
        styles = []
        for i in [0 ... sheets.length]
            sheet = sheets[i]
            rules = sheet.cssRules
            for j in [0 ... rules.length]
                rule   = rules[j]
                result = new RegExp("\\.#{name}-(\\d+)").exec rule.selectorText
                styles[result[1]] = rule.style if result
        styles


    @layout = (width, name) ->
        new Row width, @getStyles name




    init: () ->
        @emap = new EMap()


    startResize: (event) =>
        event.preventDefault()
        document.body.classList.add 'h-resize-global'
        @emap.map document, "mousemove", @doResize,  @
        @emap.map document, "mouseup",   @endResize, @

        @xStart  = event.pageX
        @bounds  = getBounds @parent.view
        @row     = HResizer.layout @bounds.width, @cfg.selector
        count    = 0
        children = @parent.children
        index    = children.indexOf @

        for child, i in children
            if not (child instanceof HResizer)
                if i == index - 1
                    @cellA  = @row.cells[count]
                    @wA     = @cellA.w1
                else if i == index + 1
                    @cellB  = @row.cells[count]
                    @wB     = @cellB.w1
                ++count
        @


    doResize: (event) ->
        event.preventDefault()

        d  = event.pageX - @xStart
        wA = @wA + d
        wB = @wB - d

        if wA < @cellA.m
            d  = @cellA.m - @wA
            wA = @cellA.m
            wB = @wB - d

        else if wB < @cellB.m
            d  = @wB - @cellB.m
            wB = @cellB.m
            wA = @wA + d

        @cellA.update wA, @bounds.width
        @cellB.update wB, @bounds.width

        widths = []
        widths.push cell.w1 for cell in @row.cells
        @ctx.dispatch 'HResizer.update-' + @cfg.selector, widths
        @


    endResize: (event) ->
        document.body.classList.remove 'h-resize-global'
        @emap.unmap document, "mousemove", @doResize,  @
        @emap.unmap document, "mouseup",   @endResize, @
        @


    render: () ->
        tag:         'div'
        className:   'resizer h-resizer'
        onMousedown: @startResize


module.exports = HResizer