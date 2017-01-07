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

using Gst;

public class Player {

	private static Player? player = null;
	private dynamic Element playbin;

    public static Player? get_default () {
        if (player == null) {
            player = new Player();
        }
        return player;
    }

    public Player () {
	    playbin = ElementFactory.make ("playbin", "play");
    }

    public void set_uri (string uri) {
        playbin.uri = uri;
    }

    public void play () {
        playbin.set_state (State.PLAYING);
    }

    public void pause () {
        playbin.set_state (State.PAUSED);
    }

    public void set_position (double pos) {
        // Determine the overall duration
        int64 duration;
        playbin.query_duration (Gst.Format.TIME, out duration);
        int64 new_pos = (int64)(duration * pos);
        playbin.seek_simple (Gst.Format.TIME, Gst.SeekFlags.SKIP, new_pos);
    }
    
    public double get_position () {
        int64 current_position;
        playbin.query_position (Gst.Format.TIME, out current_position);
        int64 duration;
        playbin.query_duration (Gst.Format.TIME, out duration);
        double position_percentage = current_position / duration;
        return position_percentage;
    }
    
}

	
