$(document).ready(function(){var i=$("div.setup-panel div a"),r=$(".setup-content"),t=$(".nextBtn"),e=$(".prevBtn"),a=$(".last-back"),n=$(".last-sec");r.hide(),a.click(function(){n.hide();var t=$(this).closest(".setup-content").attr("id"),e=$('div.setup-panel div a[href="#'+t+'"]'),a=$('div.setup-panel div a[href="#'+t+'"]').parent().prev().children("a");e.attr("disabled","disabled"),a.trigger("click")}),i.click(function(t){t.preventDefault();var e=$($(this).attr("href")),a=$(this);a.hasClass("disabled")||(i.removeClass("btn-primary").addClass("btn-default"),a.addClass("btn-primary"),r.hide(),e.show(),e.find("input:eq(0)").focus())}),e.click(function(){var t=$(this).closest(".setup-content").attr("id");$('div.setup-panel div a[href="#'+t+'"]').parent().prev().children("a").trigger("click")}),t.click(function(){var t=$(this).closest(".setup-content"),e=t.attr("id"),a=$('div.setup-panel div a[href="#'+e+'"]').parent().next().children("a"),i=t.find("input[type='text'],input[type='url']"),r=!0;$(".form-group").removeClass("has-error");for(var n=0;n<i.length;n++)i[n].validity.valid||(r=!1,$(i[n]).closest(".form-group").addClass("has-error"));r&&a.removeAttr("disabled").trigger("click")}),$("div.setup-panel div a.btn-primary").trigger("click");var s=(new Date).getTime();$("#tpcp").val(s),$("div.btn-group[data-toggle-name]").each(function(){var e=$(this),t=e.parents("form").eq(0),a=e.attr("data-toggle-name"),i=$('input[name="'+a+'"]',t);$("button",e).each(function(){var t=$(this);t.on("click",function(){i.val($(this).val()),$("button",e).removeClass("active"),t.addClass("active")}),t.val()==i.val()&&t.addClass("active")})})});