$(function() {
  function displayButton() {
    $(".deletefile").attr("style", "display: block;");
    $(".deleteprev").attr("style", "display: block;");
  };
  function hiddenButton() {
    $(".deletefile").attr("style", "display: none;");
    $(".deleteprev").attr("style", "display: none;");
  };
  function buildInput(label, input_count) {
    label.attr("for", `filearea${input_count + 1}`);
    label.before(`<input name="product[photos_attributes][${input_count + 1}][image]" id="filearea${input_count + 1}" type="file" class="fileinput fileinput${input_count + 1}" style="display: none;">`);
  };

  img_count = 0 + $(".prev_count").length;
  input_count = 0 + $(".prev_count").length;
  if (img_count == 10) {
    $("#files").find("label").attr("style", "display: none;");
  } else if (img_count == 1) {
    $(".deleteprev").attr('style', 'display: none;');
  };

  $(".file-label").on("click", function() {
    $(".fileinput").change(function() {
      let label = $("#files").find("label");
      let file = $(this).prop("files")[0];

      if (!file.type.match("image.*")) {
        alert("この形式のファイルはアップロードできません");
        $(this).remove();
        buildInput(label, input_count);
        input_count += 1;
        return;
      } else {
        let reader = new FileReader();
        reader.onload = function() {
          let img_src = $('<img style="width: 7rem;height: 7rem;">').attr("src", reader.result);
          let box = $(`<div class="fileinput${input_count - 1}" style="margin-bottom: 0.3rem;background: whitesmoke;display: flex;flex-direction: column;justify-content: center;align-items: center;"></div>`);
          let box2 = box.append(img_src).append('<p class="deletefile" style="margin: 0;padding: 0.2rem;color: #4897d8;font-size: 0.9rem;font-weight: normal;cursor: pointer;">削除</p>');
          $(".prev_box").append(box2);
        };
        reader.readAsDataURL(file);
        buildInput(label, input_count);
        img_count += 1;
        input_count += 1;
        if (img_count == 10) {
          label.attr("style", "display: none;");
        }
        if(img_count == 2) {
          displayButton();
        }
      }
    });
  });

  $(document).on("click", ".deletefile", function() {
    boxClass = $(this).parent().prop("class");
    $(`.${boxClass}`).remove();
    if (img_count == 10) {
      $(".file-label").attr("style", "display: flex;");
    }
    if (img_count == 2) {
      hiddenButton();
    }
    img_count -= 1;
  });

  $(".deleteprev").on("click", function() {
    let checkBox = $(this).parent().next();
    checkBox.prop('checked', true);
    $(this).parent().remove();
    if (img_count == 10) {
      $(".file-label").attr("style", "display: flex;");
    }
    if (img_count == 2) {
      hiddenButton();
    }
    img_count -= 1;
  });
});