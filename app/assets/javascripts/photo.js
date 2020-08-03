$(function() {
  $('label[class=file-label]').after('<div class="fileimg" style="display: flex;flex-wrap: wrap;"><div/>');

  img_count = 0
  img_index = 0
  $('.file-label').on('click', function() {
    $('.fileinput').change(function() {
      let label = $('#files').find('label')
      let file = $(this).prop('files')[0];
    
      if (! file.type.match('image.*')) {
        alert('この形式のファイルはアップロードできません');
        $(this).remove();
        label.attr('for', `filearea${img_index + 1}`);
        label.before(`<input name="product[photos_attributes][${img_index + 1}][image]" id="filearea${img_index + 1}" type="file" class="fileinput fileinput${img_index + 1}" style="display: none;">`);
        img_index += 1
        return;
      } else {
        let reader = new FileReader();
        reader.onload = function() {
          let img_src = $('<img style="width: 7rem;height: 7rem;">').attr('src', reader.result);
          let box = $(`<div class="fileinput${img_index - 1}" style="margin-bottom: 0.3rem;background: whitesmoke;display: flex;flex-direction: column;justify-content: center;align-items: center;"></div>`);
          let box2 =  box.append(img_src).append('<p class="deletefile" style="margin: 0;padding: 0.2rem;color: #4897d8;font-size: 0.9rem;font-weight: normal;cursor: pointer;">削除</p>');
          $('.fileimg').append(box2);
        }
        reader.readAsDataURL(file);
        label.attr('for', `filearea${img_index + 1}`);
        label.before(`<input name="product[photos_attributes][${img_index + 1}][image]" id="filearea${img_index + 1}" type="file" class="fileinput fileinput${img_index + 1}" style="display: none;">`);
        img_count += 1
        img_index += 1
        if (img_count == 10) {
          label.attr('style', 'display: none;');
        }
      }
    });
  });

  $(document).on('click', '.deletefile', function() {
    boxClass = $(this).parent().prop('class');
    $(`.${boxClass}`).remove();
    if (img_count == 10) {
      $('.file-label').attr('style', 'display: flex;')
    }
    img_count -= 1
  });
});