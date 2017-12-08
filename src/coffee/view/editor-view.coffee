ViewNode = require 'two-trees/src/js/view-node'


class EditorView extends ViewNode


    onMount: () ->
        #@resizeTA()


    resizeTA: () =>
        clearTimeout @resizeTimeout
        ta = @children[0].view
        @resizeTimeout = setTimeout () ->
            ta.style.height = ''
            ta.style.height = ta.scrollHeight + 'px'
        , 0


    render: () ->
        tag:       'div'
        className: @cfg.className
        child:
            tag:       'textarea'
            className: 'editor-textarea'
            value:     @cfg.text.value
            rows:      1
            #onKeydown: @resizeTA
            #onKeyup:   @resizeTA


module.exports = EditorView

