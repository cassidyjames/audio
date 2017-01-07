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

public class PantheonAudio : Gtk.Application {
    public PantheonAudio () {
        Object (application_id: "com.cassidyjames.audio",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        var playing = false;
        var app_window = new Gtk.ApplicationWindow (this);
        var player = Player.get_default ();
        
        // This hardcoded URI is for testing purposes only
        player.set_uri ("http://ec-media.sndcdn.com/y8DTb0AzZzgu?f10880d39085a94a0418a7ef61b03d5275edf83695e0cd6a5a31b701e3b17b5e8126718fbde1c872d1c0a6ac83ef4ee79c57f4de24fae85839aa5ad736");

        /*app_window.title = "audio-file.mp3";*/
        app_window.set_border_width (12);
        app_window.set_position (Gtk.WindowPosition.CENTER);
        app_window.set_default_size (380, 292);
        app_window.set_resizable (false);

        // setup header bar
        var header_bar = new Gtk.HeaderBar ();
        header_bar.show_close_button = true;
        header_bar.title = _("audio-file.mp3");

        app_window.set_titlebar (header_bar);

        var layout = new Gtk.Grid ();
        layout.column_spacing = 6;
        layout.row_spacing = 6;

        var seek_backward_button = new Gtk.Button ();
        seek_backward_button.image = new Gtk.Image.from_icon_name ("media-seek-backward-symbolic", Gtk.IconSize.DIALOG);
        seek_backward_button.clicked.connect (() => {
            double current_position = player.get_position ();
            
            // Seeks backward 10% of the length of the track
            player.set_position (current_position - 0.1);
        });

        var play_pause_button = new Gtk.Button ();
        play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.DIALOG);
        play_pause_button.clicked.connect (() => {
			if (playing == true) {
				player.pause ();
				play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.DIALOG);
				playing = false;
			} else {
				player.play ();
				play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.DIALOG);
				playing = true;
            }
        });

        var seek_forward_button = new Gtk.Button ();
        seek_forward_button.image = new Gtk.Image.from_icon_name ("media-seek-forward-symbolic", Gtk.IconSize.DIALOG);
        seek_forward_button.clicked.connect (() => {
            double current_position = player.get_position ();
            
            // Seeks forward 10% of the length of the track
            player.set_position (current_position + 0.1);
        });

        var seek_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
        seek_scale.set_draw_value (false);

        layout.attach (seek_backward_button, 0, 0, 1, 1);
        layout.attach (play_pause_button, 1, 0, 1, 1);
        layout.attach (seek_forward_button, 2, 0, 1, 1);
        layout.attach (seek_scale, 0, 1, 3, 1);

        app_window.add (layout);

        app_window.show_all ();
        app_window.destroy.connect (Gtk.main_quit);
    }

    public static int main (string[] args) {
        var app = new PantheonAudio ();
        Gst.init (ref args);

        return app.run (args);
    }
}
