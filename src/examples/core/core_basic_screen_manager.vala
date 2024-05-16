/*
 * RaylibOOP Core Basic Screen Manager by Charadon
 *
 * To the extent possible under law, the person who associated CC0 with
 * RaylibOOP Core Basic Screen Manager has waived all copyright and related or neighboring rights
 * to RaylibOOP Core Basic Screen Manager.
 *
 * You should have received a copy of the CC0 legalcode along with this
 * work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
using GLib;
using RaylibOOP;
using RaylibOOP.Input;
using RaylibOOP.Shapes;

public class Game : GLib.Application {
	private Window window;
	private MainLoop loop;
	private TimeoutSource timeout;

	private int framesCounter = 0;
	private enum GameScreen {
		LOGO = 0,
		TITLE = 1,
		GAMEPLAY = 2,
		ENDING = 3
	}
	private int currentScreen = GameScreen.LOGO;

	private Game() {
		Object (
			application_id: "io.github.lxmcf.RaylibOOP.core_basic_screen_manager",
			flags: ApplicationFlags.DEFAULT_FLAGS
		);
	}

	~Game() {
		window = null;
	}

	private bool main_loop() {
		/* Check if Application Should Close */
		if(window.should_close) {
			/* Tell loop to stop */
			loop.quit();
			return(false);
		}

		/* Change Screen */
		switch(currentScreen) {
			case GameScreen.LOGO: {
				this.framesCounter++;
				if(this.framesCounter > 120) {
					currentScreen = GameScreen.TITLE;
				}
				break;
			}
			case GameScreen.TITLE: {
				if(Keyboard.is_pressed(Keyboard.Key.ENTER) || Touch.is_gesture_detected(Touch.Gestures.TAP)) {
					currentScreen = GameScreen.GAMEPLAY;
				}
				break;
			}
			case GameScreen.GAMEPLAY: {
				if(Keyboard.is_pressed(Keyboard.Key.ENTER) || Touch.is_gesture_detected(Touch.Gestures.TAP)) {
					currentScreen = GameScreen.ENDING;
				}
				break;
			}
			case GameScreen.ENDING: {
				if(Keyboard.is_pressed(Keyboard.Key.ENTER) || Touch.is_gesture_detected(Touch.Gestures.TAP)) {
					currentScreen = GameScreen.TITLE;
				}
				break;
			}
		}

		window.draw(()=>{
			window.clear_background(RaylibOOP.Color.RAY_WHITE);
			switch(currentScreen) {
				case GameScreen.LOGO: {
					Font.DEFAULT.draw_text("LOGO SCREEN", new Vector2(20, 20), 40, null, Color.LIGHT_GRAY);
					Font.DEFAULT.draw_text("WAIT for 2 SECONDS...", new Vector2(290, 220), 20, null, Color.GRAY);
					break;
				}
				case GameScreen.TITLE: {
					/* Shapes.Rectangle needs to be implemented to continue... */
					break;
				}
			}
		});
		/* Tell Loop to keep going */
		return(true);
	}

	/* Handle Command Line Args */
	public override int handle_local_options(VariantDict args) {
		/* Print Version and Exit */
		if(args.contains("version")) {
			stdout.printf(VERSION);
			Process.exit(0);
		}
		/* Print License and Exit */
		if(args.contains("license")) {
			stdout.printf(LICENSE);
			Process.exit(0);
		}
		/* Run Application */
		return(-1);
	}

	public override void activate() {
		const int screenWidth  = 800;
		const int screenHeight = 450;
		/* Create Window */
		try {
			/* Set the title to the application_id to begin with, so Wayland-based
			 * compositors can figure out their name. Not *technically* needed but
			 * com.example.Example is easier to make rules for than "COOL GAME WINDOW TITLE" */
			window = new Window(screenWidth, screenHeight, this.application_id);
		} catch(WindowError e) {
			error(e.message);
		}
		window.title = "RaylibOOP - core_basic_screen_manager";
		/* Create GLib MainLoop */
		loop = new MainLoop();
		timeout = new TimeoutSource(1);
		timeout.set_callback(this.main_loop);
		timeout.attach(loop.get_context());
		/* Run Main Loop */
		loop.run();
	}

	public static int main(string[] args) {
		/* Create GLib.Application */
		var app = new Game();
		/* Add Command Line Options */
		app.add_main_option("version", 'v', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, "Displays program's version.", null);
		app.add_main_option("license", 'l', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, "Displays program's license.", null);
		/* Run Application */
		app.run(args);
		return(0);
	}
}
