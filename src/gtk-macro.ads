with Gdk.Event;
with Gtk.Widget;
with Gdk.Types;
with Ada.Text_IO;

package Gtk.Macro is

private

   type String_Access is access String;
   type File_Buffer is record
      Buffer : String_Access;
      Index  : Natural;
   end record;


   type Identifier_Type is (None, Name, Title, Transient, Label);
   --  The different ways we have to identify a widget.
   --  To make the macros as robust as possible with regards to GUI changes,
   --  we try to associate each event with the closest widget (ie we try to
   --  go up in the widget tree as less as possible).
   --  For this, there are different strategies that can be used to identify
   --  each widget, and this type defines which strategy was used.
   --
   --  - None: No Identifier could be defined for the widget
   --  - Name: The Name of the widget was used. This is the prefered way,
   --          since the name, being hidden, won't have to change. However,
   --          no such name exist by default and the users have to explicitly
   --          set one.
   --  - Title: For top-level windows, it is possible to use the window's
   --          title. Although this will probably change if the application is
   --          translated to another language, it is easy to also translate
   --          the recorded macros.
   --  - Transient: Some top-level windows don't have a title (menus,...). They
   --          might, however, have a transient parent, whose title we could
   --          use to locate the window.
   --  - Label: Some widgets (buttons, menu items,...) generally contains a
   --          single label, whose text we can use to locate the widget.

   type Identifier is record
      Id_Type : Identifier_Type;
      Id      : String_Access;
   end record;
   --  An identifier for a widget


   type Macro_Item;
   type Macro_Item_Access is access all Macro_Item'Class;

   --  These types have to be in the specs so that the operations below
   --  are dispatching

   ----------------
   -- Macro_Item --
   ----------------

   type Macro_Item is abstract tagged
      record
         Id           : Identifier;
         Event_Type   : Gdk.Types.Gdk_Event_Type;
         Next         : Macro_Item_Access;
         Widget_Depth : Natural := 0;
         X            : Gint := 0;
         Y            : Gint := 0;
      end record;
   --  Widget_Depth is 0 if the event was actually sent to the widget
   --  whose name is Widget_Name, and not to one of its children.
   --  (X, Y) are used to find the child in case Widget_Depth is not null.
   --  This might not be relevant for some events, in which case
   --  Widget_Depth should absolutely be 0.
   --  The search for the actual widget is done in Widget_Name and its children
   --  no deeper than Widget_Depth, and while (X, Y) is in a child.

   function Create_Event
     (Item : Macro_Item;
      Widget : access Gtk.Widget.Gtk_Widget_Record'Class)
      return Gdk.Event.Gdk_Event is abstract;
   --  Creates the matching event. The event is considered to have been
   --  send to Widget.

   procedure Save_To_Disk (File : Ada.Text_IO.File_Type; Item : Macro_Item);
   --  Saves the item to the disk

   procedure Load_From_Disk (File : access File_Buffer; Item : out Macro_Item);
   --  Load an item from the disk


   ----------------------------
   -- Macro_Item_Mouse_Press --
   ----------------------------

   type Macro_Item_Mouse_Press is new Macro_Item with record
      Button : Guint;
      State  : Gdk.Types.Gdk_Modifier_Type;
      Time   : Guint32 := 0;
   end record;

   type Macro_Item_Mouse_Press_Access is
     access all Macro_Item_Mouse_Press'Class;

   function Create_Event
     (Item : Macro_Item_Mouse_Press;
      Widget : access Gtk.Widget.Gtk_Widget_Record'Class)
      return Gdk.Event.Gdk_Event;

   procedure Save_To_Disk
     (File : Ada.Text_IO.File_Type; Item : Macro_Item_Mouse_Press);

   procedure Load_From_Disk
     (File : access File_Buffer; Item : out Macro_Item_Mouse_Press);

   -------------------------
   -- Macro_Item_Crossing --
   -------------------------

   type Macro_Item_Crossing is new Macro_Item with record
      Mode   : Gdk.Types.Gdk_Crossing_Mode;
      State  : Gdk.Types.Gdk_Modifier_Type;
      Detail : Gdk.Types.Gdk_Notify_Type;
      Time   : Guint32 := 0;
      Focus  : Boolean;
   end record;
   type Macro_Item_Crossing_Access is access all Macro_Item_Crossing'Class;

   function Create_Event
     (Item : Macro_Item_Crossing;
      Widget : access Gtk.Widget.Gtk_Widget_Record'Class)
      return Gdk.Event.Gdk_Event;

   procedure Save_To_Disk
     (File : Ada.Text_IO.File_Type;
      Item : Macro_Item_Crossing);

   procedure Load_From_Disk
     (File : access File_Buffer;
      Item : out Macro_Item_Crossing);

   --------------------
   -- Macro_Item_Key --
   --------------------

   type Macro_Item_Key is new Macro_Item with record
      State  : Gdk.Types.Gdk_Modifier_Type;
      Time   : Guint32 := 0;
      Keyval : Gdk.Types.Gdk_Key_Type;
      Str    : String_Access;
   end record;
   type Macro_Item_Key_Access is access all Macro_Item_Key'Class;

   function Create_Event
     (Item : Macro_Item_Key;
      Widget : access Gtk.Widget.Gtk_Widget_Record'Class)
      return Gdk.Event.Gdk_Event;

   procedure Save_To_Disk
     (File : Ada.Text_IO.File_Type;
      Item : Macro_Item_Key);

   procedure Load_From_Disk
     (File : access File_Buffer;
      Item : out Macro_Item_Key);

   -----------------------
   -- Macro_Item_Motion --
   -----------------------

   type Macro_Item_Motion is new Macro_Item with record
      Time   : Guint32 := 0;
      State  : Gdk.Types.Gdk_Modifier_Type;
   end record;
   type Macro_Item_Motion_Access is access all Macro_Item_Motion'Class;

   function Create_Event
     (Item : Macro_Item_Motion;
      Widget : access Gtk.Widget.Gtk_Widget_Record'Class)
      return Gdk.Event.Gdk_Event;

   procedure Save_To_Disk
     (File : Ada.Text_IO.File_Type;
      Item : Macro_Item_Motion);

   procedure Load_From_Disk
     (File : access File_Buffer;
      Item : out Macro_Item_Motion);

end Gtk.Macro;
