"""
Parses the file binding.xml, which is used to override some aspects of
the automatically generated code.
The syntax of that file is as follows:
    <?xml version="1.0"?>
    <GIR>
       <package />   <!--  repeated as often as needed
    </GIR>

Where the package node is defined as follows:
    <package id="..."       <!-- mandatory -->
             obsolescent="..." <!--  Whether this package is obsolete -->
    >
       <doc screenshot="..." <!-- optional -->
            group="..."      <!-- optional -->
            testgtk="..."    <!-- optional -->
            see="..."        <!-- optional -->
       >
       package-level documentation
       </doc>

       <type               <!-- repeated as needed ->
           name="..."      <!-- mandatory, Ada type name -->
           subtype="True"  <!-- optional, if True generate a subtype -->
       />

       <parameter
           name="..."
           ada="..."       <!-- Override default naming for all methods.
                                In particular used for "Self" -->
           type="..."      <!-- Override Ada types for all methods -->
           ctype="..."     <!-- Override C type (to better qualify it) -->
       />

       <!-- The following tag can be used to override various properties from
            the GIR file.

            It is also possible to indicate that a method should not be bound
            (or that a method inherited from an interface should not be
            repeated in the binding, by setting the "bind" attribute to False.
       -->

       <method             <!-- repeated as needed -->
           id="..."        <!-- mandatory, name of the C method -->
                           <!-- fields are not bound by default, but are
                                associated with
                                    "gtkada_%s_get_%s" % (adapkg, field_name)
                                methods
                                For signals, we use "package::signal"
                           -->
           ada="..."       <!-- optional, name of the Ada subprogram -->
           bind="true"     <!-- optional, if false no binding generated -->
           obsolescent=".." <!--  Whether this method is obsolete" -->
           into="..."      <!-- optional, name of C class in which to
                                add the bindings -->
           transfer-ownership='none'  <!-- set to 'full' to indicate the return
                                value must be freed by the caller -->
           return_as_param="..." <!-- optional, replace return parameter with
                                an out parameter with this name -->
           return="..."    <!-- Override C type for the returned value, or
                                "void" to change into procedure. -->
       >
         <doc extend="..."> <!-- if extend is true, append to doc from GIR -->
            ...            <!-- "\n" forces a newline, paragraphs are created
                                on empty lines. A paragraph that starts with
                                '%PRE%' will be displayed exactly as is, no
                                line wrapping is done.-->
         </doc>
         <parameter        <!-- repeated as needed -->
            name="..."     <!-- mandatory, lower-cased name of param -->
            ada="..."      <!-- optional, name to use in Ada -->
            type="..."     <!-- optional, override Ada type -->
            ctype="..."    <!-- Override C type (to better qualify it) -->
            default="..."  <!-- optional, the default value for the param-->
            direction=".." <!-- optional, "in", "out" or "inout" -->
            allow-none="0" <!-- If C accepts a NULL value (an empty string
                                is mapped to the null pointer -->
         />
         <body>...</body>  <!-- optional, body of subprogram including
                                profile -->
       />

       <function id="...">   <!--  repeated as needed, for global functions -->
                             <!--  content is same as <method> -->
       </function>

       <!-- The following statement indicates that the binding for the
            enumeration should be added in the current package.
            This automatically generates the naming exceptions for the type
            and its values, but you can override the mapping by:
              * adding entries in data.py (cname_to_adaname)
                For instance:    "GTK_SIZE_GROUP_NONE": "None"
              * or setting the prefix attribute, for instance
                 prefix="GTK_SIZE_GROUP_"
       -->
       <enum ctype="..."
             ada="..."     <!-- optional Ada name (no package info needed) -->
             prefix="GTK_" <!-- remove prefix from values to get Ada name -->
       />

       <!-- Support for <record> types -->
       <record ctype="..."
             ada="..."     <!-- optional Ada name (no package info needed) -->
       />

       <!-- Instantiates a list of elements -->

       <list ada="Ada name for the list type"
             ctype="..."/>  <!--  Name of the element contained in the list -->
       <slist ada="Ada name for the list type"  <!-- single-linked list -->
             ctype="..."/>  <!--  Name of the element contained in the list -->

       <extra>
          <gir:method>...  <!-- optional, same nodes as in the .gir file -->
          <with_spec pkg="..." use="true"/>
                           <!-- extra with clauses for spec -->
          <with_body pkg="..." use="true"/>
                           <!-- extra with clauses for body -->

          <!-- Code will be put after generated subprograms-->
          <spec>...     <!-- optional, code to insert in spec -->
          <body>...     <!-- optional, code to insert in body -->

          <type            <!-- Maps a C type to an Ada type -->
             ctype="..."   <!-- Mandatory: c type name -->
             ada="..."     <!-- Mandatory: ada type name -->
          >
             code          <!-- Optional, the type declaration, will be put
                                after generated types but before subprograms-->
          </type>
       </extra>
    </package>
"""

