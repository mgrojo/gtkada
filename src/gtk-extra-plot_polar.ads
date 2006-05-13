-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--      Copyright (C) 2000 E. Briot, J. Brobecker and A. Charlet     --
--                Copyright (C) 2000-2006 AdaCore                    --
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
--  This special type of data set displays itself in polar coordinates.
--  </description>
--  <c_version>gtkextra 2.1.1</c_version>

with Gtk.Extra.Plot;
with Gdk.Drawable;

package Gtk.Extra.Plot_Polar is

   type Gtk_Plot_Polar_Record is new Gtk.Extra.Plot.Gtk_Plot_Record
     with private;
   type Gtk_Plot_Polar is access all Gtk_Plot_Polar_Record'Class;

   procedure Gtk_New
     (Polar         : out Gtk_Plot_Polar;
      Drawable      : Gdk.Drawable.Gdk_Drawable := null;
      Width, Height : Gdouble := 0.0);
   --  Create a new polar plot.
   --  If Width and Height are 0, they are left unspecified when calling the
   --  C function.

   procedure Initialize
     (Polar         : access Gtk_Plot_Polar_Record'Class;
      Drawable      : Gdk.Drawable.Gdk_Drawable;
      Width, Height : Gdouble := 0.0);
   --  Internal initialization function.
   --  See the section "Creating your own widgets" in the documentation.

   function Get_Type return Gtk.Gtk_Type;
   --  Return the internal value associated with a Gtk_Box

   procedure Rotate (Polar : access Gtk_Plot_Polar_Record; Angle : Gdouble);
   --  Rotate the graph by a given amount of radians.

   function Get_Angle (Polar : access Gtk_Plot_Polar_Record) return Gdouble;
   --  Return the current angle for the polar plot

private
   type Gtk_Plot_Polar_Record is new Gtk.Extra.Plot.Gtk_Plot_Record
     with null record;
   pragma Import (C, Get_Type, "gtk_plot_polar_get_type");
end Gtk.Extra.Plot_Polar;
