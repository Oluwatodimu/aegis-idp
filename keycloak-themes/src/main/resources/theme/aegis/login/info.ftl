<#--
  Aegis — info page.
  Two jobs:
    1. Before running actions from an emailed link (requiredActions present):
       "Finish setting up your account" with the steps as a numbered list.
    2. Any other confirmation ("Your email address has been verified",
       "Your account has been updated"…): the message plus a way back into the app.
  Continue/back target, in order: pageRedirectUri, actionUri, client base URL,
  then the theme property aegisAppUrl. No button if none exists.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
  <#if section = "header">
    <#if requiredActions??>
      ${msg("aegisFinishSetupTitle")}
    <#elseif messageHeader??>
      ${kcSanitize(msg("${messageHeader}"))?no_esc}
    <#else>
      ${kcSanitize((message.summary)!'')?no_esc}
    </#if>
  <#elseif section = "form">
    <div id="kc-info-message">
      <#if requiredActions??>
        <p class="aegis-lead">${msg("aegisFinishSetupIntro")}</p>
        <ol class="aegis-steps">
          <#list requiredActions as reqActionItem>
            <li>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}</li>
          </#list>
        </ol>
      <#elseif messageHeader?? && (message.summary)?has_content>
        <p class="aegis-lead">${kcSanitize(message.summary)?no_esc}</p>
      </#if>

      <#if !skipLink??>
        <#if pageRedirectUri?has_content>
          <a class="pf-v5-c-button pf-m-primary pf-m-block aegis-button" href="${pageRedirectUri}">${msg("aegisContinueToApp")}</a>
        <#elseif actionUri?has_content>
          <a class="pf-v5-c-button pf-m-primary pf-m-block aegis-button" href="${actionUri}">${msg("aegisContinue")}</a>
        <#elseif (client.baseUrl)?has_content>
          <a class="pf-v5-c-button pf-m-primary pf-m-block aegis-button" href="${client.baseUrl}">${msg("aegisContinueToApp")}</a>
        <#elseif properties.aegisAppUrl?has_content>
          <a class="pf-v5-c-button pf-m-primary pf-m-block aegis-button" href="${properties.aegisAppUrl}">${msg("aegisContinueToApp")}</a>
        </#if>
      </#if>
    </div>
  </#if>
</@layout.registrationLayout>
