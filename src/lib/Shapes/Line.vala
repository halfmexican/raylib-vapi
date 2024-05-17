using GLib;
using RaylibOOP;
using RaylibOOP.Shapes;

namespace RaylibOOP {
	namespace Shapes {
		public class Line : Object {
			private Line() {
				return;
			}
			/* Methods */
			/**
			* Draw line.
			*/
			public static void draw(Vector2 startPosition, Vector2 endPosition, float? thickness, Color color) {
				if(thickness == null) {
					thickness = 1;
				}
				Raylib.draw_line_ext(startPosition.iVector, endPosition.iVector, thickness, color.iColor);
			}
			/**
			* Draw lines sequence.
			*/
			public static void draw_strip(Vector2[] points, Color color) {
				/* Create an array containing the Vector2 object's internal raylib struct (iVector) */
				var v = new Array<Raylib.Vector2>();
				foreach (var i in points) {
					v.append_val(i.iVector);
				}
				Raylib.draw_line_strip(v.steal(), color.iColor);
			}
			/**
			* Draw line segment cubic-bezier in-out interpolation
			*/
			public static void draw_bezier(Vector2 startPosition, Vector2 endPosition, float thickness, Color color) {
				Raylib.draw_line_bezier(startPosition.iVector, endPosition.iVector, thickness, color.iColor);
			}

		}
	}
}