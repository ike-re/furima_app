$(function() {
  function appendOption(category) {
    let html = `<option value=${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  };

  function appendInput(category, i) {
    let html = `<input type="checkbox" name="q[category_id_in][]" value=${category.id}" data-category="${category.id}" id="q_category_id_${i}" class="category_checkbox" style="margin:0.2rem 0.7rem 0 0.5rem;transform: scale(1.6);">
                <label for="q_category_id_${i}" style="width: 35%;margin-bottom: 1rem;font-size: 0.9rem">${category.name}</label>`;
    return html;
  };

  function appendChildrenBox(insertHTML){
    let childSelectHtml = `<select id="category_child" name="product[category_id]" style="width: 100%;height: 3.5rem;margin-top: 1rem;padding: 0 0.8rem;border: 1px solid #dbdbdb;border-radius: 0.2rem;">
                             <option value="---" data-category="---">---</option>
                             ${insertHTML}
                           </select>`;
    $('#category_parent').parent().append(childSelectHtml);
  }

  function appendChildrenSearchBox(insertHTML){
    let childSelectHtml = `<select id="search_category_child" name="product[category_id]" style="width: 100%;height: 3.5rem;margin-top: 1rem;padding: 0 0.8rem;border: 1px solid #dbdbdb;border-radius: 0.2rem;">
                             <option value="---" data-category="---">---</option>
                             ${insertHTML}
                           </select>`;
    $('#search_category_parent').parent().append(childSelectHtml);
  }

  function appendGrandChildrenBox(insertHTML){
    let grandChildSelectHtml = `<select id="category_grandchild" name="product[category_id]" style="width: 100%;height: 3.5rem;margin-top: 1rem;padding: 0 0.8rem;border: 1px solid #dbdbdb;border-radius: 0.2rem;">
                                  <option value="---" data-category="---">---</option>
                                  ${insertHTML}
                                </select>`;
    $('#category_parent').parent().append(grandChildSelectHtml);
  }

  function appendGrandChildrenCheckBox(insertHTML){
    let grandChildInputHtml = `<div id="search_category_grandchild" style="margin-top: 1rem;display: flex;flex-wrap: wrap;justify-content: flex-start;">
                                 <input type="checkbox" id="q_category_id_all" name="product[category_id]" style="margin:0.2rem 0.7rem 0 0.5rem;transform: scale(1.6);">
                                 <label for="q_category_id_all" style="width: 35%;margin-bottom: 1rem;font-size: 0.9rem">すべて</label>
                               ${insertHTML}
                               </div>`;
    $('#search_category_parent').parent().append(grandChildInputHtml);
  }

  $('#category_parent').on('change', function() {
    let parentValue = $(this).val();
    $.ajax( {
      url: '/products/search_category_children',
      type: 'GET',
      data: { parent_id: parentValue },
      dataType: 'json'
    })
    .done(function(children) {
      $('#category_child').remove();
      $('#category_grandchild').remove();
      $('#size-field-new').attr('style', 'display: none;');
      $('#size-field-edit').attr('style', 'display: none;');
      let insertHTML = '';
        $.each(children, function(i, child) {
          insertHTML += appendOption(child);
        });
        appendChildrenBox(insertHTML);
    })
    .fail(function() {
      $('#category_child').remove();
      $('#category_grandchild').remove();
      $('#size-field-new').attr('style', 'display: none;');
      $('#size-field-edit').attr('style', 'display: none;');
    })
  });

  $('#search_category_parent').on('change', function() {
    let parentValue = $(this).val();
    $.ajax( {
      url: '/products/search_category_children',
      type: 'GET',
      data: { parent_id: parentValue },
      dataType: 'json'
    })
    .done(function(children) {
      $('#search_category_child').remove();
      $('#search_category_grandchild').remove();
      let insertHTML = '';
        $.each(children, function(i, child) {
          insertHTML += appendOption(child);
        });
        appendChildrenSearchBox(insertHTML);
    })
    .fail(function() {
      $('#search_category_child').remove();
      $('#search_category_grandchild').remove();
    })
  });

  $(document).on('change', '#category_child', function() {
    let childValue = $(this).val();
    $.ajax( {
      url: '/products/search_category_grandchildren',
      type: 'GET',
      data: { child_id: childValue },
      dataType: 'json'
    })
    .done(function(grandChildren) {
      $('#category_grandchild').remove();
      $('#size-field-new').attr('style', 'display: none;');
      $('#size-field-edit').attr('style', 'display: none;');
      let insertHTML = '';
        $.each(grandChildren, function(i, grandChild) {
          insertHTML += appendOption(grandChild);
        });
        appendGrandChildrenBox(insertHTML);
    })
    .fail(function() {
      $('#category_grandchild').remove();
      $('#size-field-new').attr('style', 'display: none;');
      $('#size-field-edit').attr('style', 'display: none;');
    })
  });

  $(document).on('change', '#category_grandchild', function() {
    if ($(this).val() == '---') {
      $('#size-field-new').attr('style', 'display: none;');
      $('#size-field-edit').attr('style', 'display: none;');
    } else {
      $('#size-field-new').attr('style', 'display: block;');
      $('#size-field-edit').attr('style', 'display: block;');
    };
  });

  $(document).on('change', '#search_category_child', function() {
    console.log("hoge");
    let childValue = $(this).val();
    $.ajax( {
      url: '/products/search_category_grandchildren',
      type: 'GET',
      data: { child_id: childValue },
      dataType: 'json'
    })
    .done(function(grandChildren) {
      $('#search_category_grandchild').remove();
      let insertHTML = '';
      let input_index = 0
        $.each(grandChildren, function(i, grandChild) {
          insertHTML += appendInput(grandChild, input_index);
          input_index += 1
        });
        appendGrandChildrenCheckBox(insertHTML);
    })
    .fail(function() {
      $('#search_category_grandchild').remove();
    })
  });
});