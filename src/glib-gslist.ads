
with System;
with Gtk.Widget;

package Glib.GSlist is

   function Convert (W : Gtk.Widget.Gtk_Widget'Class) return System.Address;
   function Convert (W : System.Address) return Gtk.Widget.Gtk_Widget'Class;

   generic
      type Gpointer (<>) is private;
      with function Convert (P : Gpointer) return System.Address is <>;
      with function Convert (S : System.Address) return Gpointer is <>;
   package Generic_SList is

      type GSlist is private;
      Null_List : constant GSlist;

      procedure Alloc (List : out GSlist);
      procedure Append (List : in out GSlist;
                        Data : in Gpointer);
      function Concat (List1 : in GSlist;
                       List2 : in GSlist)
                       return GSlist;
      procedure Insert (List : in out GSlist;
                        Data : in Gpointer;
                        Position : in Gint);
      function Find (List : in GSlist;
                     Data : in Gpointer)
                     return GSlist;
      procedure Free (List : in out GSlist);
      function Index (List : in GSlist;
                      Data : in Gpointer)
                      return Gint;
      function Last (List : in GSlist)
                     return GSlist;
      function Length (List : in GSlist)
                       return Guint;
      procedure List_Reverse (List : in out GSlist);
      function Next (List : in GSlist)
                     return GSlist;
      function Nth (List : in GSlist;
                    N    : in Guint)
                    return GSlist;
      function Nth_Data (List : in GSlist;
                         N : in Guint)
                         return Gpointer;
      function Position (List : in GSlist;
                         Link : in GSlist)
                         return Gint;
      procedure Prepend (List : in out GSlist;
                         Data : in Gpointer);
      procedure Remove (List : in out GSlist;
                        Data : in Gpointer);
      procedure Remove_Link (List : in out GSlist;
                             Link : in GSlist);
      function Get_Object (Obj : in GSlist)
                           return System.Address;
      pragma Inline (Get_Object);
      procedure Set_Object (Obj    : in out GSlist;
                            Value  : in     System.Address);
      pragma Inline (Set_Object);
   private

      type GSlist is
         record
            Ptr : System.Address := System.Null_Address;
         end record;
      Null_List : constant GSlist := (Ptr => System.Null_Address);
   end Generic_SList;
   --  mapping: Alloc glib.h g_slist_alloc
   --  mapping: Append glib.h g_slist_append
   --  mapping: Concat glib.h g_slist_concat
   --  mapping: Find glib.h g_slist_find
   --  mapping: First glib.h g_slist_first
   --  mapping: Free glib.h g_slist_free
   --  mapping: Index glib.h g_slist_index
   --  mapping: Insert glib.h g_slist_insert
   --  mapping: Last glib.h g_slist_last
   --  mapping: Length glib.h g_slist_length
   --  mapping: List_Reverse glib.h g_slist_reverse
   --  mapping: NOT_IMPLEMENTED glib.h g_slist_foreach
   --  mapping: NOT_IMPLEMENTED glib.h g_slist_free_1
   --  mapping: NOT_IMPLEMENTED glib.h g_slist_previous(list)
   --  mapping: Nth glib.h g_slist_nth
   --  mapping: Nth_Data glib.h g_slist_nth_data
   --  mapping: Position glib.h g_slist_position
   --  mapping: Prepend glib.h g_slist_prepend
   --  mapping: Remove glib.h g_slist_remove
   --  mapping: Remove_Link glib.h g_slist_remove_link

end Glib.GSlist;




