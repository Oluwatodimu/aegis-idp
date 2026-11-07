<#--
  Shared body for security alert emails (event-*.ftl).
  Usage: <#include "aegis-event.ftl"> after assigning
    aegisKey  — message key prefix, e.g. "aegisEventPassword"
    showReset — true to add a "Reset password" button
  Variables from Keycloak: event.date, event.ipAddress.
-->
<#import "template.ftl" as layout>
<#assign when = (event.date?datetime?string("d MMM yyyy, HH:mm zzz"))!"">
<#assign ip = (event.ipAddress)!"">
<@layout.emailLayout preheader=msg(aegisKey + "Preheader")>
  <@layout.heading>${msg(aegisKey + "Heading")}</@layout.heading>
  <@layout.text>${msg(aegisKey + "Intro")}</@layout.text>
  <#if when?has_content || ip?has_content>
    <@layout.facts>
      <#if when?has_content><@layout.fact label=msg("aegisEventWhen") value=when /></#if>
      <#if ip?has_content><@layout.fact label=msg("aegisEventIp") value=ip /></#if>
    </@layout.facts>
  </#if>
  <@layout.text>${msg(aegisKey + "IfYou")}</@layout.text>
  <@layout.text>${msg(aegisKey + "IfNot")}</@layout.text>
  <#if showReset && properties.aegisSignInUrl?has_content>
    <@layout.button href=properties.aegisSignInUrl label=msg("aegisEventSignIn") />
  </#if>
  <@layout.text small=true>${msg("aegisEventFooter")}</@layout.text>
</@layout.emailLayout>
