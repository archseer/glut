#-*-ruby-*-
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
load 'Rakefile.cross'

hoe = Hoe.spec 'glut' do
  developer 'Eric Hodel', 'drbrain@segment7.net'
  developer 'Lars Kanis',  ''
  developer 'Blaž Hrastnik', 'speed.the.bboy@gmail.com'
  developer 'Alain Hoang', ''
  developer 'Jan Dvorak',  ''
  developer 'Minh Thu Vo', ''
  developer 'James Adam',  ''

  self.readme_file = 'README.rdoc'
  self.history_file = 'History.rdoc'
  self.extra_rdoc_files = FileList['*.rdoc']

  extra_dev_deps << ['rake-compiler', '~> 0.7', '>= 0.7.9']

  self.spec_extras = {
    :extensions            => %w[ext/glut/extconf.rb],
    :required_ruby_version => '>= 1.9.2',
  }
end

Rake::ExtensionTask.new 'glut', hoe.spec do |ext|
  ext.lib_dir = 'lib/glut'

  ext.cross_compile = true
  ext.cross_platform = ['i386-mingw32']
  ext.cross_config_options += [
    "--with-installed-include=#{STATIC_INSTALLDIR}/include",
    "--with-installed-lib=#{STATIC_INSTALLDIR}/lib",
  ]
end

task :test => :compile
