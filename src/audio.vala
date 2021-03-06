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

// Want ability to terminate imediately - i.e. don't open audio file
extern void exit(int exit_code);

public class PantheonAudio : Gtk.Application {
    public PantheonAudio () {
        Object (application_id: "com.github.cassidyjames.audio",
        flags: ApplicationFlags.HANDLES_OPEN); // handle argument
    }

    /* Fix title from file_uri, set uri for the player and play the file */
    private void play_file (Gtk.ApplicationWindow app_window, Player player, string file_uri) {
        var title = GLib.Path.get_basename (file_uri);
        // Remove extension, replace spaces with actual spaces
        // In future might read mp3 meta if need more info - i.e. time
        var ext_index = title.last_index_of_char ('.', 0);
        if (ext_index == -1) ext_index = title.length;
        app_window.title = title.substring (0, ext_index).replace ("%20", " ");

        player.set_uri (file_uri);
        player.play();
    }

    // Asked to open file
    protected override void open (File[] files, string hint) {
        // Take first file passed as argument, no dialog
        launch_app (files[0].get_uri (), false);
    }

    protected override void activate () {
        // No file passed, launch dialog
        launch_app ("", true);
    }

    void launch_app (string file_uri, bool show_dialog) 
    {
        bool playing = true;
        var app_window = new Gtk.ApplicationWindow (this);
        var player = Player.get_default ();
        var play_pause_button = new Gtk.Button ();

        if (show_dialog)
        {
            var file_chooser = new Gtk.FileChooserDialog ("Open File", 
                                        app_window,
                                        Gtk.FileChooserAction.OPEN,
                                        "_Cancel", Gtk.ResponseType.CANCEL,
                                        "_Open", Gtk.ResponseType.ACCEPT);

            // Filter audio
            Gtk.FileFilter filter = new Gtk.FileFilter ();
            file_chooser.set_filter (filter);
            filter.add_mime_type ("audio/mpeg"); // mp3
            filter.add_mime_type ("audio/vnd.wav"); // wav
            filter.add_mime_type ("audio/ogg"); // ogg
            filter.add_mime_type ("audio/mp4"); // mp4 m4a

            file_chooser.response.connect ((dialog, response_id) => {
                switch (response_id) {
                    case Gtk.ResponseType.ACCEPT:
                        play_file (app_window, player, file_chooser.get_uri ());
                        break;
                    default:
                        exit (0);
                        break;
                }

                dialog.destroy ();
            });
            file_chooser.show ();
        } else {
            play_file (app_window, player, file_uri);
        }

        app_window.set_border_width (12);
        app_window.set_position (Gtk.WindowPosition.CENTER);
        app_window.set_default_size (380, 292);
        app_window.set_resizable (false);

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

        // Default is to play audio
        play_pause_button.image = new Gtk.Image.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.DIALOG);
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
        seek_scale.get_style_context ().add_class ("seek-bar");
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
