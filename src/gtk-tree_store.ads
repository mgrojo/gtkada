-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                     Copyright (C) 2001                            --
--                         ACT-Europe                                --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with Glib.Values; use Glib.Values;
with Gtk;
with Gtk.Tree_Model;

package Gtk.Tree_Store is

   type Gtk_Tree_Store_Record is
     new Gtk.Tree_Model.Gtk_Tree_Model_Record with private;
   type Gtk_Tree_Store is access all Gtk_Tree_Store_Record'Class;

   procedure Gtk_New
     (Widget    : out Gtk_Tree_Store;
      N_Columns : Gint;
      Types     : GType_Array);
   --  Creates a new tree store as with N_Columns columns each of
   --  the types passed in.

   procedure Initialize
     (Widget    : access Gtk_Tree_Store_Record'Class;
      N_Columns : Gint;
      Types     : GType_Array);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with this widget.

   procedure Set_Value
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Column     : Gint;
      Value      : in out Glib.Values.GValue);

   procedure Set_Value
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Column     : Gint;
      Value      : System.Address);

   procedure Remove
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter);
   --  Removes Iter from Tree_Store.  After being removed, Iter is set to
   --  the next valid row at that level, or invalidated if it previeously
   --  pointed to the last one.

   procedure Insert
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Parent     : Gtk.Tree_Model.Gtk_Tree_Iter;
      Position   : Gint);
   --  Creates a new row at Position.  If parent is non-null, then the row
   --  will be made a child of Parent. Otherwise, the row will be created at
   --  the toplevel. If Position is larger than the number of rows at that
   --  level, then the new row will be inserted to the end of the list.  Iter
   --  will be changed to point to this new row.  The row will be empty before
   --  this function is called.  To fill in values, you need to call Set_Value.

   procedure Insert_Before
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Parent     : Gtk.Tree_Model.Gtk_Tree_Iter;
      Sibling    : Gtk.Tree_Model.Gtk_Tree_Iter);
   --  Inserts a new row before Sibling.  If Sibling is Null_Iter, then the
   --  row will be appended to the beginning of the Parent 's children.
   --  If Parent and Sibling are Null_Iter, then the row will be appended to
   --  the toplevel.  If both Sibling and Parent are set, then Parent must
   --  be the parent of Sibling. When Sibling is set, Parent is optional.
   --  Iter will be changed to point to this new row.  The row will be empty
   --  after this function is called.  To fill in values, you need to call
   --  Set_Value.

   procedure Insert_After
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Parent     : Gtk.Tree_Model.Gtk_Tree_Iter;
      Sibling    : Gtk.Tree_Model.Gtk_Tree_Iter);
   --  Inserts a new row after Sibling.  If Sibling is Null_Iter, then the
   --  row will be prepended to the beginning of the Parent 's children.
   --  If Parent and Sibling are Null_Iter, then the row will be prepended
   --  to the toplevel.  If both Sibling and Parent are set, then Parent
   --  must be the parent of Sibling When Sibling is set, Parent is optional.
   --  Iter will be changed to point to this new row.  The row will be empty
   --  after this function is called.  To fill in values, you need to call
   --  Set_Value.

   procedure Prepend
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Parent     : Gtk.Tree_Model.Gtk_Tree_Iter);
   --  Prepends a new row to Tree_Store.  If Parent is non-NULL, then it
   --  will prepend the new row before the first child of Parent, otherwise
   --  it will prepend a row to the top level.  Iter will be changed to point
   --  to this new row.  The row will be empty after this function is called.
   --  To fill in values, you need to call Set_Value.

   procedure Append
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : in out Gtk.Tree_Model.Gtk_Tree_Iter;
      Parent     : Gtk.Tree_Model.Gtk_Tree_Iter);
   --  Appends a new row to Tree_Store.  If Parent is non-NULL, then it will
   --  append the new row after the last child of Parent, otherwise it will
   --  append a row to the top level.  Iter will be changed to point to this
   --  new row.  The row will be empty after this function is called.  To
   --  fill in values, you need to call Set_Value.

   function Is_Ancestor
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter;
      Descendant : Gtk.Tree_Model.Gtk_Tree_Iter)
      return Boolean;
   --  Returns True if Iter is an ancestor of Descendant.  That is, Iter is the
   --  parent (or grandparent or great-grandparent) of Descendant.

   function Iter_Depth
     (Tree_Store : access Gtk_Tree_Store_Record;
      Iter       : Gtk.Tree_Model.Gtk_Tree_Iter)
     return Gint;
   --  Returns the depth of Iter.  This will be 0 for anything on the root
   --  level, 1 for anything down a level, etc.

   procedure Clear (Tree_Store : access Gtk_Tree_Store_Record);
   --  Removes all rows from Tree_Store

   -------------
   -- Signals --
   -------------

   --  <signals>
   --  The following new signals are defined for this widget:
   --
   --  </signals>

private
   type Gtk_Tree_Store_Record is
     new Gtk.Tree_Model.Gtk_Tree_Model_Record with null record;

   pragma Import (C, Get_Type, "gtk_tree_store_get_type");
end Gtk.Tree_Store;

--  ??? Missing : drag-and-drop stuff
