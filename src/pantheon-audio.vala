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
    window.set_default_size (350, 350);
    window.destroy.connect (Gtk.main_quit);

    var button_play_pause = new Gtk.Button.with_label ("Pause");
    button_play_pause.clicked.connect (() => {
        button_play_pause.label = "Play";
    });

    window.add (button_play_pause);
    window.show_all ();

    Gtk.main ();
    return 0;
}
