<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="yes"/>

    <!-- Copy nodes by default -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Change disk bus to SATA -->
    <xsl:template match="/domain/devices/disk/target/@bus">
        <xsl:attribute name="bus">
            <xsl:value-of select="'virtio'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- Change CPU model to cortex-a57 -->
    <xsl:template match="/domain/cpu">
      <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
        <xsl:element name ="model">
          <xsl:attribute name="fallback">allow</xsl:attribute>
          <xsl:value-of select="'cortex-a57'"/>
        </xsl:element>
      </xsl:copy>
    </xsl:template>
    
    <!-- Remove WWM: only ide and scsi disk support wwn -->
    <xsl:template match="/domain/devices/disk/wwn" />

</xsl:stylesheet>