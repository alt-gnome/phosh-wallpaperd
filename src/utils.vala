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

namespace PhoshWallpaperD {

    public enum CSSType {
        GTK3,
        GTK4
    }

    public const string css_file_template = """
/* This file generated automatically */

phosh-app-grid {
  background: rgba(0, 0, 0, %f);
}

.phosh-overview {
  background-image: url("%s");
  background-size: cover;
  background-position: center;
}

phosh-lockscreen, .phosh-lockshield {
  background-image: url("%s");
  background-size: cover;
  background-position: center;
}
""";
}
