[CCode (cheader_filename = "hoedown/html.h")]
namespace Hoedown {
	/**
	 * Verify that a URL has a safe protocol.
	 */
	[CCode (cname = "hoedown_autolink_is_safe")]
	public static bool is_safe (uint8[] url);

	public const string HOEDOWN_VERSION;
	public const int HOEDOWN_VERSION_MAJOR;
	public const int HOEDOWN_VERSION_MINOR;
	public const int HOEDOWN_VERSION_REVISION;

	[CCode (cname = "hoedown_renderer", free_function = "hoedown_html_renderer_free")]
	[Compact]
	public class HtmlRenderer {
		public HtmlRenderer (HtmlFlags render_flags, int nesting_level);

		/**
		 * Like The returned renderer produces the Table of Contents
		 */
		[CCode (cname = "hoedown_html_toc_renderer_new")]
		public HtmlRenderer.with_toc (int nesting_level);

		/**
		 * Process an HTML snippet using SmartyPants for smart punctuation.
		 */
		public void smartypants (uint8[] html);

		/**
		 * Checks if data starts with a specific tag, returns the tag type or NONE.
		 */
		public static HtmlTag is_tag (uint8[] data, string tagname);
	}

	[CCode (cname = "hoedown_html_flags", cprefix = "HOEDOWN_HTML_", has_type_id = false)]
	[Flags]
	public enum HtmlFlags {
		SKIP_HTML,
		ESCAPE,
		HARD_WRAP,
		USE_XHTML
	}

	[CCode (cname = "hoedown_html_tag", cprefix = "HOEDOWN_HTML_TAG", has_type_id = false)]
	public enum HtmlTag {
		HOEDOWN_HTML_TAG_NONE = 0,
		HOEDOWN_HTML_TAG_OPEN,
		HOEDOWN_HTML_TAG_CLOSE
	}

	[CCode (cname = "hoedown_buffer", free_function = "hoedown_buffer_free")]
	[Compact]
	public class Buffer {
		public Buffer (int unit);

		/**
		 * Free internal data of the buffer.
		 */
		public void reset ();

		/**
		 * Get the contents of the buffer as a string.
		 */
		[CCode (cname = "hoedown_buffer_cstr")]
		public unowned string to_string ();

		/**
		 * Increase the allocated size to the given value.
		 */
		public void grow (int size);

		/**
		 * Append data to the buffer.
		 */
		public void put (uint8[] data);

		/**
		 * Replace the buffer's contents with data.
		 */
		public void set (uint8[] data);

		/**
		 * Compare a buffer's data with other data for equality.
		 */
		[CCode (cname = "hoedown_buffer_eq")]
		public bool equals (uint8[] data);

		/**
		 * Compare the beginning of a buffer with a string.
		 */
		public bool prefix (string prefix);

		/**
		 * Remove a given number of bytes from the head of the buffer.
		 */
		public void slurp (int size);

		/**
		 * Search for the next www link in data.
		 */
		[CCode (cname = "hoedown_autolink__www", instance_pos = 1.1)]
		public int next_www (int rewind_p, Buffer link, [CCode (array_length_pos = 3.1)] uint8[] data, int offset, AutolinkFlags flags);

		/**
		 * Search for the next email in data.
		 */
		[CCode (cname = "hoedown_autolink__email", instance_pos = 1.1)]
		public int next_email (int rewind_p, [CCode (array_length_pos = 3.1)] uint8[] data, int offset, AutolinkFlags flags);

		/**
		 * Search for the next URL in data.
		 */
		[CCode (cname = "hoedown_autolink__url", instance_pos = 1.1)]
		public int next_url (int rewind_p, [CCode (array_length_pos = 3.1)] uint8[] data, int offset, AutolinkFlags flags);

		/**
		 * Escape (part of) a URL inside HTML.
		 */
		[CCode (cname = "hoedown_escape_href")]
		public void escape_href (uint8[] data);

		/**
		 * Escape HTML.
		 */
		[CCode (cname = "hoedown_escape_html")]
		public static void escape_html (uint8[] data, bool secure);
	}

	[CCode (cname = "hoedown_document", free_function = "hoedown_document_free")]
	[Compact]
	public class Document {
		public Document (HtmlRenderer renderer, Extensions extensions, int max_nesting);

		/**
		 * Render regular Markdown using the document processor.
		 */
		public void render (Buffer html, uint8[] markdown);

		/**
		 * Render inline Markdown using the document processor
		 */
		public void render_inline (Buffer html, uint8[] markdown);
	}

	[CCode (cname = "hoedown_extensions", cprefix = "HOEDOWN_EXT_", has_type_id = false)]
	[Flags]
	public enum Extensions {
		/* block-level extensions */
		TABLES,
		FENCED_CODE,
		FOOTNOTES,

		/* span-level extensions */
		AUTOLINK,
		STRIKETHROUGH,
		UNDERLINE,
		HIGHLIGHT,
		QUOTE,
		SUPERSCRIPT,
		MATH,

		/* spacer */
		DO_NOT_USE,

		/* other flags */
		NO_INTRA_EMPHASIS,
		SPACE_HEADERS,
		MATH_EXPLICIT,

		/* negative flags */
		DISABLE_INDENTED_CODE
	}

	[CCode (cname = "hoedown_list_flags", cprefix = "HOEDOWN_", has_type_id = false)]
	[Flags]
	public enum ListFlags {
		LIST_ORDERED,
		LI_BLOCK	/* <li> containing block data */
	}

	[CCode (cname = "hoedown_table_flags", cprefix = "HOEDOWN_TABLE_", has_type_id = false)]
	public enum TableFlags {
		ALIGN_LEFT,
		ALIGN_RIGHT,
		ALIGN_CENTER,
//		ALIGNMASK, Same as ALIGN_CENTER
		HEADER
	}

	[CCode (cname = "hoedown_autolink_type", cprefix = "HOEDOWN_AUTOLINK_", has_type_id = false)]
	public enum AutolinkType {
		NONE,	/* used internally when it is not an autolink*/
		NORMAL,	/* normal http/http/ftp/mailto/etc link */
		EMAIL	/* e-mail link without explit mailto: */
	}

	[CCode (cname = "hoedown_autolink_flags", cprefix = "HOEDOWN_AUTOLINK_", has_type_id = false)]
	[Flags]
	public enum AutolinkFlags {
		SHORT_DOMAINS
	}

	[CCode (cname = "hoedown_stack", destroy_function = "hoedown_stack_uninit", has_type_id = false)]
	public struct Stack {
		void **item;
		int size;
		int asize;

		[CCode (cname = "hoedown_stack_init")]
		public Stack (int initial_size);

		/**
		 * Increase the allocated size to the given value
		 */
		public void grow (int size);

		/**
		 * Push an item to the top of the stack.
		 */
		public void push (void *item);

		/**
		 * Retrieve and remove the item at the top of the stack.
		 */
		public void* pop ();

		/**
		 * Retrieve the item at the top of the stack.
		 */
		public void* top ();
	}
}