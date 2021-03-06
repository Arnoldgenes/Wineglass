# project name and programming language
project('com.github.aggalex.wineglass', 'vala', 'c', version: '0.1.0')

message ('project name and programming language')

# Adds project arguments
message ('Adds project arguments')

add_project_arguments([
        '-DGETTEXT_PACKAGE=\"@0@\"'.format(meson.project_name())
    ],
    language: 'c',
)

# Include the translations module
message('Include the translations module')

i18n = import('i18n')

# Set our translation domain
message ('Set our translation domain')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Adding deps
message ('Listing dependencies')

dependencies = [
    dependency('gio-unix-2.0', version: '>=2.20'),
    meson.get_compiler('vala').find_library('posix'),
    dependency('granite')
]

# Adds subfolders specific build system
message ('Adds subfolders specific build system')

icon_sizes = ['16', '24', '36', '48', '64', '128', '256']

foreach i : icon_sizes
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    )
endforeach

install_data(
    'src/css/style.css',
    install_dir: join_paths(get_option('datadir'), 'wineglass')
)

install_data(
    'data/Images/dnd_image.svg',
    install_dir: join_paths(get_option('datadir'), 'wineglass')
)

config_data = configuration_data()
config_data.set('EXEC_NAME', meson.project_name())

# Src build
message ('Src build')

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
conf_data.set_quoted('PREFIX', get_option('prefix'))

message ('Configuring desktop entry: ' + meson.project_name() + '.desktop')

desktop_in_file = configure_file(
    input: join_paths('data', meson.project_name() + '.desktop.in.in'),
    output: '@BASENAME@',
    configuration: config_data
)

desktop_file = i18n.merge_file(
    input: desktop_in_file,
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

appstream_file = i18n.merge_file(
    input: join_paths (meson.source_root(), 'data', meson.project_name() + '.appdata.xml.in'),
    output: '@BASENAME@',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

message ('Configuring config file: config.vala')

valaconf = configure_file(
    input: join_paths ('config.vala.in'),
    output: 'conf.vala',
    configuration: conf_data
)

valaconfpath = join_paths (meson.build_root(), 'conf.vala').split(meson.source_root() + '/')[1]

message ('Adds files to build')

subdir('po')

code_files = files(
    #'@0@/@1@'.format(meson.build_root(), valaconf),
    #join_paths (meson.build_root(), 'conf.vala'),
    valaconfpath,
    'src/widgets/AppsList.vala',
    'src/widgets/Headerbar.vala',
    'src/widgets/MainBox.vala',
    'src/widgets/DndOverlay.vala',
    'src/widgets/NamePopover.vala',
    'src/widgets/SettingsButton.vala',
    'src/widgets/Application.vala',
    'src/Actions.vala',
    'src/css/Css.vala'
)

message ('Defines executable')

executable(
    meson.project_name(),
    code_files,
    dependencies: dependencies,
    install: true
)
