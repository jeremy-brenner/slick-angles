$:.push File.expand_path('../../lib',__FILE__)

require 'slick'
require 'angles'

app = AppGameContainer.new(Main.new('Angles'))
app.set_display_mode(640,480,false)
app.setShowFPS(true)
app.start

