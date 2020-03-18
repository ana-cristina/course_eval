$(document).ready(function () {
  var navListItems = $('div.setup-panel div a'),
          allWells = $('.setup-content'),
          allNextBtn = $('.nextBtn'),
          allPrevBtn = $('.prevBtn'),
      lastBack = $('.last-back'),
      lastSection = $('.last-sec');

  allWells.hide();

    lastBack.click(function(e){
       lastSection.hide();
        var curStep = $(this).closest(".setup-content"),
            curStepBtn = curStep.attr("id"),
            curStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]'),
            prevStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children("a");

        curStepWizard.attr('disabled','disabled');
        prevStepWizard.trigger('click');
    });
  navListItems.click(function (e) {
      e.preventDefault();
      var $target = $($(this).attr('href')),
              $item = $(this);

      if (!$item.hasClass('disabled')) {
          navListItems.removeClass('btn-primary').addClass('btn-default');
          $item.addClass('btn-primary');
          allWells.hide();
          $target.show();
          $target.find('input:eq(0)').focus();
      }
  });

  allPrevBtn.click(function(){
      var curStep = $(this).closest(".setup-content"),
          curStepBtn = curStep.attr("id"),
          prevStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children("a");

          prevStepWizard.trigger('click');
  });

  allNextBtn.click(function(){
      var curStep = $(this).closest(".setup-content"),
          curStepBtn = curStep.attr("id"),
          nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a"),
          curInputs = curStep.find("input[type='text'],input[type='url']"),
          isValid = true;

      $(".form-group").removeClass("has-error");
      for(var i=0; i<curInputs.length; i++){
          if (!curInputs[i].validity.valid){
              isValid = false;
              $(curInputs[i]).closest(".form-group").addClass("has-error");
          }
      }

      if (isValid)
          nextStepWizard.removeAttr('disabled').trigger('click');
  });

  $('div.setup-panel div a.btn-primary').trigger('click');


    //radio buttons
    var session_time = new Date().getTime();
    $("#tpcp").val(session_time);
    //for radio buttons
    $('div.btn-group[data-toggle-name]').each(function () {
        var group = $(this);
        var form = group.parents('form').eq(0);
        var name = group.attr('data-toggle-name');
        var hidden = $('input[name="' + name + '"]', form);
        $('button', group).each(function () {
            var button = $(this);
            button.on('click', function () {
                hidden.val($(this).val());
                $('button', group).removeClass('active');
                button.addClass('active');
            });
            if (button.val() == hidden.val()) {
                button.addClass('active');
            }
        });
    });
});