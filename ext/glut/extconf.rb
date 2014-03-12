require 'mkmf'

def have_framework(fw, &b)
  checking_for fw do
    src = cpp_include("#{fw}/#{fw}.h") << "\n" "int main(void){return 0;}"
    if try_link(src, opt = "-ObjC -framework #{fw}", &b)
      $defs.push(format("-DHAVE_FRAMEWORK_%s", fw.tr_cpp))
      $LDFLAGS << " " << opt
      true
    else
      false
    end
  end
end unless respond_to? :have_framework

if ENV['CROSS_COMPILING']
  dir_config("installed")

  $defs.push "-DFREEGLUT_EXPORTS"

  # libfreeglut is linked to gdi32 and winmm
  have_library( 'gdi32', 'CreateDC' ) && append_library( $libs, 'gdi32' )
  have_library( 'winmm', 'timeBeginPeriod' ) && append_library( $libs, 'winmm' )
end

ok =
  (have_library('opengl32.lib', 'glVertex3d') && have_library('glut32.lib',   'gluSolidTeapot')) ||
  (have_library('opengl32') && have_library('glut')) ||
  (have_library('GL',   'glVertex3d') && have_library('glut', 'glutSolidTeapot')) ||
  (have_framework('OpenGL') && have_framework('GLUT') && have_framework('Cocoa'))

ok &&=
  have_header('GL/glut.h') ||
  have_header('GLUT/glut.h') # OS X

if String === ?a then
  $defs.push "-DHAVE_SINGLE_BYTE_STRINGS"
end

if ok then
  create_header
  create_makefile 'glut/glut'
end
