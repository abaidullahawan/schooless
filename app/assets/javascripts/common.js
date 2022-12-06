document.addEventListener("turbolinks:load", function() {
  $('.datepicker').datetimepicker({
    format: "DD-MM-YYYY"
  });

  setTimeout(function(){
    $(".select_chosen").chosen();
  }, 100);
});

$(document).ready(function(){
  $(".closeModel").click(function(){ $("#salaryModel").hide("model"); });
  $('.datepicker').datetimepicker({
    format: "DD-MM-YYYY"
  });
  setTimeout(function(){
    $(".select_chosen").chosen();
  }, 100);
});


function close_model(model_id){
  $("#"+model_id).hide("model");
}

function toggle_fee_fields(fee_type){
  if(fee_type != "Fee"){
    $("#monthly_fee_dev").addClass("hidden");
    $("#balance_div").addClass("hidden");
  }else{
    $("#monthly_fee_dev").removeClass("hidden");
    $("#balance_div").removeClass("hidden");
  }
}


function set_paper_new_balance()
{
  original_fee = $("#student_paper_fund").val();
  student_fee_paid_fee = $(".paper_fund_paid_fee").val();
  total_paid = parseInt(student_fee_paid_fee)
  total_paid = parseInt(student_fee_paid_fee)
  original_balance = $(".student_paper_fund_balance").val();
  if(parseInt(original_balance)<0)
    new_balance = parseInt(original_balance)+parseInt(student_fee_paid_fee);
  else
    new_balance = parseInt(student_fee_paid_fee)-parseInt(original_fee);
  $(".paper_fund_balance").val(new_balance);
  $(".student_fee_paper_fund_balance").val(new_balance);
  // fee_html = 'Student Paying Paper Fund: Rs. <strong>'+total_paid+'</strong> and balance Rs. <strong>'+new_balance+'</strong>';
  // $("#calculated_fee_model_text").html(fee_html);
  // $("#FeeModel").show("model");
}
function set_security_new_balance()
{
  original_fee = $("#student_security").val();
  student_fee_paid_fee = $(".security_paid_fee").val();
  total_paid = parseInt(student_fee_paid_fee)
  total_paid = parseInt(student_fee_paid_fee)
  original_balance = $(".student_security_balance").val();
  if(parseInt(original_balance)<0)
    new_balance = parseInt(original_balance)+parseInt(student_fee_paid_fee);
  else
    new_balance = parseInt(student_fee_paid_fee)-parseInt(original_fee);
  $(".security_balance").val(new_balance);
  $(".student_fee_security_balance").val(new_balance);
  // fee_html = 'Student Paying Security: Rs. <strong>'+total_paid+'</strong> and balance Rs. <strong>'+new_balance+'</strong>';
  // $("#calculated_fee_model_text").html(fee_html);
  // $("#FeeModel").show("model");
}
function set_admission_new_balance()
{
  original_fee = $("#student_admission").val();
  student_fee_paid_fee = $(".admission_paid_fee").val();
  total_paid = parseInt(student_fee_paid_fee)
  total_paid = parseInt(student_fee_paid_fee)
  original_balance = $(".student_admission_balance").val();
  if(parseInt(original_balance)<0)
    new_balance = parseInt(original_balance)+parseInt(student_fee_paid_fee);
  else
    new_balance = parseInt(student_fee_paid_fee)-parseInt(original_fee);
  $(".student_fee_admission_balance").val(new_balance);
  $(".admission_balance").val(new_balance);
  // fee_html = 'Paying Admission Fee: Rs. <strong>'+total_paid+'</strong> and balance Rs. <strong>'+new_balance+'</strong>';
  // $("#calculated_fee_model_text").html(fee_html);
  // $("#FeeModel").show("model");
}
function set_new_balance(){
  original_fee = $("#original_fee").val();
  already_paid_fee = $("#already_paid_fee").val();
  student_fee_paid_fee = $("#student_fee_paid_fee").val();
  total_paid = parseInt(student_fee_paid_fee)
  if (already_paid_fee != undefined){
    total_paid = parseInt(already_paid_fee) + parseInt(student_fee_paid_fee)
  }
  original_balance = $("#original_balance").val();
  if (already_paid_fee != undefined && already_paid_fee.length > 0){
    new_balance = parseInt(original_balance) + parseInt(student_fee_paid_fee);
  }else{
    new_balance = parseInt(original_balance) + (parseInt(total_paid) - parseInt(original_fee));
  }
  $("#student_fee_balance").val(new_balance);

  // fee_html = 'Student Paying Fee: Rs. <strong>'+total_paid+'</strong> and balance Rs. <strong>'+new_balance+'</strong>';
  // $("#calculated_fee_model_text").html(fee_html);
  // $("#FeeModel").show("model");
}