from xml.etree.cElementTree import parse, QName, tostring
from adaformat import AdaType, CType, Proxy, List, naming, Enum


class GtkAda(object):

    def __init__(self, filename):
        self._tree = parse(filename)
        self.root = self._tree.getroot()
        self.packages = dict()
        for node in self.root:
            if node.tag == "package":
                self.packages[node.get("id")] = GtkAdaPackage(node)

    def get_pkg(self, pkg):
        """Return the GtkAdaPackage for a given package"""
        return self.packages.get(pkg, GtkAdaPackage(None))


class GtkAdaPackage(object):
    """A <package> node in the binding.xml file"""

    def __init__(self, node):
        self.node = node
        self.doc = []

        # If we are going to generate some enumerations in the package, we
        # need to register them now, so that all places where the enumeration
        # is referenced have the proper full name.

        if node:
            for enum in node.findall("enum"):
                Enum.register_ada_decl(pkg=node.get("id"),
                                       ctype=enum.get("ctype"),
                                       ada=enum.get("ada", None))
            for rec in node.findall("record"):
                Proxy.register_ada_record(
                    pkg=node.get("id"),
                    ctype=rec.get("ctype"),
                    ada=rec.get("ada", None))
            for rec in node.findall("list"):
                List.register_ada_list(
                    pkg=node.get("id"),
                    ctype=rec.get("ctype"),
                    ada=rec.get("ada", None))
            for rec in node.findall("slist"):
                List.register_ada_list(
                    pkg=node.get("id"),
                    ctype=rec.get("ctype"),
                    ada=rec.get("ada", None),
                    single=True)

    def enumerations(self):
        """List of all enumeration types that need to be declared in the
           package. The result is a list of Enum() instances.
        """
        result = []
        if self.node:
            for enum in self.node.findall("enum"):
                result.append((enum.get("ctype"),
                               naming.type(name="", cname=enum.get("ctype")),
                               enum.get("prefix", "GTK_")))
        return result

    def lists(self):
        """Return the list of list instantiations we need to add to the
           package. Returns a list of tuples:
              [(adaname, CType for element, true for a single-linked list), ..]
        """
        result = []
        if self.node:
            for l in self.node.findall("list"):
                result.append((l.get("ada"),
                               naming.type(name="", cname=l.get("ctype")),
                               False))
            for l in self.node.findall("slist"):
                result.append((l.get("ada"),
                               naming.type(name="", cname=l.get("ctype")),
                               True))

        return result

    def records(self):
        """Returns the list of record types, as a list of tuples:
               [ (ctype name,  corresponding CType, [fields]) ...]
           Where fields is a dict for each field whose type is
           overridden:
               { name: CType, ... }
        """

        result = []
        if self.node:
            for rec in self.node.findall("record"):
                override_fields = {}

                for field in rec.findall("field"):
                    override_fields[field.get("name")] = \
                        naming.type(name="", cname=field.get("ctype"))

                result.append((rec.get("ctype"),
                               naming.type(name="", cname=rec.get("ctype")),
                               override_fields))
        return result

    def get_doc(self):
        """Return the overridden doc for for the package, as a list of
           string. Each string is a paragraph
        """
        if self.node is None:
            return []

        docnode = self.node.find("doc")
        if docnode is None:
            return []

        text = docnode.text or ""
        doc = []

        if text:
            descr = []
            for paragraph in text.split("\n\n"):
                descr.append(paragraph)

            doc = ["<description>\n"]
            doc.extend(descr)
            doc.append("</description>")

        n = docnode.get("screenshot")
        if n is not None:
            doc.append("<screenshot>%s</screenshot>" % n)

        n = docnode.get("group")
        if n is not None:
            doc.append("<group>%s</group>" % n)

        n = docnode.get("testgtk")
        if n is not None:
            doc.append("<testgtk>%s</testgtk>" % n)

        n = docnode.get("see")
        if n is not None:
            doc.append("<see>%s</see>" % n)

        return doc

    def get_method(self, cname):
        if self.node is not None:
            for f in self.node.findall("method"):
                if f.get("id") == cname:
                    return GtkAdaMethod(f, self)
        return GtkAdaMethod(None, self)

    def get_type(self, name):
        if self.node is not None:
            name = name.lower()
            for f in self.node.findall("type"):
                if f.get("name").lower() == name:
                    return GtkAdaType(f)
        return GtkAdaType(None)

    def into(self):
        if self.node is not None:
            return self.node.get("into", None)
        return None

    def is_obsolete(self):
        if self.node is not None:
            return self.node.get("obsolescent", "False").lower() == "true"
        return False

    def extra(self):
        if self.node is not None:
            extra = self.node.find("extra")
            if extra is not None:
                return extra.getchildren()
        return None

    def get_default_param_node(self, name):
        if name and self.node is not None:
            name = name.lower()
            for p in self.node.findall("parameter"):
                if p.get("name") == name:
                    return p
        return None

    def get_global_functions(self):
        """Return the list of global functions that should be bound as part
           of this package.
        """
        if self.node is not None:
            return [GtkAdaMethod(c, self)
                    for c in self.node.findall("function")]
        return []


