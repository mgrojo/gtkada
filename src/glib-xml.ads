-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--   Copyright (C) 1999-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2003 ACT-Europe                 --
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

--  <description>
--
--  This package provides a simple minded XML parser to be used with
--  Gate.
--
--  </description>

with Unchecked_Deallocation;

generic
   type XML_Specific_Data is private;
   --  The type of the extra data that can be attached to each node of the
   --  XML tree. See for instance the package Glib.Glade.

package Glib.XML is

   --  <doc_ignore>
   procedure Free is new Unchecked_Deallocation (String, String_Ptr);
   --  </doc_ignore>

   type Node;
   type Node_Ptr is access all Node;
   --  Pointer to a node of the XML tree.

   type Node is record
      Tag   : String_Ptr;
      --  The name of this node

      Attributes   : String_Ptr;
      --  The attributes of this node

      Value : String_Ptr;
      --  The value, or null is not relevant

      Parent : Node_Ptr;
      --  The parent of this Node.

      Child : Node_Ptr;
      --  The first Child of this Node. The next child is Child.Next

      Next  : Node_Ptr;
      --  Next sibling node.

      Specific_Data : XML_Specific_Data;
      --  Use to store data specific to each implementation (e.g a boolean
      --  indicating whether this node has been accessed)
   end record;
   --  A node of the XML tree.
   --  Each time a tag is found in the XML file, a new node is created, that
   --  points to its parent, its children and its siblings (nodes at the same
   --  level in the tree and with the same parent).

   function Parse (File : String) return Node_Ptr;
   --  Parse File and return the first node representing the XML file.

   function Parse_Buffer (Buffer : String) return Node_Ptr;
   --  Parse a given Buffer in memory and return the first node representing
   --  the XML contents.

   procedure Print (N : Node_Ptr; File_Name : String := "");
   --  Write the tree starting with N into a file File_Name. The generated
   --  file is valid XML, and can be parsed with the Parse function.
   --  If File_Name is the empty string, then the tree is printed on the
   --  standard output

   function Protect (S : String) return String;
   --  Return a copy of S modified so that it is a valid XML value

   function Find_Tag (N : Node_Ptr; Tag : String) return Node_Ptr;
   --  Find a tag Tag in N and its brothers.

   function Get_Field (N : Node_Ptr; Field : String) return String_Ptr;
   --  Return the value of the field 'Field' if present in the children of N.
   --  Return null otherwise.

   procedure Add_Child (N : Node_Ptr; Child : Node_Ptr);
   --  Add a new child to a node.

   function Deep_Copy (N : Node_Ptr) return Node_Ptr;
   --  Return a deep copy of the tree starting with N. N can then be freed
   --  without affecting the copy.

   type Free_Specific_Data is access
     procedure (Data : in out XML_Specific_Data);

   procedure Free
     (N : in out Node_Ptr; Free_Data : Free_Specific_Data := null);
   --  Free the memory allocated for a node and its children.
   --  It also disconnects N from its parent.
   --  If Free_Data is not null, it is used to free the memory occupied by
   --  the Specific_Data for each node.

   function Get_Attribute
     (N : in Node_Ptr; Attribute_Name : in String) return String;
   --  Return the value of the attribute 'Attribute_Name' if present.
   --  Return null otherwise.

   procedure Set_Attribute
     (N : Node_Ptr; Attribute_Name, Attribute_Value : String);
   --  Create a new attribute, or replace an existing one

end Glib.XML;
