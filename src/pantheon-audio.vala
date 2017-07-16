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
        bool playing = false;
        var app_window = new Gtk.ApplicationWindow (this);
        var player = Player.get_default ();
        string title = "Audio";
        var play_pause_button = new Gtk.Button ();

        app_window.title = title;
        app_window.set_border_width (12);
        app_window.set_position (Gtk.WindowPosition.CENTER);
        app_window.set_default_size (380, 292);
        app_window.set_resizable (false);

        var layout = new Gtk.Grid ();
        layout.column_spacing = 6;
        layout.row_spacing = 6;

        var load_button = new Gtk.Button ();
        load_button.image = new Gtk.Image.from_icon_name ("folder-open", Gtk.IconSize.DIALOG);
        load_button.clicked.connect(() => {
            var file_chooser = new Gtk.FileChooserDialog ("Open File", this as Gtk.Window,
                                      Gtk.FileChooserAction.OPEN,
                                      "_Cancel", Gtk.ResponseType.CANCEL,
                                      "_Open", Gtk.ResponseType.ACCEPT);

            if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
                // Stop playback, load new song
                player.stop ();
                play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.DIALOG);
                playing = false;
                player.set_uri (file_chooser.get_uri());
                
                var player_title = GLib.Path.get_basename (file_chooser.get_uri());
                // Stupid, but need to replace escaped spacing
                app_window.title = player_title.replace("%20", " ");
            }
            file_chooser.destroy (); 
        });

        var seek_backward_button = new Gtk.Button ();
        seek_backward_button.image = new Gtk.Image.from_icon_name ("media-seek-backward-symbolic", Gtk.IconSize.DIALOG);
        seek_backward_button.clicked.connect (() => {
            double current_position = player.get_position ();

            // Seeks backward 10% of the length of the track
            player.set_position (current_position - 0.1);
        });

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

        // When stream ends, set the play_pause_button back to play
        player.stream_ended.connect (() => {
            play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.DIALOG);
            playing = false;
        });

        var seek_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
        seek_scale.set_draw_value (false);

        // Update the seek_scale with the current time every half second
        GLib.Timeout.add (500, () => {
            if(playing) {
                seek_scale.set_value (player.get_position () * 100);
            }

            return true;
        });

        // When the scale changes, seek in the player
        seek_scale.change_value.connect ((scroll, new_value) => {
            player.set_position (new_value / 100);

            return false;
        });

        layout.attach (seek_backward_button, 0, 0, 1, 1);
        layout.attach (play_pause_button, 1, 0, 1, 1);
        layout.attach (seek_forward_button, 2, 0, 1, 1);
        layout.attach (load_button, 3, 0, 1, 1);
        layout.attach (seek_scale, 0, 1, 4, 1);

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
