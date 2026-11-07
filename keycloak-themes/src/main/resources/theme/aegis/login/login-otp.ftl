<#--
  Aegis — enter the authenticator code at sign-in.
  The real field is Keycloak's "otp" input; js/aegis.js shows it as six boxes.
  Without JavaScript the single field is used as-is.
  "Try another way" is added by template.ftl when the user has another method.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true; section>
  <#if section = "header">
    ${msg("aegisOtpTitle")}
  <#elseif section = "form">
    <#assign hasError = messagesPerField.existsError('totp')>
    <form id="kc-otp-login-form" class="pf-v5-c-form" action="${url.loginAction}" method="post" onsubmit="login.disabled = true; return true;" novalidate="novalidate">

      <#if otpLogin.userOtpCredentials?size gt 1>
        <fieldset class="aegis-devices">
          <legend>${msg("aegisOtpChooseDevice")}</legend>
          <#list otpLogin.userOtpCredentials as otpCredential>
            <label class="aegis-device">
              <input type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                     <#if otpCredential.id == (otpLogin.selectedCredentialId!'')>checked</#if>>
              <span>${otpCredential.userLabel!msg("aegisOtpDefaultDevice")}</span>
            </label>
          </#list>
        </fieldset>
      <#else>
        <input type="hidden" id="selectedCredentialId" name="selectedCredentialId" value="${otpLogin.selectedCredentialId!''}">
      </#if>

      <p class="aegis-lead">${msg("aegisOtpIntro")}</p>

      <div class="pf-v5-c-form__group">
        <div class="pf-v5-c-form__group-label">
          <label class="pf-v5-c-form__label" for="otp"><span class="pf-v5-c-form__label-text">${msg("loginOtpOneTime")}</span></label>
        </div>
        <div class="pf-v5-c-form__group-control">
          <span class="pf-v5-c-form-control<#if hasError> pf-m-error</#if>">
            <input id="otp" name="otp" type="text" inputmode="numeric" pattern="[0-9]*"
                   autocomplete="one-time-code" autofocus data-aegis-otp="6" data-aegis-autofocus
                   data-aegis-digit-label="${msg("aegisOtpDigitLabel")}"
                   <#if hasError>aria-invalid="true"</#if> />
          </span>
          <p class="aegis-hint">${msg("aegisOtpHint")}</p>
        </div>
      </div>

      <div class="pf-v5-c-form__group pf-m-action">
        <button id="kc-login" name="login" type="submit" class="pf-v5-c-button pf-m-primary pf-m-block">${msg("aegisVerify")}</button>
      </div>
    </form>
    <script src="${url.resourcesPath}/js/aegis.js" defer></script>
  </#if>
</@layout.registrationLayout>
