json.extract! student, :id, :name, :date_of_birth, :phone_no, :monthly_fee, :address, :class_section_id, :created_at, :updated_at
json.url student_url(student, format: :json)
