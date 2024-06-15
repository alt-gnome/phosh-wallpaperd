schema = 'ru.alt-gnome.phosh-wallpaperd.gschema.xml'

generated_schema = configure_file(
  output: schema,
  input: schema + '.in',
  configuration: conf,
)

install_data(
  generated_schema,
  install_dir: join_paths(datadir, schemasdir)
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file',
  compile_schemas,
  args: ['--strict', '--dry-run', meson.current_source_dir()])
endif

service = 'ru.alt-gnome.phosh-wallpaperd.service'

generated_service = configure_file(
  output: service,
  input: service + '.in',
  configuration: conf,
)

install_data(
  generated_service,
  install_dir: join_paths('/', sysconfdir, 'systemd/user')
)