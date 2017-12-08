ViewNode   = require 'two-trees/src/js/view-node'
EditorView = require './editor-view'
HResizer   = require './resizer/h-resizer'


class RowView extends ViewNode

    init: () ->
        console.log 'row.init: ', @ctx


    render: () ->
        tag:       'div'
        className: 'row-view'
        style:     "top: #{@cfg.y}px; height: #{@cfg.line.height}px;"
        children: [
            tag:       'div'
            className: 'cell-0 cell-view '
            text:      @cfg.line.index
        ,
            tag:      HResizer
            selector: 'cell'
        ,
            tag:       'div'
            className: 'cell-1 cell-view'
            text:      @cfg.line.ident
        ,
            tag:      HResizer
            selector: 'cell'
        ,
            tag:       EditorView
            text:      @cfg.line.base
            className: 'cell-2 cell-view'
        ,
            tag:      HResizer
            selector: 'cell'
        ,
            tag:       EditorView
            text:      @cfg.line.trans
            className: 'cell-3 cell-view'
        ]


module.exports = RowView

