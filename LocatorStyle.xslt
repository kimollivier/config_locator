<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <!-- 
  TODO:
  elt/@search_context
  -->
  <xsl:output method="html" indent="yes"/>
  <xsl:preserve-space elements="line" />
  <xsl:template match="/">
    <html>
      <head>
        <script type="text/javascript" language="JScript">
          <![CDATA[
            function MouseDown(e, togglePlusMinus)
            {
              var o = e.nextSibling;
              var c = e.firstChild;
              if (c == null || o == null)
               return;
               
              if (togglePlusMinus == null)
              {
                if (e.plusminus == null || e.plusminus == '' || e.plusminus == 'undefined')
                {
                  togglePlusMinus = new Array("[+] ", "[-] ");
                }
                else
                {
                  togglePlusMinus = e.plusminus.split("#");
                }
              }
              
              if (e.mystate == "show")
              {
                o.style.display="none";
                e.mystate = "hide";
                c.innerHTML = togglePlusMinus[0];
              }
              else
              {
                o.style.display="block";
                e.mystate = "show";
                c.innerHTML = togglePlusMinus[1];
              }
              return true;
            }
            function NavigateToElt(e)
            {
              var id = e.href.split("#")[1];
              e = document.getElementById(id).parentNode;
              var a = 0;
              
              var state;
              while (e != null)
              {
                var ch = e.firstChild;
                while (ch != null)
                {
                  if (ch.attributes["mystate"] != null)
                  {
                    ch.mystate = ch.attributes["mystate"].textContent;
                    if (ch.mystate == "hide")
                    {
                      MouseDown(ch);
                      break;
                    }
                  }
                  ch = ch.nextSibling;
                }
                e = e.parentNode;
              }
                
              return true;
            }
            function HighlightElt(id, color)
            {
              elt = document.getElementById(id);
              elt.className = "paramHighlight";
            }
            function HighlightEltReset(id)
            {
              elt = document.getElementById(id);
              elt.className = "alt";
            }
            ]]>
        </script>
        <style type="text/css">
          body { background-color: white; font-family: Verdana,Arial; font-size: 11px; }
          h2 { font-size: 12; }
          table { margin-top: 0px; border-style: solid; border-width: 0px; border-color: black; font-size: 11; }
          td { vertical-align: top; margin-top: 0px; border-style: solid; border-width: 0px; border-color: darkgray; font-size: 11; padding: 0 2px 0 2px }
          .quotes { color: #68a }
          .comment {  background-color: #eee; font-size: 10px; color: #486 ; font-style: italic; }
          .sepchar {  background-color: #eee; font-size: 10px; color: #22b ; font-family: System; }
          .def { padding: 10px 0 0 20px ;  }
          .broken { background-color: #f88 ;  }
          .section { padding: 10px 0 0 20px ; cursor: default; font-size: 11; }
          .source_code_switch { font-weight: bold; padding: 0 0 0 0 ; font-size: 8; cursor: pointer ; }
          .source_code { background-color: #f0f8ff; padding: 0 10 10 10 ; font-family: courier; }
          .progid { color: #080; font-weight: bold }
          .title { background-color: #e82; color: white; font-weight: bold; padding: 10px 20px 10px 20px ; font-size: 14 }
          .desc { background-color: #ffa; font-style: italic; padding: 10px 20px 10px 20px ; font-size: 11 }
          .version { background-color: #ffa; padding: 1px 20px 1px 20px ; font-size: 9 }
          .section_title { background-color: #ed7; font-weight: bold; padding: 2px 0 2px 0; margin-top: 3px; font-size: 11  }
          .grammar_section_title { font-weight: bold; padding: 2px 0 2px 0; margin-top: 3px; font-size: 11  }
          .subsection_title { text-align: left; background-color: #e0e6ef; font-weight: bold; padding: 2px 10px 2px 0; margin-top: 3px; font-size: 11  }
          .subsection_title2 { text-align: left; background-color: #f0f0f0; font-weight: bold; padding: 2px 10px 2px 0; margin-top: 3px; font-size: 11  }
          .subsection_title3 { text-align: left; background-color: #fafafa; font-weight: bold; padding: 2px 10px 2px 0; margin-top: 3px; margin-right: 20px; font-size: 11  }
          .item_title { font-weight: bold; padding: 0 0 0 0}
          .item_desc { background-color: #fff; color: #678; font-style: italic; padding: 0 0 0 0; width: 600px }
          .attr { font-weight: bold; color: green; padding: 0 0 0 0}
          .collapse { font-weight: normal; font-family: courier-new, courier; margin-top: 20; cursor: pointer }
          .undef_item { color: gray }
          .alt_field_ref { font-weight: bold; }
          .alt {}
          .alt_result { color: darkcyan }
          .alt_result:link { color: darkcyan }
          .paramHighlight { outline-color: lightgrey; outline-style: solid; outline-width: 1px; }
          .pluginParam { font-weight: bold; padding: 0 20px 0 20px ; }
          .weight { color: #888; font-size: 6; }
          a { color: #800; text-decoration: none }
          a:hover { background-color: lightgrey; color: #080; text-decoration: none }

          .alias_list {  margin-top: 10px; margin-bottom: 5px; position: relative; left: 20px; color: black; background-color: #fff }
          .alias_list_name { margin-top: 10px; margin-bottom: 5px; color: #800; font-weight: bold }
          .alias_list_body { position: relative; left: 20px }
          .alias_def_name { font-weight: bold; width: 200px }
          .alias_def_entries { position: absolute; left: 200px; width: 800px }
          .alt_fallback { font-size: 10; color: grey }
          .alt_selector { font-size: 10; color: grey }
          .alt_selector_property_ref { color: grey; font-weight: bold }
          .alt_comment_column { background-color: #eee; border-color: white white white grey ; border-width: 1px; padding-left: 10px }
          .alt_fallback_score { color: darkcyan; font-weight: bold }
          .field_ref { background-color: #eee }
          .table_role { position: relative; left: 10px; margin: 4px 10px 0 0 }
          .table_role_title { background-color: #fefdf7; padding: 2px 0 2px 0 }
          .table_role_name { font-weight: bold }
          .rd_style_inputs { position: relative; left: 10px; margin-right: 10px }
          .data_source { position: relative; left: 10px; margin-right: 10px }
          .data_source_content { position: relative; left: 20px}
          .field_roles { position: relative; left: 20px}
          .field_role { margin-top: 4px }
          .field_role_name { font-weight: bold }
          .field_role_preferred_names { position: relative; left: 20px }
          .field_role_ref { font-weight: bold; color: #406080 }
          .prop_name { font-weight: bold }
          .outputs th { background-color: lightgrey }
          .is_alias_list { background-color: lightgrey; font-weight: normal }
        </style>
      </head>
      <body>
        <p>
          <span id="MessageBar"></span>
        </p>
        <xsl:apply-templates select="locators/locator/name"/>
        <xsl:apply-templates select="locators/locator/desc[not(@xml:lang)]"/>
        <xsl:apply-templates select="locators/locator/version"/>
        <xsl:apply-templates select="locators/locator/grammar"/>
        <xsl:apply-templates select="locators/locator/mapping_schemas"/>
        <xsl:apply-templates select="locators/locator/ref_data_styles"/>
        <xsl:apply-templates select="locators/locator/plugins"/>
        <xsl:apply-templates select="locators/locator/data_source"/>
        <div>
          <div mystate="hide" class="section_title" onmousedown="MouseDown(this);">
            <span class="collapse">[+] </span>
            <span>Inputs</span>
          </div>
          <div style="display: none">
            <xsl:apply-templates select="locators/locator/inputs"/>
          </div>
        </div>
        <xsl:apply-templates select="locators/locator/properties"/>
        <xsl:apply-templates select="locators/locator/output_formats"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="version">
    <div class="version">
      Format version: <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="ref_data_styles">
    <div>
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Reference Data Styles</span>
      </div>
      <div style="display:none">
        <xsl:apply-templates select="ref_data_style" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="ref_data_style">
    <div class="subsection_title">
      <xsl:value-of select="./name" />
    </div>
    <div class="item_desc">
      <xsl:value-of select="./desc"/>
    </div>
    <div>
      <xsl:apply-templates select="./table_roles" />
    </div>
    <div>
      <xsl:apply-templates select="./data_source" />
    </div>
    <xsl:if test="count(./inputs) > 0">
      <div>
        <div class="rd_style_inputs">
          <div mystate="hide" class="subsection_title2" onmousedown="MouseDown(this);">
            <span class="collapse">[+] </span>
            <span>Inputs</span>
          </div>
          <div style="display: none">
            <xsl:apply-templates select="./inputs"/>
          </div>
        </div>
      </div>
    </xsl:if>
    <div>
      <xsl:apply-templates select="./multiline_grammar" />
    </div>
  </xsl:template>

  <xsl:template match="table_roles">
    <xsl:apply-templates select="table_role" />
  </xsl:template>

  <xsl:template match="table_role">
    <div class="table_role">
      <div class="table_role_title">
        <span class="table_role_name">
          <xsl:value-of select="@name"/>
        </span>
        <span> (<xsl:value-of select="desc"/>)</span>
      </div>
      <div mystate="hide" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Fields </span>
      </div>
      <div class="field_roles" style="display: none">
        <xsl:apply-templates select="./field_roles" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="table_role/field_roles">
    <xsl:apply-templates select="./field_role" />
  </xsl:template>

  <xsl:template match="field_role">
    <div class="field_role">
      <span class="field_role_name">
        <xsl:value-of select="display_name"/>
      </span>
      [<xsl:value-of select="@name"/>]
      <xsl:if test="@required != '0' and @required != 'false' and @required != ''">
        <span>(Required)</span>
      </xsl:if>
      <div mystate="hide" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Preferred names </span>
      </div>
      <div class="field_role_preferred_names" style="display: none">
        <xsl:apply-templates select="./preferred_name" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="field_role/preferred_name">
    <div>
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="data_source">
    <div class="data_source">
      <div mystate="hide" class="subsection_title2" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Data Source</span>
      </div>
      <div class="data_source_content" style="display: none">
        <div>
          Uses schema <a href="#mapping_schema_{./mapping_schema/@ref}" onclick="NavigateToElt(this);"><xsl:value-of select="./mapping_schema/@ref"/></a>
        </div>
        <xsl:apply-templates select="queries/query" />
        <xsl:apply-templates select="workspace_properties" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match ="queries/query">
    <div>
      <div mystate="hide" class="subsection_title3" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>
        <xsl:variable name="f" select="../query" />
        <xsl:choose>
          <xsl:when test="count($f) &gt; 1">
            Query #<xsl:value-of select="position()"/>
          </xsl:when>
          <xsl:otherwise>
            Query          
          </xsl:otherwise>
        </xsl:choose>
        </span>
      </div>
      <div style="display: none">
        <table>
          <tr>
            <td>Tables:</td>
            <td><xsl:apply-templates select="tables/table" /></td>
          </tr>
          <tr>
            <td>Field mappings:</td>
            <td><table><xsl:apply-templates select="fields/field" /></table></td>
          </tr>
          <xsl:if test="join_clause != ''">
            <tr>
              <td>Join clause:</td>
              <td><xsl:apply-templates select="join_clause/node()" mode ="logical"/></td>
            </tr>
          </xsl:if>
          <xsl:if test="selection_clause != ''">
            <tr>
              <td>Selection clause:</td>
              <td><xsl:apply-templates select="selection_clause/node()" mode ="logical"/></td>
            </tr>
            <tr>
              <td>Selection clause (expanded):</td>
              <td><xsl:apply-templates select="selection_clause/node()" mode ="expanded"/></td>
            </tr>
          </xsl:if>
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match ="selection_clause/node() |join_clause/node() | selection_clause/node() | selection_clause/node()" mode="logical">
    <xsl:choose>
      <xsl:when test="name(.)= 'field_ref'">
        <xsl:choose>
          <xsl:when test="@field_role_ref != ''">
            <xsl:variable name="r" select="@field_role_ref"/>
            <xsl:variable name="v" select ="../../../../../table_roles/table_role/field_roles/field_role[@name=$r]"/>
            <xsl:choose>
              <xsl:when test="$v !=''">
                <span class="field_role_ref">$<xsl:value-of select="@field_role_ref"/></span>
              </xsl:when>
              <xsl:otherwise>
                <span class="field_role_ref">$<span class="broken"><xsl:value-of select="@field_role_ref"/></span></span>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <span class="field_role_ref">$<xsl:value-of select ="@ref"/></span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:value-of select ="self::text()"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match ="selection_clause/node() |join_clause/node() " mode="expanded">
    <xsl:choose>
      <xsl:when test="name(.)= 'field_ref'">
        <xsl:variable name="r" select="@field_role_ref"/>
        <xsl:variable name="v" select ="../../../../../table_roles/table_role/field_roles/field_role[field_name=$r]"/>
        <xsl:choose>
          <xsl:when test="$v !=''">
            <span class="field_role_ref">$<xsl:value-of select="$v"/></span>
          </xsl:when>
          <xsl:otherwise>
            <span class="field_role_ref">$<span class="broken"><xsl:value-of select="@field_role_ref"/></span></span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:value-of select ="self::text()"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match ="tables/table">
    <div>
      $<xsl:value-of select ="@role_ref"/>
    </div>
  </xsl:template>

  <xsl:template match ="fields/field">
    <tr>
    <td style="font-weight: bold;">
      <xsl:value-of select ="@ref"/>
    </td>
    <td>
      $<xsl:value-of select ="@field_role_ref"/>
    </td>
    </tr>
  </xsl:template>

  <xsl:template match="workspace_properties">
    <div>
      Factory ProgID: <span class="progid">
        <xsl:value-of select="./factory_progid"/>
      </span>
    </div>
    <xsl:choose>
      <xsl:when test="path != ''">
        <div>
          Path: <xsl:value-of select="path"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="connection_properties" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match ="connection_properties">
    <div>
      Connection properties:
      <table>
        <tr><td>Server:</td><td><xsl:value-of select="server"/></td></tr>
        <tr><td>Instance:</td><td><xsl:value-of select="instance"/></td></tr>
        <tr><td>Database:</td><td><xsl:value-of select="database"/></td></tr>
        <tr><td>Authentication mode:</td><td><xsl:value-of select="authentication_mode"/></td></tr>
        <tr><td>User:</td><td><xsl:value-of select="user"/></td></tr>
        <tr>
          <xsl:choose>
            <xsl:when test ="encrypted_password">
              <td>Encrypted password:</td><td><xsl:value-of select="encrypted_password"/></td>
            </xsl:when>
            <xsl:when test ="password">
              <td>Password:</td><td><xsl:value-of select="password"/></td>
            </xsl:when>
          </xsl:choose>
        </tr>
        <tr>
          <xsl:choose>
            <xsl:when test ="transactional_version != ''">
              <td>Transactional version:</td><td><xsl:value-of select="transactional_version"/></td>
            </xsl:when>
            <xsl:when test ="transactional_version != ''">
              <td>Historical name:</td><td><xsl:value-of select="historical_name"/></td>
            </xsl:when>
            <xsl:when test ="transactional_version != ''">
              <td>Historical timestamp:</td><td><xsl:value-of select="historical_timestamp"/></td>
            </xsl:when>
          </xsl:choose>
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="grammar">
    <div>
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Grammar</span>
      </div>
      <div style="display: none">
        <xsl:apply-templates select="section" />
        <xsl:apply-templates select="multiline_grammar" />
        <xsl:apply-templates select="spelling" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="spelling">
    <div>
      <div mystate="hide" class="subsection_title2" style="position: relative; left: 20px" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>Spelling</span>
      </div>
      <div style="display: none">
        <xsl:apply-templates select="character_equivalency_table" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="character_equivalency_table">
    <div style="position: relative; left: 40px" >
      <div mystate="hide" class="subsection_title3" onmousedown="MouseDown(this);">
        <span class="collapse">[+] </span>
        <span>
          <xsl:value-of select="@name"/>
        </span>
      </div>
      <div style="display: none">
        <table>
          <tr style="background-color: lightgrey">
            <th>From</th>
            <th></th>
            <th>To</th>
            <th>SpellSens level</th>
            <th>Cost</th>
          </tr>
        <xsl:apply-templates select="entry" />
        </table>
        <table>
          <tr><xsl:apply-templates select="noise_chars" /></tr>
          <tr><xsl:apply-templates select="double_chars" /></tr>
          <tr><xsl:apply-templates select="allowed_penalties" /></tr>
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="noise_chars">
    <td>
      <span style="font-weight: bold">Noise chars</span>
      <span>
        [cost: <xsl:value-of select="@cost"/>]
      </span>
      <span style="font-weight: bold">:</span>
    </td>
    <td>
      <span style="background: #def">
        <xsl:value-of select="@list"/>
      </span>
    </td>
  </xsl:template>
  <xsl:template match="double_chars">
    <td>
      <span style="font-weight: bold">Double chars</span>
      <span>
        [cost: <xsl:value-of select="@cost"/>]
      </span>
      <span style="font-weight: bold">:</span>
    </td>
    <td>
      <span style="background: #def">
        <xsl:value-of select="@list"/>
      </span>
    </td>
  </xsl:template>


  <xsl:template match="allowed_penalties">
    <td>
      <span style="font-weight: bold">Allowed penalties:</span>
    </td>
    <td>
      <span style="background: #dfe">
        <xsl:value-of select="@list"/>
      </span>
    </td>
  </xsl:template>

  <xsl:template match="entry">
    <tr>
      <td><xsl:value-of select="@from"/></td>
      <td><xsl:choose>
        <xsl:when test="@type='group'">
          <span class="sepchar">&#x2194;</span>
        </xsl:when>
        <xsl:otherwise>
          <span class="sepchar">&#x2192;</span>
        </xsl:otherwise>
      </xsl:choose>
      </td>
      <td><xsl:value-of select="@to"/></td>
      <td>
        <xsl:value-of select="@spell"/>
      </td>
      <td>
        <xsl:value-of select="@cost"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="multiline_grammar|section">
    <div class="section">
      <div mystate="hide" onmousedown="MouseDown(this);">
        <span class="collapse" >[+] </span>
        <span class="grammar_section_title">
          <xsl:choose>
            <xsl:when test="name(.) = 'multiline_grammar'">
              Multiline input
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@desc" />
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </div>
      <div style="display: none">
        <table class="bigtable" cellspacing="0" cellpadding="0">
          <xsl:apply-templates select="multiline_def"/>
          <xsl:apply-templates select="def"/>
          <xsl:apply-templates select="alias_list"/>
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="plugins">
    <div>
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);" >
        <span class="collapse">[+] </span>
        <span>Plugins</span>
      </div>
      <div style="display: none">
        <xsl:apply-templates select="plugin" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="mapping_schemas">
    <div>
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);" >
        <span class="collapse">[+] </span>
        <span>Mapping Schemas</span>
      </div>
      <div style="display: none">
        <xsl:apply-templates select="./mapping_schema" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="mapping_schema">
    <xsl:variable name="idname">mapping_schema_<xsl:value-of select="@name"/></xsl:variable>
    <xsl:variable name="baseidname">#mapping_schema_<xsl:value-of select="@base"/></xsl:variable>
    <table id="{$idname}" style="margin-top: 20;" borderwidth="1">
      <col width="200" /> <col width="600" />
      <tr>
        <th colspan="2" class="subsection_title">
          <xsl:value-of select="@name"/>
        </th>
      </tr>
      <tr>
        <td>Description:</td>
        <td class="item_desc">
          <xsl:value-of select="desc"/>
        </td>
      </tr>
      <xsl:if test="@base != ''">
        <tr>
          <td>Converts to</td>
          <td class="item_title">
            <a href="{$baseidname}"><xsl:value-of select="@base"/></a>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="@geom_type != ''">
        <tr>
        <td>
        <xsl:choose>
          <xsl:when test="@base != ''">
            Redefines geometry type as:
          </xsl:when>
          <xsl:otherwise>
            Geometry type:
          </xsl:otherwise>
        </xsl:choose>
        </td>
        <td class="attr">
          <xsl:value-of select="@geom_type"/>
        </td>
        </tr>
      </xsl:if>
      <tr>
        <xsl:variable name="f" select="./fields/field" />
        <xsl:choose>
          <xsl:when test="count($f) &gt; 0">
            <td>
              <xsl:choose>
                <xsl:when test="@base != ''">
                  New fields:
                </xsl:when>
                <xsl:otherwise>
                  Fields:
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td>
              <div mystate="hide" onmousedown="MouseDown(this);">
                <span class="collapse" >[+] </span>
              </div>
              <div style="display: none">
                <table class="bigtable" cellspacing="0" cellpadding="0">
                  <xsl:apply-templates select="./fields/field" />
                </table>
              </div>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td colspan="2" class="undef_item">Does not define fields</td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <xsl:variable name="t" select="./conversions/conversion" />
      <xsl:if test="count($t) &gt; 0">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="count($t) = 1">
                Converts fields:
              </xsl:when>
              <xsl:otherwise>
                Produces <xsl:value-of select="count($t)"/> rows from each input row using conversions:
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <span mystate="hide" onmousedown="MouseDown(this);">
              <span class="collapse" >[+] </span>
            </span>
            <div style="display: none">
              <table>
                <xsl:apply-templates select="./conversions/conversion" />
              </table>
            </div>
          </td>
        </tr>
      </xsl:if>
      <xsl:apply-templates select="selection_clause" />

      <xsl:if test="count(./virtualize_field) > 0">
        <tr>
          <td>
            Virtualized fields:
          </td>
          <td>
            <table>
              <xsl:apply-templates select="./virtualize_field" />
            </table>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="count(./get_geometry_method) > 0">
        <tr>
          <td>
            Geometry calculated as
          </td>
          <td>
            <xsl:apply-templates select="./get_geometry_method"/>
          </td>
        </tr>
      </xsl:if>

      <xsl:apply-templates select="selection_clause" />

      <xsl:if test ="count(./properties)">
        <tr>
          <td>Properties</td>
          <td>
            <span mystate="hide" onmousedown="MouseDown(this);">
              <span class="collapse" >[+]</span>
            </span>
            <div style="display: none">
              <table>
                <xsl:apply-templates select="./properties/prop|./properties/prop_list" />
              </table>
            </div>
          </td>
        </tr>
      </xsl:if>

      <!-- ################ reverse geocoding ################ -->
      <xsl:if test ="count(./reverse_geocoding)">
        <tr>
          <td>Reverse geocoding methods:</td>
          <td>
            <span mystate="hide" onmousedown="MouseDown(this);">
              <span class="collapse" >[+]</span>
            </span>
            <div style="display: none">
              <table>
                <xsl:apply-templates select="./reverse_geocoding/reverse_geocoding_method" />
              </table>
            </div>
          </td>
        </tr>
      </xsl:if>

      <!-- ################ outputs ################ -->
      <xsl:if test ="count(./outputs)">
        <tr>
          <td>Outputs:</td>
          <td>
            <span mystate="hide" onmousedown="MouseDown(this);">
              <span class="collapse" >[+]</span>
            </span>
            <div style="display: none">
              <xsl:apply-templates select="./outputs" />
            </div>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template match="reverse_geocoding_method">
    <tr style="background-color: #ffe">
      <td>
        <xsl:value-of select="@name"/>
      </td>
      <td>
        <xsl:apply-templates select="./method" />
      </td>
    </tr>
    <tr>
      <td colspan="2">
        <xsl:apply-templates select="./outputs" />
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="virtualize_field">
    <tr>
      <td style="font-weight: bold"><xsl:value-of select="@base_ref"/> :</td>
      <td>
        <xsl:apply-templates select="./scoring_method"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="outputs">
    <table class="outputs">
      <tr>
        <th>Name</th>
        <th>Alias</th>
        <th>Type</th>
        <th>Length</th>
        <th>Dec. digits</th>
        <th>Content type</th>
        <th>Content</th>
        <th>Batch mode</th>
        <th>Cand. mode</th>
        <th>Selector</th>
      </tr>
      <xsl:apply-templates select="./output" />
    </table>
  </xsl:template>

  <xsl:template match="output">
    <xsl:variable name="c">
      <xsl:choose>
        <xsl:when test="position() mod 2 != 1">#eaf0ff</xsl:when>
        <xsl:otherwise>#ffffff</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr style="background-color: {$c}">
    <td>
      <xsl:choose>
        <xsl:when test="@name != ''">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="@ref != ''">
              <xsl:value-of select="@ref"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@component"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:value-of select="@alias"/>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="@type != ''">
          <xsl:value-of select="@type"/>
        </xsl:when>
        <xsl:otherwise>
          <span style="font-style: italic">string</span>
        </xsl:otherwise>
      </xsl:choose>
    </td>
      <td>
        <xsl:value-of select="@length"/>
      </td>
      <td>
        <xsl:value-of select="@decimal_digits"/>
      </td>
      <xsl:choose>
        <xsl:when test="@ref != ''">
          <td>
            Field
          </td>
          <td>
            <xsl:value-of select="@ref"/>
          </td>
        </xsl:when>
        <xsl:when test="@component != ''">
          <td>
            Property
          </td>
          <td>
            <xsl:value-of select="@component"/>
          </td>
        </xsl:when>
        <xsl:when test="./format_ref/@ref != ''">
          <td>
            Format
          </td>
          <td>
            <a href="#output_formats">
              <xsl:value-of select="./format_ref/@ref"/>
            </a>
          </td>
        </xsl:when>
        <xsl:when test="./format != ''">
          <td>
            Format
          </td>
          <td>
            <table>
              <xsl:apply-templates select="./*"/>
            </table>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td></td><td></td>
        </xsl:otherwise>
      </xsl:choose>
      <td>
        <xsl:choose>
          <xsl:when test="@batch_mode = 'false'"></xsl:when>
          <xsl:otherwise>x</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@candidate_mode = 'false'"></xsl:when>
          <xsl:otherwise>x</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="@selector"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="mapping_schema/selection_clause">
    <tr>
      <td>
        Filter criteria (<xsl:value-of select="@dbms" />):
      </td>
      <td>
        <xsl:apply-templates select="node()" mode ="logical"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="mapping_schema/fields/field">
    <xsl:variable name="idname">mapping_schema_<xsl:value-of select="../@name"/>_field_<xsl:value-of select="@name"/></xsl:variable>
    <tr id="{$idname}" >
      <td class="item_title">
        <xsl:value-of select="@name"/>
      </td>
      <td class="item_desc">
        <xsl:value-of select="desc"/>
      </td>
    </tr>
    <xsl:if test="@grammar_ref != ''">
      <tr>
        <td colspan="2">
          Maps to grammar element <a href="#{@grammar_ref}" onclick="NavigateToElt(this);"><xsl:value-of select="@grammar_ref"/></a>
        </td>
      </tr>
    </xsl:if>
    <xsl:if test ="count(./scoring_method)">
      <tr>
        <td>
          Scoring method:
        </td>
        <td>
          <xsl:apply-templates select="./scoring_method"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="parameter">
    
  </xsl:template>

  <xsl:template match="mapping_schema/conversions/conversion">
    <tr>
    <td>
      <xsl:variable name="t" select="../conversion" />
      <xsl:if test="count($t) &gt; 1">Output row #<xsl:value-of select="position()"/></xsl:if>
    </td>
    <td>
      <table>
        <xsl:apply-templates select="mapping" />
      </table>
    </td>
    </tr>
  </xsl:template>

  <xsl:template match="mapping">
    <xsl:variable name="baseidname">#mapping_schema_<xsl:value-of select="../../@base"/>_field_<xsl:value-of select="@base_ref"/></xsl:variable>
    <tr>
      <td>
        <a href="{$baseidname}"><xsl:value-of select="@base_ref" /></a>
      </td>
      <td>=</td>
      <td><xsl:apply-templates select="./*" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="method|scoring_method|get_geometry_method">
    <span style="font-weight: bold">@<a class="alt_result" href="#plugin_{@ref}" onclick="NavigateToElt(this);"><xsl:value-of select="@ref" /></a></span>
    <span>
      <xsl:if test ="count(./init_properties)">
        <span mystate="hide" onmousedown="MouseDown(this);">
          <span class="collapse" >[+]</span>
        </span>
        <div style="display: none">
          <xsl:apply-templates select="./init_properties" />
        </div>
      </xsl:if>
    </span>(<xsl:apply-templates select="parameter" />)
  </xsl:template>

  <xsl:template match="init_properties">
    <div style="background-color: #ccc">Init properties:</div>
    <table>
      <xsl:apply-templates select="./prop|./prop_list" />
    </table>
  </xsl:template>

  <xsl:template match="prop">
    <tr style="background-color: #eee">
      <td>
        <span class="prop_name">
          <xsl:value-of select="@name"/>
        </span>
      </td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="prop_list">
    <tr style="background-color: #eee">
      <td>
        <span class="prop_name">
          <xsl:value-of select="@name"/>
        </span>
      </td>
      <td>
        <table>
          <xsl:apply-templates select="./value"/>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="prop_list/value">
    <tr><td>
      <xsl:value-of select="text()"/>
    </td></tr> 
  </xsl:template>
  <xsl:template match="parameter"><xsl:if test="position() != 1">, </xsl:if><xsl:apply-templates select="./*"/></xsl:template>
  <xsl:template match="parameter"><xsl:if test="position() != 1">, </xsl:if><xsl:apply-templates select="./*"/></xsl:template>

  <xsl:template match="value">"<xsl:value-of select="."/>"</xsl:template>
  <xsl:template match="input_value"><span style="color: navy; font-weight:bold">$INPUT_VALUE</span></xsl:template>

  <xsl:template match="field_value">$<xsl:value-of select="@ref" /></xsl:template>
  <xsl:template match="component_value">
    <xsl:choose>
      <xsl:when test="substring(@component, 1, 1) = '_'">
        <xsl:variable name="refid1">
          <xsl:value-of select ="../../../../../@name" />
        </xsl:variable>
        <xsl:variable name="refid2">
          <xsl:value-of select ="../../../@name" />
        </xsl:variable>
        <xsl:variable name="refid">
          <xsl:choose>
            <xsl:when test="$refid1 != ''">
              <xsl:value-of select="$refid1" />.<xsl:value-of select ="count(../../../../preceding-sibling::elt)+1" />.<xsl:value-of select ="substring(@component, 2)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$refid2" />.<xsl:value-of select ="count(../../preceding-sibling::elt)+1" />.<xsl:value-of select ="substring(@component, 2)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <span onmousemove="HighlightElt('{$refid}', 'lightgrey');" onmouseout="HighlightEltReset('{$refid}');">$<xsl:value-of select="substring(@component, 2)" />
        </span>
      </xsl:when>
      <xsl:otherwise>['<xsl:value-of select="@component" />']</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="search_value">
    ['#<xsl:value-of select="@ref" />']
  </xsl:template>

  <xsl:template match="field/preferred_name">
    <tr>
    <td>
      <xsl:value-of select="."/>
    </td>
    </tr>
  </xsl:template>


  <xsl:template match="plugin">
    <xsl:variable name="idname">plugin_<xsl:value-of select="@name"/></xsl:variable>
    <xsl:variable name="t" select="*[name()]" />
    <div id="{$idname}">
    <table style="margin-top: 20;">
      <tr class="item_title">
        <td></td>
        <td>
          <xsl:value-of select="@name"/>
        </td>
      </tr>
      <tr>
        <td>Description:</td>
        <td class="item_desc">
          <span>
          <xsl:apply-templates select="desc/node()"/>
          </span>
        </td>
      </tr>
      <tr>
        <td>Type:</td>
        <td>
          <xsl:choose>
            <xsl:when test="$t = com_progid or $t = com_clsid">
              COM
            </xsl:when>
            <xsl:when test="$t = script">
              Script (<xsl:value-of select="script/@type" />)
            </xsl:when>
            <xsl:when test="$t = builtin">
              Built-in
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select="plugin" />
        </td>
      </tr>
      <tr>
      <xsl:choose>
        <xsl:when test="$t = com_progid or $t = com_clsid">
          <td>ProgID:</td>
          <td class="progid">
            <xsl:value-of select="com_clsid | com_progid"/>
          </td>
        </xsl:when>
        <xsl:when test="$t = script">
          <td>Code:</td>
          <td>
            <div mystate="hide" onmousedown="MouseDown(this);" plusminus="[show code]#[hide code]">
              <span class="source_code_switch">[show code] </span>
            </div>
            <pre class="source_code"  style="display: none">
              <xsl:apply-templates select="script/line" />
              <br/>
            </pre>
          </td>
        </xsl:when>
      </xsl:choose>
      </tr>
    </table>
    </div>
  </xsl:template>

  <xsl:template match="script/line">
    <br/>
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="def|multiline_def">
    <tr class="def">
      <xsl:variable name="n">
        <xsl:choose>
          <xsl:when test="@name != ''">
            <xsl:value-of select ="@name" />
          </xsl:when>
          <xsl:otherwise>
            $Multiline_input
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <td valign="top" width="1%" id="{$n}">
        <xsl:if test="@is_alias_list='true'">
          <span class="is_alias_list">(alias&#160;list)</span><span>&#160;</span>
        </xsl:if>
        <b>
          <a href="#" title="{./descr}" onclick="return false">
          <xsl:value-of select="$n" />
          </a>
        </b>
        <xsl:if test="count(./alias_list_ref) > 0">
          <xsl:apply-templates select="alias_list_ref" />
        </xsl:if>
      </td>
      <td>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
          <xsl:apply-templates select="./alt" />
          <tr>
            <td>;</td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="alias_list_ref">
    <span>
      <xsl:variable name="u">alias_list_<xsl:value-of select ="@ref" /></xsl:variable>
      [<a href='#{$u}' onclick="NavigateToElt(this);"><xsl:value-of select ="@ref" /></a>]
    </span>
  </xsl:template>

  <xsl:template match="alias_list">
    <xsl:variable name="u">alias_list_<xsl:value-of select ="@name" /></xsl:variable>
    <div id='{$u}' class="alias_list">
      <div>
        <div mystate="hide" onmousedown="MouseDown(this);">
          <span class="collapse">[+] </span>
          <span class="alias_list_name">
            <xsl:value-of select="@name"/>
          </span>
        </div>
        <div class="alias_list_body" style="display:none">
          <xsl:apply-templates select="./alias_def"/>
        </div>
      </div>
    </div>  
  </xsl:template>

  <xsl:template match="alias_def">
    <div class="alias_def">
      <span class="alias_def_name">
        <xsl:choose>
          <xsl:when test="./alt[1]/@ref != ''">
            <xsl:value-of select ="./alt[1]/@ref" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="./alt[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <span class="alias_def_entries">
        <xsl:apply-templates select="./alt" />
      </span>
    </div>
  </xsl:template>

  <xsl:template match="alias_def/alt">
    <xsl:choose>
      <xsl:when test="@ref != ''">
        <xsl:variable name="u">
          <xsl:value-of select ="@ref" />
        </xsl:variable>
        <a href='#{$u}' onclick="NavigateToElt(this);">
          <xsl:value-of select ="$u" />
        </a>
        &#160;
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="comment()">
    <div class="comment">
      &lt;!--
      <xsl:value-of select="."/>
      --&gt;
    </div>
  </xsl:template>
  
  <xsl:template match="alt/*">
    <xsl:variable name="id">
      <xsl:value-of select ="../../@name" />.<xsl:value-of select ="count(../preceding-sibling::elt)+1" />.<xsl:value-of select ="position() div 2" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="name(.) != 'elt' and name(.) != 'result'">
        <xsl:if test="text() != ''">
          <span><xsl:value-of select="." /></span>
        </xsl:if>
        <xsl:if test="name(.) = 'field_ref'">
          <span><span class="field_ref">[Input:<xsl:value-of select = "@ref" />]</span>
          </span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@pre_separator = 'none'">
            <span class="sepchar">&#x2190;</span>
          </xsl:when>
          <xsl:when test="@pre_separator = 'optional'">
            <span class="sepchar">&#x2194;</span>
          </xsl:when>
          <xsl:when test="@pre_separator = 'required'">
            <span class="sepchar">&#x2261;</span>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="@ref != ''">
            <xsl:variable name="u">
              <xsl:value-of select = "@ref" />
            </xsl:variable>
            <a id='{$id}' href='#{$u}' onclick="NavigateToElt(this);">
              <xsl:value-of select ="$u" />
            </a>
            <xsl:if test="@weight != ''">
              <span class="weight">
                <sup>
                  <xsl:value-of select="@weight" />
                </sup>
              </span>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="text() != ''">
                <span class="quotes">"</span><xsl:value-of select="text()" /><span class="quotes">"</span>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="text() " />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="@post_separator = 'none'">
            <span class="sepchar">&#x2192;</span>
          </xsl:when>
          <xsl:when test="@post_separator = 'optional'">
            <span class="sepchar">&#x2194;</span>
          </xsl:when>
          <xsl:when test="@post_separator = 'required'">
            <span class="sepchar">&#x2261;</span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <![CDATA[ ]]>
  </xsl:template>
  
  <xsl:template match="def/alt|multiline_def/alt">
    <tr class="alt">
      <td width="15px">
        <xsl:choose>
          <xsl:when test="position() = 1">:</xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="line_no" select="1" />
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="@ref != ''">
            <xsl:variable name="u">
              <xsl:value-of select = "@ref" />
            </xsl:variable>
            <a href='#{$u}'>
              <xsl:value-of select ="$u" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="./elt">
                  <xsl:apply-templates select="./node()"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="text() != ''">
                    <span class="quotes">"</span><xsl:value-of select="text()" /><span class="quotes">"</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <br></br>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="@fallback != '' or @selector != '' or @fallback_score != ''">
        <td class="alt_comment_column">
          <xsl:if test="@fallback != ''">
            <div class="alt_fallback">
              used only if no matching candidates has been previously found
            </div>
          </xsl:if>
          <xsl:if test="@fallback_score != ''">
            <div class="alt_fallback">
              used only if no candidates with score above <span class="alt_fallback_score"><xsl:value-of select="@fallback_score"/></span> has been previously found
            </div>
          </xsl:if>
          <xsl:if test="@selector != ''">
            <div class="alt_selector">
              used only if <span class="alt_selector_property_ref"><xsl:value-of select="@selector"/></span> is <b>true</b>
            </div>
          </xsl:if>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>

  <xsl:template match="desc/text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="desc/*">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="alt/text()">
    <xsl:if test="normalize-space(.) != ''">
      <span class="quotes">"</span><xsl:value-of select="."/><span class="quotes">"</span>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="alt/result">
    <div>
      <span class="alt_result">
        {<xsl:apply-templates select="./node()[name(.) != 'format']" />}
      </span>
      <xsl:apply-templates select="format" />
    </div>
  </xsl:template>

  <xsl:template match="output_formats">
    <div id="output_formats">
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);" >
        <span class="collapse">[+] </span>
        <span>Formats</span>
      </div>
      <div style="display: none">
        <table>
          <xsl:apply-templates select="./format_definition" />
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="locator/properties">
    <div id="output_formats">
      <div mystate="hide" class="section_title" onmousedown="MouseDown(this);" >
        <span class="collapse">[+] </span>
        <span>Default properties</span>
      </div>
      <div style="display: none">
        <table>
          <xsl:apply-templates select="./prop | ./prop_list" />
        </table>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="format">
    <span class="alt_format">
      format: {<xsl:apply-templates select="./node()" />}
    </span>
  </xsl:template>

  <xsl:template match="format_definition | output/format">
    <tr>
      <td style="font-weight: bold">
        <xsl:variable name="idname">format_<xsl:value-of select="@name"/></xsl:variable>
        <div id="{$idname}">
          <xsl:value-of select="@name"/>
        </div>
      </td>
      <td>
        <span class="alt_format"><xsl:apply-templates select="./node()" /></span>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="name">
    <div class="title">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  <xsl:template match="desc">
    <div class="desc">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="inputs">
    <table>
      <tr>
        <th>Name</th>
        <th>Display name</th>
        <th>Length</th>
        <th>Required</th>
        <th>Recognized names</th>
      </tr>
      <xsl:apply-templates select="./input | ./default_input" />
    </table>
  </xsl:template>

  <xsl:template match="input | default_input">
    <xsl:variable name="c">
      <xsl:choose>
        <xsl:when test="name(.) = 'default_input'">#e0f0f0</xsl:when>
        <xsl:when test="name(.) = 'input'">#f0f0f0</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <tr style="background-color: {$c}">
      <td>
        <xsl:value-of select="@name"/>
      </td>
      <td>
        <xsl:value-of select="./caption"/>
      </td>
      <td>
        <xsl:value-of select="@length"/>
      </td>
      <td>
        <xsl:value-of select="@required"/>
      </td>
      <td>
        <xsl:apply-templates select="./recognized_name" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="recognized_name">
    <div>
      <xsl:value-of select="text()"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
