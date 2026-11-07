<#--
  Aegis — sign in.
  Differences from keycloak.v2:
    • errors show as one alert above the form (same text for a wrong password,
      an unknown email and a lockout), and both fields are marked invalid;
    • "Create an account" goes to the Aegis app (theme property aegisSignupUrl),
      because registration in Keycloak is switched off.
  Field names (username, password, rememberMe, credentialId, login) must stay as they are.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true infoTop=true displayInfo=(realm.password && properties.aegisSignupUrl?has_content && !(usernameHidden??)); section>
  <#if section = "header">
    ${msg("loginAccountTitle")}
  <#elseif section = "form">
    <div id="kc-form">
      <#if realm.password>
        <#assign hasError = messagesPerField.existsError('username','password')>
        <form id="kc-form-login" class="pf-v5-c-form" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" novalidate="novalidate">

          <#if !usernameHidden??>
            <div class="pf-v5-c-form__group">
              <div class="pf-v5-c-form__group-label">
                <label class="pf-v5-c-form__label" for="username">
                  <span class="pf-v5-c-form__label-text"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></span>
                </label>
              </div>
              <div class="pf-v5-c-form__group-control">
                <span class="pf-v5-c-form-control<#if hasError> pf-m-error</#if>">
                  <input id="username" name="username" value="${(login.username!'')}" type="text"
                         autocomplete="username" autocapitalize="none" spellcheck="false" autofocus
                         <#if hasError>aria-invalid="true"</#if> />
                </span>
              </div>
            </div>
          </#if>

          <div class="pf-v5-c-form__group">
            <div class="pf-v5-c-form__group-label aegis-label-row">
              <label class="pf-v5-c-form__label" for="password">
                <span class="pf-v5-c-form__label-text">${msg("password")}</span>
              </label>
              <#if realm.resetPasswordAllowed>
                <a id="kc-forgot-password" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
              </#if>
            </div>
            <div class="pf-v5-c-form__group-control">
              <div class="pf-v5-c-input-group">
                <div class="pf-v5-c-input-group__item pf-m-fill">
                  <span class="pf-v5-c-form-control<#if hasError> pf-m-error</#if>">
                    <input id="password" name="password" type="password" autocomplete="current-password"
                           <#if usernameHidden??>autofocus</#if>
                           <#if hasError>aria-invalid="true"</#if> />
                  </span>
                </div>
                <div class="pf-v5-c-input-group__item">
                  <button class="pf-v5-c-button pf-m-control" type="button" hidden
                          data-aegis-toggle="password"
                          aria-label="${msg("showPassword")}" aria-pressed="false"
                          data-label-show="${msg("showPassword")}" data-label-hide="${msg("hidePassword")}"
                          data-text-show="${msg("aegisShow")}" data-text-hide="${msg("aegisHide")}">${msg("aegisShow")}</button>
                </div>
              </div>
            </div>
          </div>

          <#if realm.rememberMe && !usernameHidden??>
            <div class="pf-v5-c-form__group">
              <div class="pf-v5-c-check">
                <input class="pf-v5-c-check__input" id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                <label class="pf-v5-c-check__label" for="rememberMe">${msg("rememberMe")}</label>
              </div>
            </div>
          </#if>

          <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>

          <div class="pf-v5-c-form__group pf-m-action">
            <button id="kc-login" name="login" type="submit" class="pf-v5-c-button pf-m-primary pf-m-block">${msg("doLogIn")}</button>
          </div>
        </form>
        <script src="${url.resourcesPath}/js/aegis.js" defer></script>
      </#if>
    </div>

  <#elseif section = "info">
    <div id="kc-registration-container">
      <div id="kc-registration">
        <span>${msg("noAccount")} <a href="${properties.aegisSignupUrl}">${msg("doRegister")}</a></span>
      </div>
    </div>

  <#elseif section = "socialProviders">
    <#if realm.password && social?? && social.providers?has_content>
      <div id="kc-social-providers" class="pf-v5-c-login__main-body">
        <div class="pf-v5-c-divider" role="separator"></div>
        <ul class="pf-v5-c-login__main-footer-links" style="display:grid;gap:0.5rem;padding:1rem 0 0;list-style:none;">
          <#list social.providers as p>
            <li>
              <a id="social-${p.alias}" class="pf-v5-c-button pf-m-secondary pf-m-block" href="${p.loginUrl}">${p.displayName!}</a>
            </li>
          </#list>
        </ul>
      </div>
    </#if>
  </#if>
</@layout.registrationLayout>
