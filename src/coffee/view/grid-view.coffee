EMap      = require 'emap'
ViewNode  = require 'two-trees/src/js/view-node'
RowView   = require './row-view'
HResizer  = require './resizer/h-resizer'
getBounds = require 'mycs/js/get-bounds'
Rect      = require 'mycs/js/rect'


class GridView extends ViewNode


    init: () ->
        @emap           = new EMap()
        @viewportRect   = new Rect()
        @contentRect    = new Rect()
        @rendererMap    = {}
        @cache          = []
        @startIndex     = 0
        @endIndex       = 0
        @totalHeight    = 0
        @drawTimeout    = null
        @scrollY        = NaN

        @emap.map window, 'resize',               @layout, @
        @emap.map @ctx,   'HResizer.update-cell', @onLayout, @


    onMount: () ->
        @viewport      = @children[1]
        @content       = @viewport.children[0]
        @layoutTimeout = setTimeout () =>
            @layout()
        , 0


    onUnmount: () ->
        clearTimeout @layoutTimeout
        @keep


    onResize: () ->
        @layout()


    onScroll: () =>
        @draw()


    onLayout: (event, widths) ->
        @layout widths


    layout: (widths) ->
        if not Array.isArray(widths)
            row    = HResizer.layout getBounds(@content.view).width - 15, 'cell'
            widths = []
            widths.push cell.w1 for cell in row.cells
        @ctx.grid.layout widths.slice 1
        @draw()




    draw: () ->
        viewport = @viewport.view
        content  = @content.view

        window.cancelAnimationFrame @drawTimeout
        if not isNaN(@scrollY) and @scrollY != viewport.scrollTop
            viewport.scrollTop = @scrollY

        @scrollY    = NaN
        @startIndex = -1

        lines  = @ctx.grid.lines
        height = @ctx.grid.height
        vb     = getBounds viewport, @viewportRect
        cb     = getBounds content,   @contentRect
        y0     = 0
        y1     = 0
        t      = vb.y - cb.y
        b      = t + vb.height
        oldMap = @rendererMap
        newMap = {}

        if cb.height != height
            content.style.height = height + 'px'

        for line, i in lines
            y1 = y0 + line.height
            if (y0 <= t and y1 >= t) or (y0 <= b and y1 >= b) or (y0 <= t and y1 >= b) or (y0 >= t and y1 <= b)
                @startIndex = i if @startIndex == -1
                @endIndex   = i

                renderer = oldMap[i]
                cfg      =
                    line:   line
                    y:      y0
                    keep:   true
                    inject: ctx: @ctx

                if not renderer
                    renderer = @cache.pop()
                    if not renderer
                         renderer = new RowView cfg
                    else
                        renderer.updateCfg cfg
                        renderer.updateNow()
                    renderer.appendTo content
                else
                    renderer.updateCfg cfg
                    renderer.updateNow()
                    delete oldMap[i]

                newMap[i] = renderer
            y0 = y1

        for i, renderer of oldMap
            renderer.remove()
            @cache.push renderer
        @rendererMap = newMap




    drawLater: () ->
        window.cancelAnimationFrame @drawTimeout
        @drawTimeout = window.requestAnimationFrame () => @draw()




    render: () ->
        tag:       'div'
        className: 'grid-view'
        children: [
            tag:       'div'
            className: 'row-view grid-view-title'
            children: [
                tag: 'div', className: 'cell-0 cell-view cell-view-title', text: 'index'
            ,
                tag:      HResizer
                selector: 'cell'
            ,
                tag: 'div', className: 'cell-1 cell-view cell-view-title cell-1', text: 'ident'
            ,
                tag:      HResizer
                selector: 'cell'
            ,
                tag: 'div', className: 'cell-2 cell-view cell-view-title cell-2', text: 'original'
            ,
                tag:      HResizer
                selector: 'cell'
            ,
                tag: 'div', className: 'cell-3 cell-view cell-view-title cell-3', text: 'translated'
            ]
        ,
            tag:       'div'
            className: 'grid-view-viewport'
            onScroll:  @onScroll
            child:
                tag:       'div'
                className: 'grid-view-content'
        ]


module.exports = GridView