class GtkAdaMethod(object):
    def __init__(self, node, pkg):
        self.node = node
        self.pkg  = pkg

    def cname(self):
        """Return the name of the C function"""
        return self.node.get("id")

    def get_param(self, name):
        default = self.pkg.get_default_param_node(name)
        if self.node is not None:
            name = name.lower()
            for p in self.node.findall("parameter"):
                if p.get("name").lower() == name:
                    return GtkAdaParameter(p, default=default)

        return GtkAdaParameter(None, default=default)

    def bind(self, default="true"):
        """Whether to bind"""
        if self.node is not None:
            return self.node.get("bind", default).lower() != "false"
        return default != "false"

    def ada_name(self):
        if self.node is not None:
            return self.node.get("ada", None)
        return None

    def returned_c_type(self):
        if self.node is not None:
            return self.node.get("return", None)
        return None

    def is_obsolete(self):
        if self.node is not None:
            return self.node.get("obsolescent", "False").lower() == "true"
        return False

    def convention(self):
        if self.node is not None:
            return self.node.get("convention", None)
        return None

    def return_as_param(self):
        if self.node is not None:
            return self.node.get("return_as_param", None)
        return None

    def transfer_ownership(self, return_girnode):
        """Whether the value returned by this method needs to be free by the
           caller.
           return_girnode is the XML node from the gir file for the return
           value of the method.
        """
        default = return_girnode.get('transfer-ownership', 'none')
        if self.node is not None:
            return self.node.get('transfer-ownership', default) != 'none'
        else:
            return default != 'none'

    def get_body(self):
        if self.node is not None:
            return self.node.findtext("body")
        return None

    def get_doc(self, default):
        """Return the doc, as a list of lines"""
        if self.node is not None:
            d = self.node.find("doc")
            if d is not None:
                txt = d.text
                doc = []
                for paragraph in txt.split("\n\n"):
                    for p in paragraph.split("\\n\n"):
                        doc.append(p)
                    doc.append("")

                if d.get("extend", "false").lower() == "true":
                    return [default, ""] + doc
                return doc
        return [default]


class GtkAdaParameter(object):
    def __init__(self, node, default):
        self.node = node
        self.default = default

    def get_default(self):
        if self.node is not None:
            return self.node.get("default", None)
        return None

    def get_direction(self):
        if self.node is not None:
            return self.node.get("direction", None)
        return None

    def ada_name(self):
        name = None
        if self.node is not None:
            name = self.node.get("ada", None)
        if name is None and self.default is not None:
            name = self.default.get("ada", None)
        return name

    def get_type(self, pkg):
        """pkg is used to set the with statements.
           This returned the locally overridden type, or the one from the
           default node for this parameter, or None if the type isn't
           overridden.
        """

        if self.node is not None:
            t = self.node.get("type", None)
            if t:
                return AdaType(t, pkg=pkg)  # An instance of CType

            t = self.node.get("ctype", None)
            if t:
                return t   # An XML node

        if self.default is not None:
            t = self.default.get("type", None)
            if t:
                return AdaType(t, pkg=pkg)

        return None

    def allow_none(self, girnode):
        default = girnode.get('allow-none', '0')
        if self.node is not None:
            return self.node.get('allow-none', default) == '1'
        else:
            return default == '1'

class GtkAdaType(object):
    def __init__(self, node):
        self.node = node

    def is_subtype(self):
        if self.node is not None:
            return self.node.get("subtype", "false").lower() == "true"
        return False
