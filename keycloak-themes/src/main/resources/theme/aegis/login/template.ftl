<#--
  Aegis — shared page layout for every login page (split screen).
  Copied from keycloak.v2 26.7.3 template.ftl. Aegis changes are marked "Aegis:".
  On a Keycloak upgrade: copy the new keycloak.v2 template.ftl and re-apply them.
    1. registrationLayout takes infoTop (login.ftl puts "New to Aegis?" under the title).
    2. <body> wraps the page in .aegis-split with the dark brand panel on the left.
    3. The logo comes from the theme, not the realm's HTML display name.
    4. "Secured by Aegis" line under the form.
    5. Stylesheet and script links get ?v=<aegisAssetVersion> to beat the browser cache.
-->
<#import "field.ftl" as field>
<#import "footer.ftl" as loginFooter>
<#import "theme-resources.ftl" as themeResourceTags>
<#macro username>
  <#assign label>
    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
  </#assign>
  <@field.group name="username" label=label>
    <div class="${properties.kcInputGroup}">
      <div class="${properties.kcInputGroupItemClass} ${properties.kcFill}">
        <span class="${properties.kcInputClass} ${properties.kcFormReadOnlyClass}">
          <input id="kc-attempted-username" value="${auth.attemptedUsername}" readonly>
        </span>
      </div>
      <div class="${properties.kcInputGroupItemClass}">
        <button id="reset-login" class="${properties.kcFormPasswordVisibilityButtonClass} kc-login-tooltip" type="button" 
              aria-label="${msg('restartLoginTooltip')}" onclick="location.href='${url.loginRestartFlowUrl}'">
            <i class="fa-sync-alt fas" aria-hidden="true"></i>
            <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
        </button>
      </div>
    </div>
  </@field.group>
</#macro>

<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false infoTop=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${lang}"<#if realm.internationalizationEnabled> dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="color-scheme" content="light${darkMode?then(' dark', '')}">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${title!}</title>
    <#if themeResources?? && themeResources.favicons?has_content>
        <@themeResourceTags.renderFavicons themeResources.favicons url.resourcesPath />
    <#else>
        <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    </#if>
    <#if themeResources?? && themeResources.stylesCommon?has_content>
        <@themeResourceTags.renderStyles themeResources.stylesCommon url.resourcesCommonPath />
    <#elseif properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#-- Aegis: Keycloak 26 fills themeResources from theme.properties, so the first branch is the one
         that normally runs; check aegisAssetVersion first so our ?v= is actually used. -->
    <#if properties.aegisAssetVersion?has_content && properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}?v=${properties.aegisAssetVersion}" rel="stylesheet" />
        </#list>
    <#elseif themeResources?? && themeResources.styles?has_content>
        <@themeResourceTags.renderStyles themeResources.styles url.resourcesPath />
    <#elseif properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <#-- Aegis: ?v= so browsers fetch the new CSS after a rebuild (bump aegisAssetVersion) -->
            <link href="${url.resourcesPath}/${style}<#if properties.aegisAssetVersion?has_content>?v=${properties.aegisAssetVersion}</#if>" rel="stylesheet" />
        </#list>
    </#if>
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>
    <#if darkMode>
      <script type="module" async blocking="render">
          <#outputformat "JavaScript">
          const DARK_MODE_CLASS = ${properties.kcDarkModeClass?c};
          const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

          updateDarkMode(mediaQuery.matches);
          mediaQuery.addEventListener("change", (event) => updateDarkMode(event.matches));

          function updateDarkMode(isEnabled) {
            const { classList } = document.documentElement;

            if (isEnabled) {
              classList.add(DARK_MODE_CLASS);
            } else {
              classList.remove(DARK_MODE_CLASS);
            }
          }
          </#outputformat>
      </script>
    </#if>
    <#-- Aegis: same as the stylesheets above -->
    <#if properties.aegisAssetVersion?has_content && properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}?v=${properties.aegisAssetVersion}" type="text/javascript" defer></script>
        </#list>
    <#elseif themeResources?? && themeResources.scripts?has_content>
        <@themeResourceTags.renderScripts themeResources.scripts url.resourcesPath "text/javascript" />
    <#elseif properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <#-- Aegis: ?v= like the stylesheets; defer so it runs after the page is parsed -->
            <script src="${url.resourcesPath}/${script}<#if properties.aegisAssetVersion?has_content>?v=${properties.aegisAssetVersion}</#if>" type="text/javascript" defer></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    <script type="module">
        <#outputformat "JavaScript">
        import { startSessionPolling } from ${(url.resourcesPath + "/js/authChecker.js")?c};

        startSessionPolling(
            ${url.ssoLoginInOtherTabsUrl?c}
        );
        </#outputformat>
    </script>
    <script type="module">
        document.addEventListener("click", (event) => {
            const link = event.target.closest("a[data-once-link]");

            if (!link) {
                return;
            }

            if (link.getAttribute("aria-disabled") === "true") {
                event.preventDefault();
                return;
            }

            const { disabledClass } = link.dataset;

            if (disabledClass) {
                link.classList.add(...disabledClass.trim().split(/\s+/));
            }

            link.setAttribute("role", "link");
            link.setAttribute("aria-disabled", "true");
        });
    </script>
    <#if authenticationSession??>
        <script type="module">
             <#outputformat "JavaScript">
            import { checkAuthSession } from ${(url.resourcesPath + "/js/authChecker.js")?c};

            checkAuthSession(
                ${authenticationSession.authSessionIdHash?c}
            );
            </#outputformat>
        </script>
    </#if>
    <script>
      // Workaround for https://bugzilla.mozilla.org/show_bug.cgi?id=1404468
      const isFirefox = true;
    </script>
