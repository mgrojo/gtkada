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

with Glib; use Glib;
with Gdk.GC;
with Gdk.Point;
with Gdk.Window;

package Gdk.Drawable is

   subtype Gdk_Drawable is Window.Gdk_Window;

   procedure Copy_Area (To       : in Gdk_Drawable;
                        GC       : in Gdk.GC.Gdk_GC;
                        To_X     : in Gint;
                        To_Y     : in Gint;
                        From     : in Gdk.Window.Gdk_Window'Class;
                        Source_X : in Gint;
                        Source_Y : in Gint;
                        Width    : in Gint;
                        Height   : in Gint);

   procedure Draw_Rectangle (Drawable : in Gdk_Drawable;
                             Gc       : in Gdk.GC.Gdk_GC'Class;
                             Filled   : in Boolean := False;
                             X        : in Gint;
                             Y        : in Gint;
                             Width    : in Gint;
                             Height   : in Gint);

   procedure Draw_Point (Drawable : in Gdk_Drawable;
                         Gc       : in Gdk.GC.Gdk_GC'Class;
                         X        : in Gint;
                         Y        : in Gint);

   procedure Draw_Line (Drawable : in Gdk_Drawable;
                        Gc       : in Gdk.GC.Gdk_GC'Class;
                        X1       : in Gint;
                        Y1       : in Gint;
                        X2       : in Gint;
                        Y2       : in Gint);

   procedure Draw_Arc (Drawable : in Gdk_Drawable;
                       Gc       : in Gdk.GC.Gdk_GC'Class;
                       Filled   : in Boolean := False;
                       X        : in Gint;
                       Y        : in Gint;
                       Width    : in Gint;
                       Height   : in Gint;
                       Angle1   : in Gint;
                       Angle2   : in Gint);

   procedure Draw_Polygon (Drawable : in Gdk_Drawable;
                           Gc       : in Gdk.GC.Gdk_GC'Class;
                           Filled   : in Boolean;
                           Points   : in Gdk.Point.Gdk_Points_Array);

   procedure Draw_Pixmap
      (Drawable : in Gdk_Drawable;
       Gc       : in Gdk.GC.Gdk_GC'Class;
       Src      : in Gdk_Drawable'Class;
       Xsrc     : in Gint;
       Ysrc     : in Gint;
       Xdest    : in Gint;
       Ydest    : in Gint;
       Width    : in Gint;
       Height   : in Gint);

end Gdk.Drawable;



