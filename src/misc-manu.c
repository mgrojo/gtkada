#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <glib.h>

#undef GTKADA_DEBUG

/***************************************************
 *  Functions for Objects
 ***************************************************/

gint
ada_object_get_type (GtkObject* object)
{
  return GTK_OBJECT_TYPE (object);
}

gchar*
ada_type_name (gint type)
{
  return gtk_type_name (type);
}

/***************************************************
 *  Functions for GtkArg
 ***************************************************/

gpointer
ada_gtkarg_value_object (GtkArg* args, guint num)
{
  gpointer return_value = NULL;
#ifdef GTKADA_DEBUG
  fprintf (stderr, "ada_gtkarg_value_object read %d\n", args [num].type % 256);
#endif
  switch (args [num].type % 256)
    {
    case GTK_TYPE_OBJECT:
#ifdef GTKADA_DEBUG
      fprintf (stderr, "   was GTK_TYPE_OBJECT\n");
#endif
      return_value = (gpointer)GTK_VALUE_OBJECT (args [num]);
      break;
    case GTK_TYPE_POINTER:
#ifdef GTKADA_DEBUG
      fprintf (stderr, "   was GTK_TYPE_POINTER\n");
#endif
      return_value = (gpointer)GTK_VALUE_POINTER (args [num]);
      break;
    case GTK_TYPE_STRING:
#ifdef GTKADA_DEBUG
      fprintf (stderr, "   was GTK_TYPE_STRING\n");
#endif
      return_value = (gpointer)GTK_VALUE_STRING (args [num]);
      break;
    case GTK_TYPE_BOXED:
#ifdef GTKADA_DEBUG
      fprintf (stderr, "   was GTK_TYPE_BOXED\n");
#endif
      return_value = (gpointer)GTK_VALUE_BOXED (args [num]);
      break;
    default:
      {
	fprintf (stderr, "request for an Object value (%d) when we have a %d\n",
		 GTK_TYPE_OBJECT, (args[num].type % 256));
      }
    }
#ifdef GTKADA_DEBUG
  fprintf (stderr, "    ada_gtkarg_value_object return %p\n", return_value);
#endif
  return return_value;
}

/***************************************************
 *  Functions to get the field of a color selection
 *  dialog
 ***************************************************/

GtkWidget*
ada_colorsel_dialog_get_colorsel (GtkColorSelectionDialog* dialog)
{
  return dialog->colorsel;
}

GtkWidget*
ada_colorsel_dialog_get_ok_button (GtkColorSelectionDialog* dialog)
{
  return dialog->ok_button;
}

GtkWidget*
ada_colorsel_dialog_get_reset_button (GtkColorSelectionDialog* dialog)
{
  return dialog->reset_button;
}

GtkWidget*
ada_colorsel_dialog_get_cancel_button (GtkColorSelectionDialog* dialog)
{
  return dialog->cancel_button;
}

GtkWidget*
ada_colorsel_dialog_get_help_button (GtkColorSelectionDialog* dialog)
{
  return dialog->help_button;
}

/********************************************************
 *  Functions to get the fields of a gamma curve
 ********************************************************/

GtkWidget*
ada_gamma_curve_get_curve (GtkGammaCurve* widget)
{
  return widget->curve;
}

gfloat
ada_gamma_curve_get_gamma (GtkGammaCurve* widget)
{
  return widget->gamma;
}

/******************************************
 ** Functions for Alignment
 ******************************************/

gfloat
ada_alignment_get_xalign (GtkAlignment* widget)
{
   return widget->xalign;
}

gfloat
ada_alignment_get_xscale (GtkAlignment* widget)
{
   return widget->xscale;
}

gfloat
ada_alignment_get_yalign (GtkAlignment* widget)
{
   return widget->yalign;
}

gfloat
ada_alignment_get_yscale (GtkAlignment* widget)
{
   return widget->yscale;
}


/******************************************
 ** Functions for Ruler
 ******************************************/

gfloat
ada_ruler_get_lower (GtkRuler* widget)
{
   return widget->lower;
}

gfloat
ada_ruler_get_max_size (GtkRuler* widget)
{
   return widget->max_size;
}

gfloat
ada_ruler_get_position (GtkRuler* widget)
{
   return widget->position;
}

gfloat
ada_ruler_get_upper (GtkRuler* widget)
{
   return widget->upper;
}

/******************************************
 ** Functions for Editable
 ******************************************/

guint
ada_editable_get_editable (GtkEditable* widget)
{
  return widget->editable;
}

gchar*
ada_editable_get_clipboard_text (GtkEditable* widget)
{
   return widget->clipboard_text;
}

guint
ada_editable_get_current_pos (GtkEditable* widget)
{
   return widget->current_pos;
}

guint
ada_editable_get_has_selection (GtkEditable* widget)
{
   return widget->has_selection;
}

guint
ada_editable_get_selection_end_pos (GtkEditable* widget)
{
   return widget->selection_end_pos;
}

guint
ada_editable_get_selection_start_pos (GtkEditable* widget)
{
   return widget->selection_start_pos;
}

/******************************************
 ** Functions for Aspect_Frame
 ******************************************/

gfloat
ada_aspect_frame_get_ratio (GtkAspectFrame* widget)
{
   return widget->ratio;
}

gfloat
ada_aspect_frame_get_xalign (GtkAspectFrame* widget)
{
   return widget->xalign;
}

gfloat
ada_aspect_frame_get_yalign (GtkAspectFrame* widget)
{
   return widget->yalign;
}

/******************************************
 ** Functions for Text
 ******************************************/

