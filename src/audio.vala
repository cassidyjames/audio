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
