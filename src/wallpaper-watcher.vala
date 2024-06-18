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

public sealed class PhoshWallpaperD.WallpaperWatcher: Object {

    const string COLOR_SCHEME_PREFER_DARK = "prefer-dark";
    const string COLOR_SCHEME_PREFER_LIGHT = "prefer-light";
    const string COLOR_SCHEME_DEFAULT = "default";

    string color_scheme {
        owned get {
            return settings_interface.get_string ("color-scheme");
        }
    }

    string picture_uri {
        owned get {
            return settings_background.get_string ("picture-uri");
        }
    }

    string picture_uri_dark {
        owned get {
            return settings_background.get_string ("picture-uri-dark");
        }
    }

    double home_alpha {
        owned get {
            return settings_phosh_wallpaperd.get_double ("home-alpha");
        }
    }

    string lockscreen_picture_uri {
        owned get {
            return settings_phosh_wallpaperd.get_string ("lockscreen-picture-uri");
        }
    }

    string lockscreen_picture_uri_dark {
        owned get {
            return settings_phosh_wallpaperd.get_string ("lockscreen-picture-uri-dark");
        }
    }

    Settings settings_background = new Settings ("org.gnome.desktop.background");
    Settings settings_phosh_wallpaperd = new Settings ("ru.alt-gnome.phosh-wallpaperd");
    Settings settings_interface = new Settings ("org.gnome.desktop.interface");

    CSSWriter css_writer = new CSSWriter (CSSType.GTK3);

    construct {
        update_backgrounds ();
    }

    void on_color_scheme_changed () {
        print (
            "`color-scheme` changed. New value: '%s'\n\n",
            color_scheme
        );

        update_backgrounds ();
    }

    void on_home_alpha_changed () {
        print (
            "`home-alpha` changed. New value: %s\n\n",
            home_alpha.to_string ()
        );

        update_backgrounds ();
    }

    void update_backgrounds () {
        switch (color_scheme) {
            case COLOR_SCHEME_PREFER_DARK:
                change_dark_background ();
                break;
            
            case COLOR_SCHEME_DEFAULT:
            case COLOR_SCHEME_PREFER_LIGHT:
                change_light_background ();
                break;

            default:
                warning ("Unknown value of `color-scheme` key: %s", color_scheme);
                break;
        }
    }

    void on_light_background_changed () {
        print (
            "`picture-uri` changed. New value: '%s'\n\n",
            picture_uri
        );

        if (color_scheme == COLOR_SCHEME_DEFAULT || color_scheme == COLOR_SCHEME_PREFER_LIGHT) {
            change_light_background ();
        }
    }

    void on_lockscreen_light_background_changed () {
        print (
            "`lockscreen-picture-uri` changed. New value: '%s'\n\n",
            lockscreen_picture_uri
        );

        if (color_scheme == COLOR_SCHEME_DEFAULT || color_scheme == COLOR_SCHEME_PREFER_LIGHT) {
            change_light_background ();
        }
    }

    void change_light_background () {
        change_background (picture_uri, lockscreen_picture_uri);
    }

    void on_dark_background_changed () {
        print (
            "`picture-uri-dark` changed. New value: '%s'\n\n",
            picture_uri_dark
        );

        if (color_scheme == COLOR_SCHEME_PREFER_DARK) {
            change_dark_background ();
        }
    }

    void on_lockscreen_dark_background_changed () {
        print (
            "`lockscreen-picture-uri-dark` changed. New value: '%s'\n\n",
            lockscreen_picture_uri_dark
        );

        if (color_scheme == COLOR_SCHEME_PREFER_DARK) {
            change_dark_background ();
        }
    }

    void change_dark_background () {
        change_background (picture_uri_dark, lockscreen_picture_uri_dark);
    }

    inline bool uri_is_valid (string uri) {
        return uri.has_prefix ("file:///");
    }

    void change_background (string background_uri, string lockscreen_background_uri) {
        if (!uri_is_valid (background_uri)) {
            warning ("Wrong uri: %s", background_uri);
            return;
        }

        if (!uri_is_valid (lockscreen_background_uri)) {
            warning ("Wrong uri: %s", lockscreen_background_uri);
            return;
        }

        css_writer.write_background_uri.begin (background_uri, lockscreen_background_uri, home_alpha);
    }

    public void run (string[] args) {
        settings_interface.changed["color-scheme"].connect (on_color_scheme_changed);
        settings_background.changed["picture-uri"].connect (on_light_background_changed);
        settings_background.changed["picture-uri-dark"].connect (on_dark_background_changed);
        settings_phosh_wallpaperd.changed["home-alpha"].connect (on_home_alpha_changed);
        settings_phosh_wallpaperd.changed["lockscreen-picture-uri"].connect (on_lockscreen_light_background_changed);
        settings_phosh_wallpaperd.changed["lockscreen-picture-uri-dark"].connect (on_lockscreen_dark_background_changed);

        new MainLoop ().run ();
    }
}
