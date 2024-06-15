pwd_sources = files(
  'css-writer.vala',
  'main.vala',
  'utils.vala',
  'wallpaper-watcher.vala',
)

pwd_vala_args = [
  '--target-glib', '2.76',
  '--vapidir', meson.current_source_dir(),
]

executable(
  'ru.alt-gnome.phosh-wallpaperd',
  pwd_sources,
  vala_args: pwd_vala_args,
  dependencies: pwd_dependencies,
  install: true,
)
