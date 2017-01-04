/* Copyright 2017 elementary LLC.
*
* This file is part of Audio.
*
* Audio is free software: you can redistribute it and/or modify it under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, either version 3 of the License, or (at your option) any later
* version.
*
* Audio is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
* A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* Audio. If not, see http://www.gnu.org/licenses/.
*/

int main (string[] args) {
    Gtk.init (ref args);

    var window = new Gtk.Window ();
    window.title = "audio-file.mp3";
    window.set_border_width (12);
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (380, 292);
    window.destroy.connect (Gtk.main_quit);

    var layout = new Gtk.Grid ();
    layout.column_spacing = 6;
    layout.row_spacing = 6;

    var seek_backward_button = new Gtk.Button ();
    seek_backward_button.image = new Gtk.Image.from_icon_name ("media-seek-backward-symbolic", Gtk.IconSize.DIALOG);

    var play_pause_button = new Gtk.Button ();
    play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.DIALOG);

    var seek_forward_button = new Gtk.Button ();
    seek_forward_button.image = new Gtk.Image.from_icon_name ("media-seek-forward-symbolic", Gtk.IconSize.DIALOG);

    var seek_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
    seek_scale.set_draw_value (false);

    layout.attach (seek_backward_button, 0, 0, 1, 1);
    layout.attach (play_pause_button, 1, 0, 1, 1);
    layout.attach (seek_forward_button, 2, 0, 1, 1);
    layout.attach (seek_scale, 0, 1, 3, 1);

    window.add (layout);

    window.show_all ();
    Gtk.main ();
    return 0;
}
