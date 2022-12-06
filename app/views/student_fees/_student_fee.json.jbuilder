json.extract! student_fee, :id, :paid_date, :paid_fee, :balance, :fee_type, :student_id, :created_at, :updated_at
json.url student_fee_url(student_fee, format: :json)
