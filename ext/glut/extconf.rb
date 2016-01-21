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

if enable_config('win32-cross')
  require "mini_portile"

  LIBFREEGLUT_VERSION = ENV['LIBFREEGLUT_VERSION'] || '2.8.1'
  LIBFREEGLUT_SOURCE_URI = "http://downloads.sourceforge.net/project/freeglut/freeglut/#{LIBFREEGLUT_VERSION}/freeglut-#{LIBFREEGLUT_VERSION}.tar.gz"

  recipe = MiniPortile.new("libglut", LIBFREEGLUT_VERSION)
  recipe.files = [LIBFREEGLUT_SOURCE_URI]
  recipe.target = portsdir = File.expand_path('../../../ports', __FILE__)
  # Prefer host_alias over host in order to use i586-mingw32msvc as
  # correct compiler prefix for cross build, but use host if not set.
  recipe.host = RbConfig::CONFIG["host_alias"].empty? ? RbConfig::CONFIG["host"] : RbConfig::CONFIG["host_alias"]
  recipe.configure_options = [
    "--enable-static",
    "--target=#{recipe.host}",
    "--host=#{recipe.host}",
  ]

  checkpoint = File.join(portsdir, "#{recipe.name}-#{recipe.version}-#{recipe.host}.installed")
  unless File.exist?(checkpoint)
    recipe.cook
    # --disable-static can not be used since it breaks the freeglut build,
    # but to enforce static linking, we delete the import lib.
    FileUtils.rm File.join(recipe.path, "lib", "libglut.dll.a")
    FileUtils.touch checkpoint
  end
  recipe.activate

  $defs.push "-DFREEGLUT_EXPORTS"
  dir_config('freeglut', "#{recipe.path}/include", "#{recipe.path}/lib")

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
  have_header('GL/freeglut.h') ||
  have_header('GL/glut.h') ||
  have_header('GLUT/glut.h') # OS X

if String === ?a then
  $defs.push "-DHAVE_SINGLE_BYTE_STRINGS"
end

if ok then
  create_header
  create_makefile 'glut/glut'
end
