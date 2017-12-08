Dispatcher = require 'mycs/js/dispatcher'
Grid       = require './model/grid'
AppView    = require './view/app-view'


class Context extends Dispatcher


    constructor: () ->
        super()
        @startup()


    startup: () ->
        console.log 'startup ...'
        @grid = new Grid()
        @grid.createDummyData()
        @app = new AppView inject: ctx: @
        @app.appendTo document.querySelector '.app'
        null


module.exports = Context