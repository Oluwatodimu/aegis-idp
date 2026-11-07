<#--
  Forgot password. Variables: link, linkExpiration, realmName, user.
-->
<#import "template.ftl" as layout>
<#assign expiry = linkExpirationFormatter(linkExpiration)>
<@layout.emailLayout preheader=msg("aegisResetPreheader")>
  <@layout.heading>${msg("aegisResetHeading")}</@layout.heading>
  <@layout.text>
    <#if (user.email)?has_content>${msg("aegisResetIntroEmail", user.email)}<#else>${msg("aegisResetIntro")}</#if>
  </@layout.text>
  <@layout.button href=link label=msg("aegisResetButton") />
  <@layout.text small=true>${msg("aegisResetExpires", expiry)}</@layout.text>
  <@layout.fallbackLink href=link />
  <@layout.text small=true>${msg("aegisResetIgnore")}</@layout.text>
</@layout.emailLayout>
