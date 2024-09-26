<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="yes" />

  <!-- Root JSON Object -->
  <xsl:template match="/CarePlatform">
    {
    "PeopleParticipation": [
      <xsl:apply-templates select="PeopleNeedingAssistance/Person"/>
    ]
    }
  </xsl:template>

  <!-- Each person and their participation -->
  <xsl:template match="Person">
    {
      "PersonID": "<xsl:value-of select='ID'/>",
      "Name": "<xsl:value-of select='Name'/>",
      "ParticipatingServicesByType": {
        <xsl:for-each select="/CarePlatform/Services/Service">
          <xsl:variable name="currentServiceID" select="ID"/>
          <xsl:variable name="serviceType" select="Type"/>
          <xsl:if test="/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]">
            "<xsl:value-of select='$serviceType'/>": [
              {
                "ServiceID": "<xsl:value-of select='ID'/>",
                "ServiceName": "<xsl:value-of select='Description'/>",
                "Frequency": "<xsl:value-of select='/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]/Schedule/Frequency'/>",
                "Days": [
                  <xsl:for-each select="/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]/Schedule/Days/Day">
                    "<xsl:value-of select='.'/>"<xsl:if test="position() != last()">,</xsl:if>
                  </xsl:for-each>
                ],
                "Time": "<xsl:value-of select='/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]/Schedule/Time'/>"
              }
            ]
          </xsl:if>
        </xsl:for-each>
      },
      "NonParticipatingServicesByType": {
        <xsl:for-each select="/CarePlatform/Services/Service">
          <xsl:variable name="currentServiceID" select="ID"/>
          <xsl:if test="not(/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID])">
            "<xsl:value-of select='Type'/>": [
              {
                "ServiceID": "<xsl:value-of select='ID'/>",
                "ServiceName": "<xsl:value-of select='Description'/>"
              }
            ]
          </xsl:if>
        </xsl:for-each>
      }
    }<xsl:if test="position() != last()">,</xsl:if>
  </xsl:template>
</xsl:stylesheet>
