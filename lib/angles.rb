class Main < BasicGame
  def init(container)
  #  @font = UnicodeFont.new("fonts/FreeSans.ttf", 12, false, false)
  #  @font.addAsciiGlyphs()
  #  @font.addGlyphs(400, 600)
  #  @font.getEffects().add( ColorEffect(java.awt.Color.white))
  #  @font.loadGlyphs()
    @bg = Image.new('bg.png')
    @cx = ( container.width/2 ).to_i
    @cy = ( container.height/2 ).to_i
    @circle = MyCircle.new(@cx,@cy,150)
    @reflection = MyReflection.new(@cx,@cy,190,30,175)
  end

  def render(container,graphics)
    graphics.setAntiAlias(true);
    @bg.draw(0,0)
    @circle.draw(graphics)
    @reflection.draw(graphics)
  #  graphics.setFont(@font)
    graphics.setColor(Color.white)
    graphics.draw_string('Angles',8,container.height - 90)
    graphics.draw_string('a/z = surface +/-',8,container.height - 75)
    graphics.draw_string('s/x = incident +/-',8,container.height - 60)
    graphics.draw_string('ESC to exit',8,container.height - 45)
    graphics.draw_string('Colors:',8,container.height - 30)
    graphics.setColor(@reflection.surface_color)
    graphics.draw_string('surface',80,container.height - 30)
    graphics.setColor(@reflection.normal_color)
    graphics.draw_string('normal',160,container.height - 30)
    graphics.setColor(@reflection.incident_color)
    graphics.draw_string('incident',220,container.height - 30)
    graphics.setColor(@reflection.reflection_color)
    graphics.draw_string('reflection',300,container.height - 30)
  end

  def update(container,delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)
    @reflection.surface += 1 if input.is_key_down(Input::KEY_A)
    @reflection.surface -= 1 if input.is_key_down(Input::KEY_Z)
    @reflection.incident += 1 if input.is_key_down(Input::KEY_S)
    @reflection.incident -= 1 if input.is_key_down(Input::KEY_X)
  end
end

class MyCircle
  def initialize(cx,cy,radius)
    @cx = cx
    @cy = cy
    @radius = radius
    @circle = Circle.new(cx,cy,radius)
  end
  def draw(gfx)
    gfx.setLineWidth(2)
    gfx.setColor(Color.black)
    gfx.draw(@circle)
  end
end

class MyLine
  def initialize(cx,cy,radius,angle)
    @cx = cx
    @cy = cy
    @radius = radius
    @angle = angle
  end
  def angle
    @angle
  end
  def angle= (angle)
    @angle = angle%360
  end
  def x(radius=@radius)
    ( radius * Math.cos( @angle * Math::PI/180 ) ).round + @cx
  end
  def y(radius=@radius)
    ( radius * Math.sin( @angle * Math::PI/180 ) ).round + @cy
  end
  def draw(gfx,color=Color.black)
    gfx.setLineWidth(2)
    gfx.setColor(color)
    gfx.drawLine( @cx, @cy, self.x, self.y )
  end
end

class MyReflection
  attr_reader :incident_color, :reflection_color, :surface_color, :normal_color
  def initialize(cx,cy,radius,incident,surface)
    @cx = cx
    @cy = cy
    @radius = radius
    @incident_line = MyLine.new(cx,cy,radius,incident)
    @surface_line = MyLine.new(cx,cy,radius,surface)
    @reflection_line = MyLine.new(cx,cy,radius,self.reflection)
    @incident_color   = Color.blue
    @reflection_color = Color.magenta
    @surface_color    = Color.black
    @normal_color     = Color.gray
  end
  def reflection
    ( ( @surface_line.angle + 90 ) * 2 - @incident_line.angle ) % 360
  end
  def surface
    @surface_line.angle
  end
  def surface= (angle)
    @surface_line.angle = angle
    self.update_reflection
  end
  def incident
    @incident_line.angle
  end
  def incident= (angle)
    @incident_line.angle = angle
    self.update_reflection
  end
  def update_reflection
    @reflection_line.angle = self.reflection
  end
  def draw(gfx)
    @incident_line.draw(gfx,@incident_color)
    gfx.draw_string( @incident_line.angle.to_s, @incident_line.x(@radius+5), @incident_line.y(@radius+5) )
    
    1.upto(4) do |i|
      color = if i.odd? then @surface_color else @normal_color end
      @surface_line.draw(gfx,color)
      @surface_line.angle += 90
    end
    
    gfx.setColor(@surface_color)
    gfx.draw_string( @surface_line.angle.to_s, @surface_line.x(@radius+5), @surface_line.y(@radius+5) )

    @reflection_line.draw(gfx,@reflection_color)
    gfx.draw_string( @reflection_line.angle.to_s, @reflection_line.x(@radius+10), @reflection_line.y(@radius+10) )
  end
end
