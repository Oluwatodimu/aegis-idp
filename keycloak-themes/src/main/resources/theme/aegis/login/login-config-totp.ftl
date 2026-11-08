<#--
  Aegis — set up two-step verification (Keycloak required action CONFIGURE_TOTP).
  Keeps every field Keycloak expects: totp, totpSecret, mode, userLabel, logout-sessions,
  and cancel-aia for app-initiated setup. The code field becomes six boxes via js/aegis.js.
  The QR code always sits on a white tile so phones can scan it in dark mode.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayRequiredFields=false displayMessage=!messagesPerField.existsError('totp','userLabel'); section>
  <#if section = "header">
    ${msg("loginTotpTitle")}
  <#elseif section = "form">
    <ol id="kc-totp-settings" class="aegis-totp-steps">
      <li>
        <p>${msg("loginTotpStep1")}</p>
        <ul id="kc-totp-supported-apps" class="aegis-apps">
          <#list totp.supportedApplications as app>
            <li>${msg(app)}</li>
          </#list>
        </ul>
      </li>

      <#if mode?? && mode = "manual">
        <li>
          <p>${msg("loginTotpManualStep2")}</p>
          <p id="kc-totp-secret-key" class="aegis-key">${totp.totpSecretEncoded}</p>
          <p><a href="${totp.qrUrl}" id="mode-barcode">${msg("loginTotpScanBarcode")}</a></p>
        </li>
        <li>
          <p>${msg("loginTotpManualStep3")}</p>
          <dl class="aegis-totp-details">
            <dt id="kc-totp-type">${msg("loginTotpType")}</dt><dd>${msg("loginTotp." + totp.policy.type)}</dd>
            <dt id="kc-totp-algorithm">${msg("loginTotpAlgorithm")}</dt><dd>${totp.policy.getAlgorithmKey()}</dd>
            <dt id="kc-totp-digits">${msg("loginTotpDigits")}</dt><dd>${totp.policy.digits}</dd>
            <#if totp.policy.type = "totp">
              <dt id="kc-totp-period">${msg("loginTotpInterval")}</dt><dd>${totp.policy.period}</dd>
            <#elseif totp.policy.type = "hotp">
              <dt id="kc-totp-counter">${msg("loginTotpCounter")}</dt><dd>${totp.policy.initialCounter}</dd>
            </#if>
          </dl>
        </li>
      <#else>
        <li>
          <p>${msg("loginTotpStep2")}</p>
          <img id="kc-totp-secret-qr-code" class="aegis-qr" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="${msg("aegisTotpQrAlt")}">
          <p style="text-align:center"><a href="${totp.manualUrl}" id="mode-manual">${msg("loginTotpUnableToScan")}</a></p>
        </li>
      </#if>

      <li>
        <p>${msg("loginTotpStep3")}</p>
      </li>
    </ol>

    <form action="${url.loginAction}" class="pf-v5-c-form" id="kc-totp-settings-form" method="post" novalidate="novalidate">
      <div class="pf-v5-c-form__group">
        <div class="pf-v5-c-form__group-label">
          <label class="pf-v5-c-form__label" for="totp"><span class="pf-v5-c-form__label-text">${msg("authenticatorCode")}</span></label>
        </div>
        <div class="pf-v5-c-form__group-control">
          <span class="pf-v5-c-form-control<#if messagesPerField.existsError('totp')> pf-m-error</#if>">
            <input type="text" id="totp" name="totp" inputmode="numeric" pattern="[0-9]*" autocomplete="one-time-code"
                   data-aegis-otp="${totp.policy.digits}" data-aegis-digit-label="${msg("aegisOtpDigitLabel")}"
                   <#if messagesPerField.existsError('totp')>aria-invalid="true" aria-describedby="input-error-otp-code"</#if> />
          </span>
          <#if messagesPerField.existsError('totp')>
            <div class="pf-v5-c-form__helper-text" aria-live="polite">
              <div class="pf-v5-c-helper-text"><div class="pf-v5-c-helper-text__item pf-m-error">
                <span id="input-error-otp-code" class="pf-v5-c-helper-text__item-text">${kcSanitize(messagesPerField.get('totp'))?no_esc}</span>
              </div></div>
            </div>
          </#if>
        </div>
        <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
        <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}"/></#if>
      </div>

      <div class="pf-v5-c-form__group">
        <div class="pf-v5-c-form__group-label">
          <label class="pf-v5-c-form__label" for="userLabel">
            <span class="pf-v5-c-form__label-text">${msg("loginTotpDeviceName")}<#if totp.otpCredentials?size gte 1> *<#else> <span style="font-weight:400;color:var(--aegis-muted)">${msg("aegisOptional")}</span></#if></span>
          </label>
        </div>
        <div class="pf-v5-c-form__group-control">
          <span class="pf-v5-c-form-control<#if messagesPerField.existsError('userLabel')> pf-m-error</#if>">
            <input type="text" id="userLabel" name="userLabel" autocomplete="off" placeholder="${msg("aegisDeviceNamePlaceholder")}"
                   <#if messagesPerField.existsError('userLabel')>aria-invalid="true" aria-describedby="input-error-otp-label"</#if> />
          </span>
          <#if messagesPerField.existsError('userLabel')>
            <div class="pf-v5-c-form__helper-text" aria-live="polite">
              <div class="pf-v5-c-helper-text"><div class="pf-v5-c-helper-text__item pf-m-error">
                <span id="input-error-otp-label" class="pf-v5-c-helper-text__item-text">${kcSanitize(messagesPerField.get('userLabel'))?no_esc}</span>
              </div></div>
            </div>
          </#if>
        </div>
      </div>

      <div class="pf-v5-c-form__group">
        <div class="pf-v5-c-check">
          <input class="pf-v5-c-check__input" type="checkbox" id="logout-sessions" name="logout-sessions" value="on">
          <label class="pf-v5-c-check__label" for="logout-sessions">${msg("logoutOtherSessions")}</label>
        </div>
      </div>

      <div class="pf-v5-c-form__group pf-m-action">
        <#if isAppInitiatedAction??>
          <div style="display:grid;gap:0.5rem;">
            <button type="submit" id="saveTOTPBtn" class="pf-v5-c-button pf-m-primary pf-m-block">${msg("aegisConfirm")}</button>
            <button type="submit" id="cancelTOTPBtn" name="cancel-aia" value="true" formnovalidate class="pf-v5-c-button pf-m-secondary pf-m-block">${msg("doCancel")}</button>
          </div>
        <#else>
          <button type="submit" id="saveTOTPBtn" class="pf-v5-c-button pf-m-primary pf-m-block">${msg("aegisConfirm")}</button>
        </#if>
      </div>
    </form>
  </#if>
</@layout.registrationLayout>
