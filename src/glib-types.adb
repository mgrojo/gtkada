-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                Copyright (C) 2006 AdaCore                         --
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

with Glib.Object;  use Glib.Object;
with System;       use System;

package body Glib.Types is

   ----------------
   -- Implements --
   ----------------

   package body Implements is

      ---------------
      -- To_Object --
      ---------------

      function To_Object (Interf : Interface_Type) return Object_Type is
         Stub : Object_Type_Record;
      begin
         return Object_Type
           (Get_User_Data (System.Address (Interf), Stub));
      end To_Object;

      ------------------
      -- To_Interface --
      ------------------

      function To_Interface
        (Object : access Object_Type_Record'Class) return Interface_Type is
      begin
         return Interface_Type (Get_Object (Object));
      end To_Interface;
   end Implements;

   ---------------
   -- To_Object --
   ---------------

   function To_Object
     (Interf : GType_Interface) return Glib.Object.GObject
   is
      Stub : GObject_Record;
   begin
      return GObject (Get_User_Data (System.Address (Interf), Stub));
   end To_Object;

   ----------------
   -- Interfaces --
   ----------------

   function Interfaces (T : GType) return GType_Array is
      type Flat_GType_Array is array (Guint) of GType;
      pragma Convention (C, Flat_GType_Array);
      type Flat_GType_Array_Access is access all Flat_GType_Array;

      procedure G_Free (S : Flat_GType_Array_Access);
      pragma Import (C, G_Free, "g_free");

      function Internal
        (T        : GType;
         N_Ifaces : access Guint) return Flat_GType_Array_Access;
      pragma Import (C, Internal, "g_type_interfaces");

      N_Ids  : aliased Guint;
      Result : constant Flat_GType_Array_Access := Internal (T, N_Ids'Access);

   begin
      if N_Ids = 0 then
         return (1 .. 0 => GType_Invalid);
      else
         declare
            R : constant GType_Array := GType_Array (Result (0 .. N_Ids - 1));
         begin
            G_Free (Result);
            return R;
         end;
      end if;
   end Interfaces;

   ------------------
   -- Is_Interface --
   ------------------

   function Is_Interface (T : GType) return Boolean is
      function Internal (T : GType) return Gboolean;
      pragma Import (C, Internal, "ada_g_type_is_interface");
   begin
      return Boolean'Val (Internal (T));
   end Is_Interface;

   ----------
   -- Is_A --
   ----------

   function Is_A (T : GType; Is_A_Type : GType) return Boolean is
      function Internal (T1, T2 : GType) return Gboolean;
      pragma Import (C, Internal, "g_type_is_a");
   begin
      return Boolean'Val (Internal (T, Is_A_Type));
   end Is_A;


end Glib.Types;