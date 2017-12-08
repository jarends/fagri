Line = require './line'



LOREM = """Lorem ipsum dolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolordolor sit amet, consectetur adipiscing elit. Mauris diam tortor, commodo eget sem sed, lacinia egestas leo. In nulla mi, placerat id arcu sed, ultrices pulvinar est. Quisque magna eros, sodales vitae nisi et, mattis iaculis mauris. Donec venenatis velit sed ligula sagittis, eget suscipit libero tincidunt. Sed lobortis eu magna in euismod. In consectetur eros non dapibus pellentesque. Vestibulum ac condimentum sem. Phasellus id tempor augue.

Mauris pellentesque, felis vitae iaculis volutpat, justo lacus hendrerit nibh, et congue felis mauris eu justo. Donec feugiat bibendum volutpat. Aenean tempus rhoncus cursus. Vivamus vitae ipsum placerat, feugiat arcu eu, faucibus risus. Vivamus lectus massa, pellentesque nec pellentesque vitae, rutrum eget erat. Suspendisse potenti. Mauris bibendum, sem molestie laoreet mollis, augue neque molestie libero, sit amet finibus justo ante vel ante. Etiam gravida odio at pulvinar ullamcorper. Curabitur elementum aliquet hendrerit. Proin congue ligula et leo volutpat consequat. Etiam porta consequat tincidunt. Curabitur rutrum sollicitudin velit et posuere. Praesent sagittis lobortis convallis. Aenean consequat varius dui non molestie.

Sed viverra tincidunt orci vitae sagittis. Quisque sed lectus non eros pretium aliquet. Cras ac mi tempus, venenatis dui eget, euismod lectus. Vivamus id odio diam. Proin sit amet quam eu mi vulputate tempus. Suspendisse potenti. Maecenas accumsan, felis a lobortis pretium, ipsum magna dapibus felis, eu efficitur urna eros at arcu. In ipsum nisl, vehicula non dignissim nec, tristique vitae nibh. Suspendisse magna lorem, venenatis quis mauris sed, venenatis accumsan dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nulla facilisi. Pellentesque elementum suscipit egestas. Proin lectus eros, scelerisque vitae lacus eu, vehicula tristique lectus. Donec vel faucibus risus. Fusce eu velit nec lectus accumsan congue.

Nulla facilisis dui ut mi cursus, in ultricies massa volutpat. Pellentesque gravida placerat felis. Vivamus tempus nunc a egestas tempor. Maecenas commodo, eros vitae efficitur mattis, nisi libero aliquam nisl, sed condimentum sem dolor ut enim. In eu sagittis metus, eu dapibus ligula. Vivamus ultricies varius erat at tincidunt. Aenean blandit iaculis aliquam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam eget ornare quam. Nam ut est eget nisi posuere sodales. Morbi dolor est, pellentesque quis gravida sed, suscipit eu mi. Nullam condimentum sem ut efficitur tincidunt. Quisque malesuada ipsum a urna convallis, sed fermentum diam ullamcorper. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum congue libero et felis dignissim, eu scelerisque turpis dictum. Quisque dignissim ligula in imperdiet sodales.

Nulla blandit enim eget posuere posuere. Proin tortor nulla, cursus eget tortor ultricies, facilisis venenatis metus. Maecenas mattis quam ut posuere commodo. Nulla quis facilisis arcu. Curabitur et vehicula neque. Nullam molestie lobortis sagittis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam ex arcu, laoreet accumsan eros et, cursus scelerisque lectus. Integer consequat diam ut viverra dignissim. Nulla id enim eget lorem ultrices egestas vel eget nibh. Sed ac ligula et arcu venenatis blandit. Integer congue non diam nec blandit. Pellentesque et malesuada nibh."""




class Grid


    constructor: () ->


    get: (index) ->
        @lines[index]


    setLines: (datas) ->
        datas.shift()
        @lines  = []
        @height = 0
        for data, i in datas
            @lines.push new Line(data, i, @)
        @lines


    createDummyData: () ->
        lines = []
        for i in [0 ... 5001]
            lines.push [
                'ident::' + i
                LOREM.slice 0, Math.floor(Math.random() * (LOREM.length - 30)) + 30
                LOREM.slice 0, Math.floor(Math.random() * (LOREM.length - 30)) + 30
            ]
        @setLines lines


    layout: (widths) ->
        @height = 0
        for line in @lines
            @height += line.layout widths
        #console.log 'grid.layout: ', @height, widths
        @height





module.exports = Grid
