begin
  RUBY_VERSION =~ /(\d+.\d+)/
  require "glut/#{$1}/glut"
rescue LoadError
  require 'glut/glut'
end

# (Glut.)glutInit -> GLUT.Init
# (Glut::)GLUT_RGBA -> GLUT::RGBA
module GLUT
  extend self
  include Glut

  Glut.constants.each do |cn|
    n = cn.to_s.sub(/^GLUT_/,'')
    next if n =~ /^[0-9]/
    const_set( n, Glut.const_get( cn ) )
  end

  Glut.methods( false ).each do |mn|
    n = mn.to_s.sub(/^glut/,'')
    alias_method( n, mn )
    public( n )
  end
end

module Glut
  VERSION = "8.2.2"
end
