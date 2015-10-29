Hoedown Vala
=============
These are quick hoedown bindings for the vala language. Most of the functions have yet to be tested so there are sure to be bugs.

Example
-------------


	using Hoedown;

	class Demo.HelloWorld : GLib.Object {
		public static void main(string[] args) {
			var renderer = new HtmlRenderer (0, 0);
			var doc = new Document (renderer, 0, 16);
			var html = new Buffer (16);
			var md = "#Header!\nHere's some *content*.";
			doc.render (html, md.data);

			stdout.printf(html.to_string ());
		}
	}
	
