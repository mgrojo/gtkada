-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
-- Copyright (C) 1998 Emmanuel Briot and Joel Brobecker              --
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

with System;
with Gdk; use Gdk;

package body Gtk.Check_Menu_Item is

   ----------------
   -- Get_Active --
   ----------------

   function Get_Active (Check_Menu_Item : in Gtk_Check_Menu_Item)
                        return Boolean
   is
      function Internal (Item : System.Address) return Guint;
      pragma Import (C, Internal, "ada_check_menu_item_get_active");
   begin
      return Internal (Get_Object (Check_Menu_Item)) /= 0;
   end Get_Active;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Widget : out Gtk_Check_Menu_Item; Label  : in String) is
      function Internal (Label  : in String) return System.Address;
      pragma Import (C, Internal, "gtk_check_menu_item_new_with_label");
   begin
      Set_Object (Widget, Internal (Label & Ascii.NUL));
   end Gtk_New;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Widget : out Gtk_Check_Menu_Item) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_check_menu_item_new");
   begin
      Set_Object (Widget, Internal);
   end Gtk_New;

   ---------------------
   -- Set_Show_Toggle --
   ---------------------

   procedure Set_Show_Toggle (Menu_Item : in Gtk_Check_Menu_Item;
                              Always    : in Boolean)
   is
      procedure Internal (Menu_Item : in System.Address; Always : in Gint);
      pragma Import (C, Internal, "gtk_check_menu_item_set_show_toggle");
   begin
      Internal (Get_Object (Menu_Item), Boolean'Pos (Always));
   end Set_Show_Toggle;

   ---------------
   -- Set_State --
   ---------------

   procedure Set_State (Check_Menu_Item : in Gtk_Check_Menu_Item;
                        State           : in Boolean)
   is
      procedure Internal (Check_Menu_Item : in System.Address;
                          State           : in Gint);
      pragma Import (C, Internal, "gtk_check_menu_item_set_state");
   begin
      Internal (Get_Object (Check_Menu_Item), Boolean'Pos (State));
   end Set_State;

   -------------
   -- Toggled --
   -------------

   procedure Toggled (Check_Menu_Item : in Gtk_Check_Menu_Item) is
      procedure Internal (Check_Menu_Item : in System.Address);
      pragma Import (C, Internal, "gtk_check_menu_item_toggled");
   begin
      Internal (Get_Object (Check_Menu_Item));
   end Toggled;

end Gtk.Check_Menu_Item;
