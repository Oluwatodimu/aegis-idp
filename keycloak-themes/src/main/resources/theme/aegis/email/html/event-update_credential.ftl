<#--
  Security alert for Keycloak's UPDATE_CREDENTIAL event (Keycloak 26+), sent by
  the "email" event listener. Same body as the other alerts: aegis-event.ftl.
  The wording follows the credential type, so a password change reads exactly
  like event-update_password.ftl.
-->
<#assign credType = (event.details.credential_type)!"">
<#if credType == "password">
  <#assign aegisKey = "aegisEventPassword">
  <#assign showReset = true>
<#elseif credType == "otp">
  <#assign aegisKey = "aegisEventTotpOn">
  <#assign showReset = false>
<#elseif credType == "recovery-authn-codes">
  <#assign aegisKey = "aegisEventRecoveryCodes">
  <#assign showReset = false>
<#else>
  <#assign aegisKey = "aegisEventCredentialUpdated">
  <#assign showReset = true>
</#if>
<#include "aegis-event.ftl">
