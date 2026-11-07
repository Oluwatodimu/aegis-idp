<#--
  Aegis email layout. Every HTML email renders inside <@emailLayout>.
  Email apps ignore external CSS and many strip <style>, so layout and colours
  are inline, built with tables. Emails are light only: no dark-mode styles,
  and color-scheme tells mail apps not to recolour them. The <style> block
  only styles links/paragraphs inside Keycloak's default email bodies.

  Macros:
    <@emailLayout preheader="…">…</@emailLayout>   page wrapper
    <@heading>…</@heading>                         title
    <@text>…</@text>                               paragraph
    <@button href="…" label="…"/>                  primary button (bulletproof)
    <@facts>…<@fact label="…" value="…"/>…</@facts> label/value box (time, IP)
    <@fallbackLink href="…"/>                      "Button not working?" link
-->
<#assign ink = "#111214">
<#assign muted = "#5B5F66">
<#assign line = "#E4E4E0">
<#assign ground = "#F6F6F4">
<#assign accent = "#2B45D4">
<#assign font = "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif">

<#macro emailLayout preheader="">
<!DOCTYPE html>
<html lang="${locale.language}" dir="${(ltr)?then('ltr','rtl')}" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="x-apple-disable-message-reformatting">
  <!-- light only: ask mail apps not to switch these emails to dark mode -->
  <meta name="color-scheme" content="light only">
  <meta name="supported-color-schemes" content="light only">
  <title>Aegis</title>
  <style>
    .ae-body p { margin: 0 0 16px; }
    .ae-body p:last-child { margin-bottom: 0; }
    .ae-body a { color: ${ink}; font-weight: 600; text-decoration: underline; }
    .ae-body b, .ae-body strong { color: ${ink}; }
    @media (max-width: 600px) {
      .ae-card { padding: 28px 22px !important; }
      .ae-outer { padding: 20px 12px !important; }
    }
    :root { color-scheme: light only; }
  </style>
</head>
<body class="ae-bg" style="margin:0; padding:0; background:${ground}; -webkit-text-size-adjust:100%;">
  <#if preheader?has_content>
    <div style="display:none; max-height:0; overflow:hidden; mso-hide:all; font-size:1px; line-height:1px; color:${ground}; opacity:0;">${preheader}&#847; &#847; &#847; &#847; &#847; &#847; &#847; &#847;</div>
  </#if>
  <table role="presentation" class="ae-bg" width="100%" cellpadding="0" cellspacing="0" border="0" style="background:${ground};">
    <tr>
      <td class="ae-outer" align="center" style="padding:32px 16px;">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:560px;">

          <!-- card -->
          <tr>
            <td class="ae-card ae-body" style="background:#FFFFFF; border:1px solid ${line}; border-radius:14px; padding:36px 40px; font-family:${font}; font-size:15px; line-height:1.6; color:${muted};">

              <!-- logo -->
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td class="ae-rule" style="padding-bottom:20px; border-bottom:1px solid ${line};">
                    <#if properties.logoUrl?has_content>
                      <span class="ae-logo-tile" style="display:inline-block; border-radius:6px;">
                        <img src="${properties.logoUrl}" alt="Aegis" width="128" height="40" style="display:block; width:128px; height:40px; border:0; outline:none;">
                      </span>
                    <#else>
                      <span class="ae-ink" style="font-family:${font}; font-size:22px; font-weight:700; letter-spacing:-0.4px; color:${ink};">Aegis</span>
                    </#if>
                  </td>
                </tr>
              </table>

              <div style="height:24px; line-height:24px; font-size:0;">&nbsp;</div>

              <#nested>

            </td>
          </tr>

          <!-- footer -->
          <tr>
            <td class="ae-muted" style="padding:20px 8px 0; font-family:${font}; font-size:12px; line-height:1.6; color:#8B8F98;">
              ${msg("aegisEmailFooter")}<br>
              <#if properties.aegisCompanyAddress?has_content>Aegis &middot; ${properties.aegisCompanyAddress}</#if>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
</#macro>

<#macro heading>
  <h1 class="ae-ink" style="margin:0 0 12px; font-family:${font}; font-size:22px; line-height:1.3; font-weight:600; letter-spacing:-0.2px; color:${ink};"><#nested></h1>
</#macro>

<#macro text small=false>
  <p class="ae-muted" style="margin:0 0 16px; font-family:${font}; font-size:<#if small>13px<#else>15px</#if>; line-height:1.6; color:${muted};"><#nested></p>
</#macro>

<#macro button href label>
  <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:8px 0 20px;">
    <tr>
      <td class="ae-btn-cell" align="center" bgcolor="${ink}" style="background:${ink}; border-radius:8px;">
        <a class="ae-btn" href="${href}" target="_blank" style="display:inline-block; padding:12px 22px; font-family:${font}; font-size:15px; font-weight:600; line-height:20px; color:#FFFFFF; text-decoration:none; border-radius:8px;">${label}</a>
      </td>
    </tr>
  </table>
</#macro>

<#macro facts>
  <table role="presentation" class="ae-facts" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin:4px 0 20px; background:#FAFAF8; border:1px solid #EEEEEB; border-radius:8px;">
    <#nested>
  </table>
</#macro>

<#macro fact label value>
  <tr>
    <td class="ae-muted" width="110" style="padding:8px 12px; font-family:${font}; font-size:13px; color:${muted}; vertical-align:top;">${label}</td>
    <td class="ae-ink" style="padding:8px 12px; font-family:${font}; font-size:13px; color:${ink}; vertical-align:top;">${value}</td>
  </tr>
</#macro>

<#macro fallbackLink href>
  <p class="ae-muted" style="margin:0 0 4px; font-family:${font}; font-size:12px; line-height:1.5; color:#8B8F98;">${msg("aegisEmailButtonFallback")}</p>
  <p style="margin:0 0 16px; font-family:${font}; font-size:12px; line-height:1.5; word-break:break-all;"><a class="ae-link" href="${href}" style="color:${ink}; font-weight:400; text-decoration:underline;">${href}</a></p>
</#macro>
