/* Copyright 2024 Rirusha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

public sealed class PhoshWallpaperD.CSSWriter: Object {

    public CSSType css_type { get; construct; default = CSSType.GTK3; }

    File css_file;

    public CSSWriter (CSSType css_type = CSSType.GTK3) {
        Object (css_type: css_type);
    }

    construct {
        string css_dir;

        switch (css_type) {
            case CSSType.GTK3:
                css_dir = "gtk-3.0";
                break;
            
            case CSSType.GTK4:
                css_dir = "gtk-4.0";
                break;

            default:
                assert_not_reached ();
        }

        css_file = File.new_build_filename (
            Environment.get_user_config_dir (),
            css_dir,
            "gtk.css"
        );

        print (
            "Current working file set: '%s'\n\n",
            css_file.get_path ()
        );
    }

    public async void write_background_uri (string background_uri, string lockscreen_background_uri, double home_alpha) {
        if (!css_file.query_exists ()) {
            print (
                "File '%s' not found. Trying create...\n\n",
                css_file.get_path ()
            );

            try {
                yield css_file.create_async (FileCreateFlags.NONE);
                print (
                    "File '%s' created\n\n",
                    css_file.get_path ()
                );

            } catch (Error e) {
                warning (
                    "Error while creating file '%s'. Error message: %s",
                    css_file.get_path (),
                    e.message
                );
                return;
            }
        }

        print (
            "Write data to '%s'\n\n",
            css_file.get_path ()
        );

        try {
            FileUtils.set_data (
                css_file.get_path (),
                css_file_template.printf (home_alpha, background_uri, lockscreen_background_uri).data
            );
            print (
                "File '%s' successfuly udated\n\n",
                css_file.get_path ()
            );

        } catch (FileError e) {
            warning (
                "Error while writing data to '%s'. Error message: %s",
                css_file.get_path (),
                e.message
            );
        }
    }
}
