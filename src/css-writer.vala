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
    }

    public void write_background_uri (string background_uri, string lockscreen_background_uri) {
        if (!css_file.query_exists ()) {
            css_file.create_async.begin (FileCreateFlags.NONE);
        }

        try {
            FileUtils.set_data (
                css_file.get_path (),
                css_file_template.printf (background_uri, lockscreen_background_uri).data
            );
        } catch (FileError e) {
            warning (
                "Error while trying write '%s'. Error message: %s",
                css_file.get_path (),
                e.message
            );
        }
    }
}
