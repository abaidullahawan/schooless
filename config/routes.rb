Rails.application.routes.draw do
  resources :widows do
    member do
      get "pay_now"
    end
  end
  get 'unpaid_students/index'

  resources :salaries do
    member do
      get :edit_advance
      get :show_advance
      get "salary_info_for_teacher/:id" => "salaries#salary_info_for_teacher", as: :salary_info_for_teacher
    end
    collection do
      get :advance
    end
  end
  get 'reports/index'

  get 'reports/chart'

  resources :expenses
  resources :school_branches do
    collection do
      get 'school_branches/new_month'
    end
  end
  resources :staffs do
    member do
      get :salary_info
    end
  end
  resources :teachers do
    member do
      get :salary_info
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :students do
    member do
      get "activate"
      get "terminate"
      get "pay_now"
    end
  end
  resources :student_fees do
    collection do
      get "get_monthly_fee_balance"
    end
  end
  resources :class_sections
  resources :sections
  resources :schools
  resources :levels
  resources :home, only: [:index]
  resources :reports, only: [:index, :chart]
  resources :unpaid_students, only: [:index] do
    member do
      get "pay_now/:pay_date" => "unpaid_students#pay_now", as: :pay_now
      get "print"
      get "sms_to_student"

      get 'print_fee_challan', as: :print_fee_challan
    end
    collection do
      get "unpaid_funds_students" , as: :unpaid_funds_students
      get "print_all"
      get "print_all_without_balance"
      get "print_for_all"
      get "active_student_list" , as: :active_student_list
      get "deserving_student_list", as: :deserving_student_list
      get "student_list", as: :student_list
      get "sms_to_all_student", as: :sms_to_all

      get 'print_all_fee_challan', as: :print_all_fee_challan
    end
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
end