</head>

<body id="keycloak-bg" class="${properties.kcBodyClass!}" data-page-id="login-${pageId}">
<#-- Aegis: split screen. The panel is hidden below 860px (see aegis.css). -->
<div class="aegis-split">
<aside class="aegis-panel">
  <svg class="aegis-panel__mark" aria-hidden="true" viewBox="0 0 22 24" fill="none"><path d="M11 1.5 20 5v6.5c0 5.4-3.7 9.6-9 11-5.3-1.4-9-5.6-9-11V5l9-3.5Z" stroke="currentColor" stroke-width="0.45"/><path d="M11 6.5v11M6.5 9.5 11 12l4.5-2.5" stroke="currentColor" stroke-width="0.45" stroke-linecap="round"/></svg>
  <img class="aegis-panel__logo" src="${url.resourcesPath}/img/logo-light.svg" alt="${msg("aegisBrandName")}" width="112" height="35">
  <div class="aegis-panel__copy">
    <p class="aegis-panel__headline">${msg("aegisPanelHeadline")}</p>
    <p class="aegis-panel__text">${msg("aegisPanelText")}</p>
  </div>
  <p class="aegis-panel__standards">${msg("aegisPanelStandards")}</p>
</aside>
<div class="aegis-split__main">
<div class="${properties.kcLogin!}">
  <div class="${properties.kcLoginContainer!}">
    <header id="kc-header" class="pf-v5-c-login__header">
      <#-- Aegis: logo from the theme (text kept for screen readers) -->
      <div id="kc-header-wrapper" class="pf-v5-c-brand"><div class="kc-logo-text"><span>${msg("aegisBrandName")}</span></div></div>
    </header>
    <main class="${properties.kcLoginMain!}">
      <div class="${properties.kcLoginMainHeader!}">
        <h1 class="${properties.kcLoginMainTitle!}" id="kc-page-title"><#nested "header"></h1>
        <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
        <div class="${properties.kcLoginMainHeaderUtilities!}">
          <div class="${properties.kcInputClass!}">
            <select
              aria-label="${msg("languages")}"
              id="login-select-toggle"
              onchange="if (this.value) window.location.href=this.value"
            >
              <#list locale.supported?sort_by("label") as l>
                <option
                  value="${l.url}"
                  ${(l.languageTag == locale.currentLanguageTag)?then('selected','')}
                >
                  ${l.label}
                </option>
              </#list>
            </select>
            <span class="${properties.kcFormControlUtilClass}">
              <span class="${properties.kcFormControlToggleIcon!}">
                <svg
                  class="pf-v5-svg"
                  viewBox="0 0 320 512"
                  fill="currentColor"
                  aria-hidden="true"
                  role="img"
                  width="1em"
                  height="1em"
                >
                  <path
                    d="M31.3 192h257.3c17.8 0 26.7 21.5 14.1 34.1L174.1 354.8c-7.8 7.8-20.5 7.8-28.3 0L17.2 226.1C4.6 213.5 13.5 192 31.3 192z"
                  >
                  </path>
                </svg>
              </span>
            </span>
          </div>
        </div>
        </#if>
      </div>
      <#-- Aegis: "New to Aegis? Create an account" under the title on the sign-in page -->
      <#if displayInfo && infoTop>
        <div id="kc-info" class="aegis-subtitle"><#nested "info"></div>
      </#if>
      <div class="${properties.kcLoginMainBody!}">
        <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="${properties.kcInputHelperTextItemTextClass!}">
                          <span class="${properties.kcInputRequiredClass!}">*</span> ${msg("requiredFields")}
                        </span>
                    </div>
                </div>
            </#if>
        <#else>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="${properties.kcInputHelperTextItemTextClass!}">
                          <span class="${properties.kcInputRequiredClass!}">*</span> ${msg("requiredFields")}
                        </span>
                    </div>
                    <div class="${properties.kcFormClass} ${properties.kcContentWrapperClass}">
                        <#nested "show-username">
                        <@username />
                    </div>
                </div>
            <#else>
                <div class="${properties.kcFormClass} ${properties.kcContentWrapperClass}">
                  <#nested "show-username">
                  <@username />
                </div>
            </#if>
        </#if>

        <#-- App-initiated actions should not see warning messages about the need to complete the action -->
        <#-- during login.                                                                               -->
        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
            <div class="${properties.kcAlertClass!} pf-m-${(message.type = 'error')?then('danger', message.type)}">
                <div class="${properties.kcAlertIconClass!}">
                    <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                    <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                    <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                    <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                </div>
                <span class="${properties.kcAlertTitleClass!} kc-feedback-text">${message.summary}</span>
            </div>
        </#if>

        <#nested "form">

        <#if auth?has_content && auth.showTryAnotherWayLink()>
          <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" novalidate="novalidate">
              <input type="hidden" name="tryAnotherWay" value="on"/>
              <a id="try-another-way" href="javascript:document.forms['kc-select-try-another-way-form'].requestSubmit()"
                  class="${properties.kcButtonSecondaryClass} ${properties.kcButtonBlockClass} ${properties.kcMarginTopClass}">
                    ${msg("doTryAnotherWay")}
              </a>
          </form>
        </#if>

        <#if switchOrganizationEnabled?? && switchOrganizationEnabled>
          <form id="kc-switch-organization-form" action="${url.loginAction}" method="post" novalidate="novalidate">
              <input type="hidden" name="switchOrganization" value="true"/>
              <a id="switch-organization" href="javascript:document.forms['kc-switch-organization-form'].requestSubmit()"
                  class="${properties.kcButtonSecondaryClass} ${properties.kcButtonBlockClass} ${properties.kcMarginTopClass}">
                    ${msg("doSwitchOrganization")}
              </a>
          </form>
        </#if>

          <div class="${properties.kcLoginMainFooter!}">
              <#nested "socialProviders">

              <#if displayInfo && !infoTop>
                  <div id="kc-info" class="${properties.kcLoginMainFooterBand!} ${properties.kcFormClass}">
                      <div id="kc-info-wrapper" class="${properties.kcLoginMainFooterBandItem!}">
                          <#nested "info">
                      </div>
                  </div>
              </#if>
          </div>
      </div>

        <div class="${properties.kcLoginMainFooter!}">
            <@loginFooter.content/>
        </div>
    </main>
  </div>
  <#-- Aegis -->
  <p class="aegis-secured"><svg width="12" height="13" viewBox="0 0 22 24" fill="none" aria-hidden="true"><path d="M11 1.5 20 5v6.5c0 5.4-3.7 9.6-9 11-5.3-1.4-9-5.6-9-11V5l9-3.5Z" stroke="currentColor" stroke-width="2"/></svg>${msg("aegisSecuredBy")}</p>
</div>
</div>
</div>
</body>
</html>
</#macro>
