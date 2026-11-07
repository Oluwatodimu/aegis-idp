/*
 * Aegis login theme — small progressive enhancements.
 * Pages work without this file; it only improves them.
 *
 * 1. Six-box code input
 *    Any <input data-aegis-otp="6"> (Keycloak's own otp / totp field) gets
 *    one box per digit. The boxes only display: their digits are always
 *    copied back into the original field, which is what the form submits.
 *    Typing moves forward, Backspace moves back, arrow keys move, and
 *    pasting or autofill (one-time-code) fills every box at once.
 *    When the last digit is entered the form submits.
 *
 * 2. Show / hide password
 *    <button data-aegis-toggle="password-field-id"> is revealed and toggles
 *    the field between password and text.
 */
(function () {
  'use strict';

  function digitsOnly(value) {
    return String(value || '').replace(/\D+/g, '');
  }

  function enhanceOtp(original) {
    var count = parseInt(original.getAttribute('data-aegis-otp'), 10) || 6;
    var group = original.closest('.pf-v5-c-form__group') || original.parentNode;
    var form = original.form;
    var invalid = original.getAttribute('aria-invalid') === 'true';
    var labelText = original.getAttribute('data-aegis-digit-label') || 'Digit {0} of {1}';

    var wrap = document.createElement('div');
    wrap.className = 'aegis-otp' + (invalid ? ' aegis-otp-error' : '');
    wrap.style.setProperty('--aegis-otp-count', count);
    wrap.setAttribute('role', 'group');
    if (original.id) {
      var label = document.querySelector('label[for="' + original.id + '"]');
      if (label) {
        if (!label.id) label.id = original.id + '-label';
        wrap.setAttribute('aria-labelledby', label.id);
      }
    }

    var boxes = [];
    for (var i = 0; i < count; i++) {
      var box = document.createElement('input');
      box.type = 'text';
      box.inputMode = 'numeric';
      box.autocomplete = i === 0 ? 'one-time-code' : 'off';
      box.maxLength = count; // lets autofill / paste drop the whole code into one box
      box.setAttribute('aria-label', labelText.replace('{0}', i + 1).replace('{1}', count));
      if (invalid) box.setAttribute('aria-invalid', 'true');
      if (original.id && i === 0) box.id = original.id + '-1';
      boxes.push(box);
      wrap.appendChild(box);
    }

    // point the visible label at the first box
    if (original.id) {
      var lbl = document.querySelector('label[for="' + original.id + '"]');
      if (lbl) lbl.setAttribute('for', boxes[0].id);
    }

    var submitted = false;
    function sync() {
      var code = boxes.map(function (b) { return b.value; }).join('');
      original.value = code;
      if (code.length === count && /^\d+$/.test(code) && form && !submitted) {
        submitted = true;
        // give the browser a frame to paint the last digit
        window.setTimeout(function () {
          if (typeof form.requestSubmit === 'function') {
            var btn = form.querySelector('[type="submit"][name="login"], #kc-login, [type="submit"]');
            form.requestSubmit(btn || undefined);
          } else {
            form.submit();
          }
        }, 60);
      }
    }

    function fillFrom(index, text) {
      var digits = digitsOnly(text).slice(0, count - index);
      for (var j = 0; j < digits.length; j++) boxes[index + j].value = digits[j];
      var next = Math.min(index + digits.length, count - 1);
      boxes[next].focus();
      boxes[next].select();
      sync();
    }

    boxes.forEach(function (box, index) {
      box.addEventListener('input', function () {
        var value = digitsOnly(box.value);
        if (value.length > 1) { box.value = ''; fillFrom(index, value); return; }
        box.value = value;
        if (value && index < count - 1) boxes[index + 1].focus();
        sync();
      });
      box.addEventListener('keydown', function (e) {
        if (e.key === 'Backspace' && !box.value && index > 0) {
          boxes[index - 1].value = '';
          boxes[index - 1].focus();
          submitted = false;
          sync();
          e.preventDefault();
        } else if (e.key === 'ArrowLeft' && index > 0) {
          boxes[index - 1].focus(); e.preventDefault();
        } else if (e.key === 'ArrowRight' && index < count - 1) {
          boxes[index + 1].focus(); e.preventDefault();
        } else if (e.key === 'Backspace' || e.key === 'Delete') {
          submitted = false;
        }
      });
      box.addEventListener('paste', function (e) {
        var text = (e.clipboardData || window.clipboardData).getData('text');
        e.preventDefault();
        fillFrom(index, text);
      });
      box.addEventListener('focus', function () { box.select(); });
    });

    // hide the original visually (it still submits) and show the boxes
    original.setAttribute('tabindex', '-1');
    original.setAttribute('aria-hidden', 'true');
    original.removeAttribute('autofocus');
    original.removeAttribute('autocomplete');
    var control = original.closest('.pf-v5-c-form-control') || original;
    control.parentNode.insertBefore(wrap, control);
    group.classList.add('aegis-otp-enhanced');

    // keep any value Keycloak re-rendered (normally none)
    if (original.value) fillFrom(0, original.value);
    if (form) form.addEventListener('submit', function () { submitted = true; });
    if (original.hasAttribute('data-aegis-autofocus') || document.activeElement === document.body) {
      boxes[0].focus();
    }
  }

  function enhanceToggles() {
    var buttons = document.querySelectorAll('[data-aegis-toggle]');
    Array.prototype.forEach.call(buttons, function (button) {
      var field = document.getElementById(button.getAttribute('data-aegis-toggle'));
      if (!field) return;
      var showLabel = button.getAttribute('data-label-show') || 'Show password';
      var hideLabel = button.getAttribute('data-label-hide') || 'Hide password';
      button.hidden = false;
      button.addEventListener('click', function () {
        var showing = field.type === 'text';
        field.type = showing ? 'password' : 'text';
        button.setAttribute('aria-pressed', String(!showing));
        button.setAttribute('aria-label', showing ? showLabel : hideLabel);
        button.textContent = showing ? button.getAttribute('data-text-show') : button.getAttribute('data-text-hide');
      });
    });
  }

  function init() {
    Array.prototype.forEach.call(document.querySelectorAll('input[data-aegis-otp]'), enhanceOtp);
    enhanceToggles();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
