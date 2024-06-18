project(
  'phosh-wallpaperd',
  ['c', 'vala'],
  version: '0.1.3',
  meson_version: '>= 0.62.0',
  license: 'GPL-3.0-only',
  default_options: ['prefix=/usr']
)

gnome = import('gnome')

prefix = '/usr'
bindir = join_paths(prefix, get_option('bindir'))
datadir = join_paths(prefix, get_option('datadir'))
schemasdir = join_paths(datadir, 'glib-2.0/schemas')

conf = configuration_data()
conf.set('bindir', bindir)
conf.set('datadir', datadir)

gio = dependency('gio-2.0', version: '>= 2.72')

subdir('data')

pwd_dependencies = [
  gio
]

subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
)
