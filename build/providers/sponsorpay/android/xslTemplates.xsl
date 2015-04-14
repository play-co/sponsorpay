
	<xsl:template match="meta-data[@android:name='SPONSORPAY_APP_ID']">
		<meta-data android:name="SPONSORPAY_APP_ID" android:value="{$sponsorPayAppID}"/>
	</xsl:template>

	<xsl:template match="meta-data[@android:name='SPONSORPAY_SECURITY_TOKEN']">
		<meta-data android:name="SPONSORPAY_SECURITY_TOKEN" android:value="{$sponsorPaySecurityToken}"/>
	</xsl:template>