guint
ada_text_get_gap_position (GtkText* widget)
{
   return widget->gap_position;
}

guint
ada_text_get_gap_size (GtkText* widget)
{
   return widget->gap_size;
}

guchar*
ada_text_get_text (GtkText* widget)
{
   return widget->text;
}

guint
ada_text_get_text_end (GtkText* widget)
{
   return widget->text_end;
}

/******************************************
 ** Functions for File_Selection
 ******************************************/

GtkWidget*
ada_file_selection_get_action_area (GtkFileSelection* widget)
{
   return widget->action_area;
}
GtkWidget*
ada_file_selection_get_button_area (GtkFileSelection* widget)
{
   return widget->button_area;
}
GtkWidget*
ada_file_selection_get_cancel_button (GtkFileSelection* widget)
{
   return widget->cancel_button;
}

GtkWidget*
ada_file_selection_get_dir_list (GtkFileSelection* widget)
{
   return widget->dir_list;
}

GtkWidget*
ada_file_selection_get_file_list (GtkFileSelection* widget)
{
   return widget->file_list;
}

GtkWidget*
ada_file_selection_get_help_button (GtkFileSelection* widget)
{
   return widget->help_button;
}

GtkWidget*
ada_file_selection_get_history_pulldown (GtkFileSelection* widget)
{
   return widget->history_pulldown;
}

GtkWidget*
ada_file_selection_get_ok_button (GtkFileSelection* widget)
{
   return widget->ok_button;
}

GtkWidget*
ada_file_selection_get_selection_entry (GtkFileSelection* widget)
{
   return widget->selection_entry;
}

GtkWidget*
ada_file_selection_get_selection_text (GtkFileSelection* widget)
{
   return widget->selection_text;
}

/******************************************
 ** Functions for Dialog
 ******************************************/

GtkWidget*
ada_dialog_get_action_area (GtkDialog* widget)
{
   return widget->action_area;
}

GtkWidget*
ada_dialog_get_vbox (GtkDialog* widget)
{
   return widget->vbox;
}

/******************************************
 ** Functions for Toggle_Button
 ******************************************/

guint
ada_toggle_button_get_active (GtkToggleButton* widget)
{
   return widget->active;
}

/******************************************
 ** Functions for Combo
 ******************************************/

GtkWidget*
ada_combo_get_entry (GtkCombo* widget)
{
  return widget->entry;
}

/*******************************************
 ** Functions for Style
 *******************************************/

GdkColor*
ada_style_get_bg (GtkStyle* style, gint state)
{
  return &(style->bg [state]);
}

/********************************************
 ** Functions for Widget
 ********************************************/

GtkStyle*
ada_widget_get_style (GtkWidget* widget)
{
  return widget->style;
}

GdkWindow*
ada_widget_get_window (GtkWidget* widget)
{
  return widget->window;
}

GtkWidget*
ada_widget_get_parent (GtkWidget* widget)
{
  return widget->parent;
}

GtkSignalFunc
ada_widget_get_motion_notify (GtkWidget* widget)
{
  return (GtkSignalFunc)(GTK_WIDGET_CLASS (GTK_OBJECT (widget)->klass)
			 ->motion_notify_event);
}

/******************************************
 ** Functions for Pixmap
 ******************************************/

GdkBitmap*
ada_pixmap_get_mask (GtkPixmap* widget)
{
   return widget->mask;
}

GdkPixmap*
ada_pixmap_get_pixmap (GtkPixmap* widget)
{
   return widget->pixmap;
}

/*******************************************
 ** Functions for Notebook
 *******************************************/

gint
ada_notebook_get_tab_pos (GtkNotebook* widget)
{
   return widget->tab_pos;
}

GList*
ada_notebook_get_children (GtkNotebook* widget)
{
  return widget->children;
}

GtkNotebookPage*
ada_notebook_get_cur_page (GtkNotebook* widget)
{
  return widget->cur_page;
}

GtkWidget*
ada_notebook_get_menu_label (GtkNotebookPage* widget)
{
  return widget->menu_label;
}

GtkWidget*
ada_notebook_get_tab_label (GtkNotebookPage* widget)
{
  return widget->tab_label;
}

/**********************************************
 ** Functions for Box
 **********************************************/

GtkWidget*
ada_box_get_child (GtkBox* widget, gint num)
{
  if (num < g_list_length (widget->children))
    return ((GtkBoxChild*)(g_list_nth_data (widget->children, num)))->widget;
  else
    return NULL;
}

/**********************************************
 ** Functions for Progress_Bar
 **********************************************/

gfloat
ada_progress_bar_get_percentage (GtkProgressBar* widget)
{
  return widget->percentage;
}

/**********************************************
 ** Functions for Glib.Glist
 **********************************************/

GList*
ada_list_next (GList* list)
{
  if (list)
    return list->next;
  else
    return NULL;
}


GList*
ada_list_prev (GList* list)
{
  if (list)
    return list->prev;
  else
    return NULL;
}

gpointer
ada_list_get_data (GList* list)
{
  return list->data;
}

/**********************************************
 ** Functions for Glib.GSlist
 **********************************************/

GSList*
ada_gslist_next (GSList* list)
{
  if (list)
    return list->next;
  else
    return NULL;
}

gpointer
ada_gslist_get_data (GSList* list)
{
  return list->data;
}

/******************************************
 ** Functions for Fixed
 ******************************************/

GList*
ada_fixed_get_children (GtkFixed* widget)
{
   return widget->children;
}

/******************************************
 ** Functions for Status bar
 ******************************************/

GSList *
ada_status_get_messages (GtkStatusbar* widget)
{
  return widget->messages;
}