function set_balance_fee(){

  $("#fee_father_school_branch").addClass('hidden');
  path = "/student_fees/get_monthly_fee_balance";
  params= {
          student_id: $("#student_fee_student_id").val()
          }

  ajaxCall(path, params, set_balances);
}

function set_balances(data){
  if (data.need_fee_option == "no"){
    $("#student_fee_fee_type option[value='Fee']").remove();
  }else if ($("#student_fee_fee_type option[value='Fee']").length == 0){
    $("#student_fee_fee_type").append('<option value="Fee">Fee</option>');
  }
  $("#fee_father_school_branch").removeClass('hidden');
  $("#fee_father_name").val(data.father_name);
  $("#fee_school_branch").val(data.school_branch);
  $("#fee_level").val(data.level);
  $("#fee_section").val(data.section);
  $("#original_fee").val(data.monthly_fee);
  $("#student_fee_balance").val(data.balance);
  $("#original_balance").val(data.balance);

  if (data.need_fee_option == "no"){
    fee_html = 'Student <strong>'+data.monthly_fee+'</strong> and balance Rs. <strong>'+data.balance+'</strong>';
  }else{
    fee_html = 'Student Fee: Rs. <strong>'+data.monthly_fee+'</strong> and balance Rs. <strong>'+data.balance+'</strong>';
  }
  $("#calculated_fee_model_text").html(fee_html);
  $("#FeeModel").show("model");

}

function toggle_teacher_staff(selected_value){
  $("#teacher_monthly_salary").val('');
  $("#teacher_salary_per_day").val('');
  $("#staff_monthly_salary").val('');
  $("#staff_salary_per_day").val('');
  $("#salary_paid_salary").val('');
  $("#salary_leaves_in_month").val('');
  $("#advance_salary_info").addClass("hidden");
  $("#calculate_teach_staff_salary_btn").addClass("hidden");
  if(selected_value == "Teacher"){
    $("#salary_staff_id").val("");
    $("#staff_options_list").addClass('hidden');
    $("#teacher_options_list").removeClass('hidden');
    $("#salary_teacher_id").attr("required", "required");
    $("#salary_staff_id").removeAttr("required");
  }else if(selected_value == "Staff"){
    $("#salary_teacher_id").val("");
    $("#teacher_options_list").addClass('hidden');
    $("#staff_options_list").removeClass('hidden');
    $("#salary_teacher_id").removeAttr("required");
    $("#salary_staff_id").attr("required", "required");
  }else{
    $("#staff_options_list").addClass('hidden');
    $("#teacher_options_list").addClass('hidden');
    $("#salary_teacher_id").removeAttr("required");
    $("#salary_staff_id").removeAttr("required");
  }
}

function daysInThisMonth() {
  var now = new Date();
  return new Date(now.getFullYear(), now.getMonth()+1, 0).getDate();
}

