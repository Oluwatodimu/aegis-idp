<#--
  Sent by execute-actions-email (Aegis API sign-up, or an admin asking a user
  to do something). Wording switches to "finish setting up" when the actions
  include verifying the email, i.e. a brand-new account.
  Variables: link, linkExpiration, realmName, requiredActions, user.
-->
<#import "template.ftl" as layout>
<#assign isSetup = (requiredActions?? && requiredActions?seq_contains("VERIFY_EMAIL"))>
<#assign expiry = linkExpirationFormatter(linkExpiration)>
<#assign firstName = (user.firstName)!"">
<@layout.emailLayout preheader=msg(isSetup?then("aegisSetupPreheader", "aegisActionsPreheader"))>
  <@layout.heading>
    <#if isSetup>
      <#if firstName?has_content>${msg("aegisSetupHeadingName", firstName)}<#else>${msg("aegisSetupHeading")}</#if>
    <#else>
      ${msg("aegisActionsHeading")}
    </#if>
  </@layout.heading>
  <@layout.text>${msg(isSetup?then("aegisSetupIntro", "aegisActionsIntro"))}</@layout.text>

  <#if requiredActions?? && requiredActions?has_content>
    <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:0 0 12px;">
      <#list requiredActions as action>
        <tr>
          <td class="ae-ink" style="padding:4px 10px 4px 0; font-family:-apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size:14px; font-weight:600; color:#111214; vertical-align:top;">${action?index + 1}.</td>
          <td class="ae-ink" style="padding:4px 0; font-family:-apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; font-size:14px; color:#111214;">${msg("requiredAction.${action}")}</td>
        </tr>
      </#list>
    </table>
  </#if>

  <@layout.button href=link label=msg(isSetup?then("aegisSetupButton", "aegisActionsButton")) />
  <@layout.text small=true>${msg("aegisLinkExpires", expiry)}</@layout.text>
  <@layout.fallbackLink href=link />
  <@layout.text small=true>${msg(isSetup?then("aegisSetupIgnore", "aegisActionsIgnore"))}</@layout.text>
</@layout.emailLayout>
