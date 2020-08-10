$(function() {
  function appendOption(category) {
    let html = `<option value=${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  };

  function appendChildrenBox(insertHTML){
    let childSelectHtml = `<select id="category_child" name="product[category_id]" style="width: 100%;height: 3.5rem;margin-top: 1rem;padding: 0 0.8rem;border: 1px solid #dbdbdb;border-radius: 0.2rem;">
                             <option value="---" data-category="---">---</option>
                             ${insertHTML}
                           </select>`;
    $('#category_parent').parent().append(childSelectHtml);
  }

  function appendGrandChildrenBox(insertHTML){
    let grandChildSelectHtml = `<select id="category_grandchild" name="product[category_id]" style="width: 100%;height: 3.5rem;margin-top: 1rem;padding: 0 0.8rem;border: 1px solid #dbdbdb;border-radius: 0.2rem;">
                                  <option value="---" data-category="---">---</option>
                                  ${insertHTML}
                                </select>`;
    $('#category_parent').parent().append(grandChildSelectHtml);
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
});