function calculate_teach_staff_salary(){
  advance_amount = $("#salary_advance").val();
  if(advance_amount == ""){
    advance_amount = 0;
  }
  leaves_in_month = $("#salary_leaves_in_month").val();
  if(leaves_in_month == ""){
    leaves_in_month = 0;
  }
  if ($("#salary_paid_to").val() == "Teacher"){
    salary_per_day = $("#teacher_salary_per_day").val();
  }else if ($("#salary_paid_to").val() == "Staff"){
    salary_per_day = $("#staff_salary_per_day").val();
  }
  salary_to_pay = parseFloat(salary_per_day)*(parseInt(daysInThisMonth()) - parseInt(leaves_in_month));

  //after advance deduct
  total_salary_to_pay = parseFloat(salary_to_pay) - parseFloat(advance_amount);
  $("#salary_paid_salary").val(Math.round(total_salary_to_pay));

  $("#calculate_teach_staff_salary_btn").removeClass("hidden");
  if(parseInt(leaves_in_month) > 0){
    $("#calculated_salary_model_text").html("After advance and leaves amount deducted");
  }else{
    $("#calculated_salary_model_text").html("After advance deducted");
  }
  $("#calculated_salary_model").text(Math.round(total_salary_to_pay));
  $("#salaryModel").show("model");
}
function set_teacher_salary_info(selected_value){
  path = "/teachers/"+selected_value+"/salary_info";
  params= {}

  ajaxCall(path, params, set_teacher_salary_detail);
}
function set_teacher_salary_detail(data){
  $("#teacher_monthly_salary").val(data.monthly_salary);
  $("#teacher_salary_per_day").val(data.daily_Salary);
  $("#teacher_class").val(data.level_name);
  $("#teacher_section").val(data.section_name);
  $("#teacher_salary_info").removeClass("hidden");
  $("#advance_salary_info").removeClass("hidden");
  $("#salary_advance").val(data.advance_amount);

  $("#calculate_teach_staff_salary_btn").removeClass("hidden");
  total_salary_to_pay = parseFloat(data.monthly_salary) - parseFloat(data.advance_amount);
  $("#salary_paid_salary").val(Math.round(total_salary_to_pay));
  $("#calculated_salary_model").text(Math.round(total_salary_to_pay));
  $("#salaryModel").show("model");

}

function set_staff_salary_info(selected_value){
  path = "/staffs/"+selected_value+"/salary_info";
  params= {}

  ajaxCall(path, params, set_staff_salary_detail);
}

function sms_to_student(data){
  path = "/unpaid_students/"+data+"/sms_to_student";
  params= {}
  ajaxCall(path, params, set_sms_response);
}
function sms_to_all(data){
  path = "/unpaid_students/sms_to_all_student";
  params= {}
  ajaxCall(path, params, set_sms_response);
}

function set_sms_response(data)
{

}

function set_staff_salary_detail(data){
  $("#staff_monthly_salary").val(data.monthly_salary);
  $("#staff_salary_per_day").val(data.daily_Salary);
  $("#staff_salary_info").removeClass("hidden");
  $("#advance_salary_info").removeClass("hidden");
  $("#salary_advance").val(data.advance_amount);

  $("#calculate_teach_staff_salary_btn").removeClass("hidden");
  total_salary_to_pay = parseFloat(data.monthly_salary) - parseFloat(data.advance_amount);
  $("#salary_paid_salary").val(Math.round(total_salary_to_pay));
  $("#calculated_salary_model").text(Math.round(total_salary_to_pay));
  $("#salaryModel").show("model");
}

function set_teacher_advance_info(selected_value){
  path = "/teachers/"+selected_value+"/salary_info";
  params= {}

  ajaxCall(path, params, set_teacher_advance_detail);
}
function set_teacher_advance_detail(data){
  $("#advance_amount_taken").val(data.advance_amount);
  $("#advance_amount_taken_div").removeClass("hidden");
}

function set_staff_advance_info(selected_value){
  path = "/staffs/"+selected_value+"/salary_info";
  params= {}

  ajaxCall(path, params, set_teacher_advance_detail);
}
function set_staff_advance_detail(data){
  $("#advance_amount_taken").val(data.advance_amount);
  $("#advance_amount_taken_div").removeClass("hidden");
}

function ajaxCall(path, params, return_method, methodType = "get"){
  $.ajax( {
    url: path,
    type: methodType,
    dataType: 'json',
    data: params,
    error: function(jqXHR, textStatus, errorThrown) {
      return console.log("AJAX Error: " + textStatus);
    },
    success: function(data) {
      return_method(data)
    }
});
}

function countChar(val) {
  var len = val.value.length;
  if (len >= 160) {
    $('#later').text(160 - len);
     // val.value = val.value.substring(0, 160);
  } else {
    $('#later').text(160 - len);
  }
  if (len >= 70) {
    // val.value = val.value.substring(0, 160);
    $('#later_urdu').text(70 - len);
  }else{
    $('#later_urdu').text(70 - len);
  }
};

function toggle_class(tag_id, class_toggle){
  $("#"+tag_id).toggleClass(class_toggle);
}
