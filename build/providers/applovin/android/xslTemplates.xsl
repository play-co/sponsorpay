   <xsl:template match="meta-data[@android:name='applovin.sdk.key']">
        <meta-data android:name="applovin.sdk.key" android:value="{$appLovinSdkID}"/>
    </xsl:template>
