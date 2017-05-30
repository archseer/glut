# -*- coding: UTF-8 -*-
# -*-ruby-*-
#
# Copyright (C) 2006 John M. Gabriele <jmg3000@gmail.com>
# Copyright (C) Eric Hodel <drbrain@segment7.net>
#
# This program is distributed under the terms of the MIT license.
# See the included MIT-LICENSE file for the terms of this license.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'hoe'
require 'rake/extensiontask'

hoe = Hoe.spec 'glut' do
  developer 'Eric Hodel', 'drbrain@segment7.net'
  developer 'Lars Kanis',  'lars@greiz-reinsdorf.de'
  developer 'Blaž Hrastnik', 'speed.the.bboy@gmail.com'
  developer 'Alain Hoang', ''
  developer 'Jan Dvorak',  ''
  developer 'Minh Thu Vo', ''
  developer 'James Adam',  ''

  self.readme_file = 'README.rdoc'
  self.history_file = 'History.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc']

  extra_dev_deps << ['rake-compiler', '~> 1.0']
  extra_dev_deps << ['rake-compiler-dock', '~> 0.6.0']
  extra_dev_deps << ['mini_portile2', '~> 2.1']

  self.spec_extras = {
    :extensions            => %w[ext/glut/extconf.rb],
    :required_ruby_version => '>= 1.9.2',
    :metadata              => {'msys2_mingw_dependencies' => 'freeglut'},
  }
end

Rake::ExtensionTask.new 'glut', hoe.spec do |ext|
  ext.lib_dir = 'lib/glut'

  ext.cross_compile = true
  ext.cross_platform = ['x86-mingw32', 'x64-mingw32']
  ext.cross_config_options += [
    "--enable-win32-cross",
  ]
  ext.cross_compiling do |spec|
    # The fat binary gem doesn't depend on the freeglut package, since it bundles the library.
    spec.metadata.delete('msys2_mingw_dependencies')
  end
end


# To reduce the gem file size strip mingw32 dlls before packaging
ENV['RUBY_CC_VERSION'].to_s.split(':').each do |ruby_version|
  task "copy:glut:x86-mingw32:#{ruby_version}" do |t|
    sh "i686-w64-mingw32-strip -S tmp/x86-mingw32/stage/lib/glut/#{ruby_version[/^\d+\.\d+/]}/glut.so"
  end

  task "copy:glut:x64-mingw32:#{ruby_version}" do |t|
    sh "x86_64-w64-mingw32-strip -S tmp/x64-mingw32/stage/lib/glut/#{ruby_version[/^\d+\.\d+/]}/glut.so"
  end
end

desc "Build windows binary gems per rake-compiler-dock."
task "gem:windows" do
  require "rake_compiler_dock"
  RakeCompilerDock.sh <<-EOT
    rake cross native gem MAKE='nice make -j`nproc`'
  EOT
end

task :test => :compile
