/*
* Copyright (c) {{yearrange}} Alex ()
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alex Angelou <>
*/
using Granite;
using Granite.Widgets;
using Gtk;

namespace Wineglass {
    public class Application : Granite.Application {

        public static Granite.Widgets.Toast ErrorToast;
        public static Granite.Widgets.Welcome Welcome;

        public Application () {
            Object(
                application_id: "com.github.aggalex.Wineglass", 
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        protected override void activate () {
            ErrorToast = new Granite.Widgets.Toast ("Failed"); // TODO ++++++++++ IT DOESN'T WORK!
            ErrorToast.show ();
            ErrorToast.send_notification ();

            var window = new Gtk.ApplicationWindow (this);

            var headerbar = new Wineglass.Headerbar ();
            window.set_titlebar (headerbar);

            var MainBox = new Wineglass.MainBox (headerbar);

            var overlay = new DndOverlay (MainBox);
            window.key_press_event.connect ((key) => {
                if (Gdk.keyval_name (key.keyval) == "Escape") {
                    overlay.on_esc ();
                }
                return true;
            });

            var NamePopover = new Wineglass.NamePopover (headerbar.addEntryButton, MainBox.AppsList);

            new Wineglass.Css ();
            //var SettingsMenu = new Wineglass.SettingsMenu ();

            headerbar.addEntryButton.clicked.connect (() => {
                NamePopover.showup ();
            });

            connect_to_actions (MainBox.AppsList);

            window.title = "Wineglass";
            window.set_default_size (400, 400);
            window.add (overlay);
            window.show_all ();
        }

        private void connect_to_actions (Wineglass.AppsList AppsList) {
            var winecfg = new SimpleAction ("winecfg", null);
            winecfg.activate.connect (() => {
                try {
                    Actions.winecfg (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to run wine configurations";
                    ErrorToast.send_notification ();
                    warning ("failed to run winecfg: " + e.message);
                }
            });
            winecfg.set_enabled (true);
            this.add_action (winecfg);

            var regedit = new SimpleAction ("regedit", null);
            regedit.activate.connect (() => {
                try {
                    Actions.regedit (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to run the registry editor";
                    ErrorToast.send_notification ();
                    warning ("failed to run regedit: " + e.message);
                }
            });
            regedit.set_enabled (true);
            this.add_action (regedit);

            var winetricks = new SimpleAction ("winetricks", null);
            winetricks.activate.connect (() => {
                try {
                    Actions.winetricks (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to run winetricks";
                    ErrorToast.send_notification ();
                    warning ("failed to run winetricks: " + e.message);
                }
            });
            winetricks.set_enabled (true);
            this.add_action (winetricks);

            var cmd = new SimpleAction ("cmd", null);
            cmd.activate.connect (() => {
                try {
                    Actions.cmd (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to run command line";
                    ErrorToast.send_notification ();
                    warning ("failed to run cmd: " + e.message);
                }
            });
            cmd.set_enabled (true);
            this.add_action (cmd);

            var taskmgr = new SimpleAction ("taskmgr", null);
            taskmgr.activate.connect (() => {
                try {
                    Actions.taskmgr (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to run the wine taskmanager";
                    ErrorToast.send_notification ();
                    warning ("failed to open prefix directory: " + e.message);
                }
            });
            taskmgr.set_enabled (true);
            this.add_action (taskmgr);

            var c_dir = new SimpleAction ("c_dir", null);
            c_dir.activate.connect (() => {
                try {
                    Actions.open_C (AppsList.getSelectedPrefix ());
                } catch (RunError e) {
                    ErrorToast.title = "failed to open the prefix directory";
                    ErrorToast.send_notification ();
                    warning ("failed to open prefix directory: " + e.message);
                }
            });
            c_dir.set_enabled (true);
            this.add_action (c_dir);

            var exe = new SimpleAction ("exe", null);
            exe.activate.connect (() => {
                try {
                    try {
                        string f = Actions.ChooseFile ();
                        Actions.exe (AppsList.getSelectedPrefix (), f);
                    } catch (FileChooserError e) {
                        ErrorToast.title = e.message;
                        ErrorToast.send_notification ();
                    }
                } catch (RunError e) {
                    ErrorToast.title = "failed to run executable";
                    ErrorToast.send_notification ();
                    warning ("Failed running executable: " + e.message);
                }
            });
            exe.set_enabled (true);
            this.add_action (exe);
        }

        public static int main (string[] args) {
            var app = new Wineglass.Application ();
            return app.run (args);
        }
    }
}
