ViewNode = require 'two-trees/src/js/view-node'
GridView = require './grid-view'


class AppView extends ViewNode


    init: () ->
        @index = 0


    render: () ->
        tag:       'div'
        className: 'window'
        children: [
            tag:       'div'
            className: 'toolbar'
        ,
            tag:       'div'
            className: 'content'
            child:
                tag: GridView
        ]


module.exports = AppView