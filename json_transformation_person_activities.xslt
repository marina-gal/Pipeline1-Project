<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="yes" />

  <!-- Main template matches the root of the document -->
  <xsl:template match="/CarePlatform">
    {
      "PeopleParticipation": [
        <xsl:for-each select="PeopleNeedingAssistance/Person">
          <xsl:variable name="currentPersonID" select="ID" />
          <xsl:variable name="currentPersonName" select="Name" />

          {
            "PersonID": "<xsl:value-of select="$currentPersonID"/>",
            "Name": "<xsl:value-of select="$currentPersonName"/>",
            "Services": {
              "Participating": [
                <xsl:for-each select="/CarePlatform/Participation/ParticipationEntry[PersonID=$currentPersonID]">
                  <xsl:variable name="serviceID" select="ServiceID" />
                  <xsl:variable name="serviceDescription" select="/CarePlatform/Services/Service[ID=$serviceID]/Description" />
                  <xsl:variable name="frequency" select="Schedule/Frequency" />
                  {
                    "ServiceID": "<xsl:value-of select="$serviceID"/>",
                    "Description": "<xsl:value-of select="$serviceDescription"/>",
                    "Frequency": "<xsl:value-of select="$frequency"/>"
					"Schedule": {
                "Days": [
                  <xsl:for-each select="/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]/Schedule/Days/Day">
                    "<xsl:value-of select='.'/>"<xsl:if test="position() != last()">,</xsl:if>
                  </xsl:for-each>
                ],
                "Time": "<xsl:value-of select='/CarePlatform/Participation/ParticipationEntry[PersonID = current()/ID and ServiceID = $currentServiceID]/Schedule/Time'/>"
              }
                  }
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
              ],
              "NotParticipating": {
                <xsl:for-each select="/CarePlatform/Services/Service[not(ID = /CarePlatform/Participation/ParticipationEntry[PersonID=$currentPersonID]/ServiceID)]">
                  <xsl:variable name="serviceType" select="Type" />
                  <xsl:if test="position() = 1 or not(preceding-sibling::Service/Type = current()/Type)">
                    "<xsl:value-of select="$serviceType"/>": [
                  </xsl:if>

                  <xsl:variable name="notParticipatingServiceID" select="ID" />
                  <xsl:variable name="notParticipatingServiceDescription" select="Description" />
                  {
                    "ServiceID": "<xsl:value-of select="$notParticipatingServiceID"/>",
                    "Description": "<xsl:value-of select="$notParticipatingServiceDescription"/>"
                  }

                  <xsl:if test="position() != last() and not(following-sibling::Service/Type = current()/Type)">,</xsl:if>
                  <xsl:if test="not(following-sibling::Service/Type = current()/Type)">]
                  <xsl:if test="position() != last()">,</xsl:if>
                  </xsl:if>
                </xsl:for-each>
              }
            }
          }
          <xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>
      ]
    }
  </xsl:template>
</xsl:stylesheet>

