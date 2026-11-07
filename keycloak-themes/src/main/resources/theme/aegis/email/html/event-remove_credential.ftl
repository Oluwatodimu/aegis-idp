<#--
  Security alert for Keycloak's REMOVE_CREDENTIAL event (Keycloak 26+), sent by
  the "email" event listener. Body: aegis-event.ftl.
-->
<#assign credType = (event.details.credential_type)!"">
<#if credType == "otp">
  <#assign aegisKey = "aegisEventTotpOff">
<#else>
  <#assign aegisKey = "aegisEventCredentialRemoved">
</#if>
<#assign showReset = true>
<#include "aegis-event.ftl">
