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

    <!-- Change disk bus to virtio -->
    <xsl:template match="/domain/devices/disk[@type='file']/target/@bus">
        <xsl:attribute name="bus">
            <xsl:value-of select="'sata'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- Change CPU model to cortex-a57 -->
    <xsl:template match="/domain/cpu">
      <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
        <xsl:element name ="model">
          <xsl:attribute name="fallback">allow</xsl:attribute>
          <xsl:value-of select="'cortex-a72'"/>
        </xsl:element>
      </xsl:copy>
    </xsl:template>
    
    <!-- Remove WWM: only ide and scsi disk support wwn -->
    <xsl:template match="/domain/devices/disk/wwn" />

</xsl:stylesheet>