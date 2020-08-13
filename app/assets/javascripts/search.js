$(function() {
  $('#price_range').change(function() {
    let price = $(this).val();
    if (price == 1) {
      $('#q_price_gteq').val(300);
      $('#q_price_lteq').val(1000);
    } else if (price == 2) {
      $('#q_price_gteq').val(1000);
      $('#q_price_lteq').val(5000);
    } else if (price == 3) {
      $('#q_price_gteq').val(5000);
      $('#q_price_lteq').val(10000);
    } else if (price == 4) {
      $('#q_price_gteq').val(10000);
      $('#q_price_lteq').val(30000);
    } else if (price == 5) {
      $('#q_price_gteq').val(30000);
      $('#q_price_lteq').val(50000);
    } else if (price == 6) {
      $('#q_price_gteq').val(50000);
      $('#q_price_lteq').val('');
    };
  });

  $('#condition_id_all').change(function() {
    let condition = $(this).prop('checked');
    if (condition == true) {
      $('.condition_checkbox').prop('checked', true)
    } else if (condition == false) {
      $('.condition_checkbox').prop('checked', false)
    };
  });

  $('#postage_payer_id_all').change(function() {
    let postagePayer = $(this).prop('checked');
    if (postagePayer == true) {
      $('.postage_payer_checkbox').prop('checked', true)
    } else if (postagePayer == false) {
      $('.postage_payer_checkbox').prop('checked', false)
    };
  });

  $('#trading_status_all').change(function() {
    let trading = $(this).prop('checked');
    if (trading == true) {
      $('.trading_checkbox').prop('checked', true)
    } else if (trading == false) {
      $('.trading_checkbox').prop('checked', false)
    };
  });

  $(document).on('change', '#q_category_id_all', function() {
    let category = $(this).prop('checked');
    if (category == true) {
      $('.category_checkbox').prop('checked', true)
    } else if (category == false) {
      $('.category_checkbox').prop('checked', false)
    };
  });

  $('#clear_button').on('click', function() {
    $('input[type=text]').val('');
    $('input[type=search]').val('');
    $('input[type=number]').val('');
    $('input[type=checkbox]').prop('checked', false);
    $('select').val('');
  })
});